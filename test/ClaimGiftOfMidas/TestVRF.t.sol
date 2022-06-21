// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "src/GiftOfMidas.sol";
import "src/ClaimGiftOfMidas.sol";
import "../mocks/MockVRFCoordinatorV2.sol";
import "../mocks/MockERC721.sol";
import "../mocks/MockERC1155.sol";
import "../mocks/LinkToken.sol";
import "forge-std/Test.sol";
import "@ERC721A/contracts/interfaces/IERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestVRF is Test {
    MockERC721 public mockERC721;
    MockERC1155 public mockERC1155;
    MockERC1155 public mockERC1155N2;
    LinkToken public linkToken;
    MockVRFCoordinatorV2 public vrfCoordinator;
    GiftOfMidas public giftOfMidas;
    ClaimGiftOfMidas public vrfConsumer;


    uint96 constant FUND_AMOUNT = 1 * 10 ** 18;
    // Initialized as blank, fine for testing
    uint64 subId;
    bytes32 keyHash; // gasLane
    event ReturnedRandomness(uint256[] randomWords);

    address userOne = vm.addr(1);
    address userTwo = vm.addr(2);
    address userThree = vm.addr(3);

    function setUp() public {
        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        mockERC1155 = new MockERC1155();
        mockERC1155N2 = new MockERC1155();
        giftOfMidas.togglePublicSaleOpen();
        hoax(userTwo);
        giftOfMidas.publicMint{value : 1 ether}(20);
        mockERC721 = new MockERC721();
        vm.startPrank(userOne);
        mockERC721.mint();
        mockERC721.mint();
        mockERC1155.mint(0, 9);
        mockERC1155N2.mint(2, 9);
        vm.stopPrank();

        linkToken = new LinkToken();
        vrfCoordinator = new MockVRFCoordinatorV2();
        subId = vrfCoordinator.createSubscription();
        vrfCoordinator.fundSubscription(subId, FUND_AMOUNT);

        vrfConsumer = new ClaimGiftOfMidas(
            address(giftOfMidas),
            address(userOne),
            subId,
            address(vrfCoordinator),
            address(linkToken),
            keyHash
        );
        vrfCoordinator.addConsumer(subId, address(vrfConsumer));

        vm.startPrank(userOne);
        mockERC721.setApprovalForAll(address(vrfConsumer), true);
        vrfConsumer.addLegendaryPrize(address(mockERC721), 0);
        vrfConsumer.addLegendaryPrize(address(mockERC721), 1);
        mockERC1155.setApprovalForAll(address(vrfConsumer), true);
        vrfConsumer.addCommonPrize(address(mockERC1155), 0, 9);
        mockERC1155N2.setApprovalForAll(address(vrfConsumer), true);
        vrfConsumer.addCommonPrize(address(mockERC1155N2), 2, 9);
        vm.stopPrank();

    }

    function test_can_request_randomness() public {
        uint256 startingRequestId = vrfConsumer.s_requestId();
        vrfConsumer.requestRandomWords(2, 60000);
        assertTrue(vrfConsumer.s_requestId() != startingRequestId);
    }

    function test_can_get_random_response() public {
        uint32 sWordsCount = 2;
        vrfConsumer.requestRandomWords(sWordsCount, 100000);
        uint256 requestId = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId, address(vrfConsumer));

        uint256[] memory words = getWords(requestId, sWordsCount);


        assertTrue(vrfConsumer.s_randomWords(0) == words[0]);
        assertTrue(vrfConsumer.s_randomWords(1) == words[1]);
    }

    function test_emits_event_on_fulfillment() public {
        uint32 sWordsCount = 2;
        vrfConsumer.requestRandomWords(sWordsCount, 100000);
        uint256 requestId = vrfConsumer.s_requestId();

        uint256[] memory words = getWords(requestId, sWordsCount);

        vm.expectEmit(false, false, false, true);
        emit ReturnedRandomness(words);
        vrfCoordinator.fulfillRandomWords(requestId, address(vrfConsumer));
    }

    function testGenerateWinners() public {
        uint32 sWordsCount = 2;
        vrfConsumer.requestRandomWords(sWordsCount, 100000);
        uint256 requestId = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId, address(vrfConsumer));

        uint256[] memory words = getWords(requestId, sWordsCount);

        vrfConsumer.generateWinners();
        assertTrue(vrfConsumer.s_randomWords(0) == words[0] % giftOfMidas.totalSupply());
        assertTrue(vrfConsumer.s_randomWords(1) == words[1] % giftOfMidas.totalSupply());
        assertTrue(vrfConsumer.GOMTokenIdToLegendaryPrizeId(1) == 1);
        assertTrue(vrfConsumer.GOMTokenIdToLegendaryPrizeId(19) == 2);

    }


    function getWords(uint256 requestId, uint32 s_amount)
    public
    view
    returns (uint256[] memory)
    {
        uint256[] memory words = new uint256[](s_amount);
        for (uint256 i = 0; i < s_amount; i++) {
            words[i] = uint256(keccak256(abi.encode(requestId, i)));
        }
        return words;
    }
}

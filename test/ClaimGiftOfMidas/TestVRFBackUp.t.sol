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

contract TestVRFBackUp is Test {
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
        giftOfMidas.publicMint{value : 1 ether}(2);
        mockERC721 = new MockERC721();
        vm.startPrank(userOne);
        mockERC721.mint();
        mockERC721.mint();
        //        mockERC1155.mint(0, 9);
        //        mockERC1155N2.mint(2, 9);
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
        //        mockERC1155.setApprovalForAll(address(vrfConsumer), true);
        //        vrfConsumer.addCommonPrize(address(mockERC1155), 0, 9);
        //        mockERC1155N2.setApprovalForAll(address(vrfConsumer), true);
        //        vrfConsumer.addCommonPrize(address(mockERC1155N2), 2, 9);
        vm.stopPrank();


    }

    function testBackUpWinnerSet() public {
        uint32 sWordsCount = 2;
        vrfConsumer.requestRandomWords(sWordsCount, 100000);
        uint256 requestId = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId, address(vrfConsumer));

        uint256[] memory words = getWords(requestId, sWordsCount);

        vrfConsumer.generateWinners();
        assertTrue(vrfConsumer.s_randomWords(0) == words[0] % giftOfMidas.totalSupply());
        // 1
        assertTrue(vrfConsumer.s_randomWords(1) == words[1] % giftOfMidas.totalSupply());
        // 1

        assertTrue(vrfConsumer.GOMTokenIdToLegendaryPrizeId(1) == 1);

        vrfConsumer.requestRandomWords(1, 100000);
        uint256 requestId2 = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId2, address(vrfConsumer));
        vrfConsumer.setWinner(0, 1);

        vrfConsumer.requestRandomWords(1, 100000);
        uint256 requestId3 = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId3, address(vrfConsumer));
        vrfConsumer.setWinner(0, 1);

        vrfConsumer.requestRandomWords(1, 100000);
        uint256 requestId4 = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId4, address(vrfConsumer));
        vrfConsumer.setWinner(0, 1);

        vrfConsumer.requestRandomWords(1, 100000);
        uint256 requestId5 = vrfConsumer.s_requestId();
        vrfCoordinator.fulfillRandomWords(requestId5, address(vrfConsumer));
        vrfConsumer.setWinner(0, 1);

        assertTrue(vrfConsumer.GOMTokenIdToLegendaryPrizeId(0) == 2);
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

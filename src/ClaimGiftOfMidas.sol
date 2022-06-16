// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@ERC721A/contracts/interfaces/IERC721ABurnable.sol";
import "@chainlink/interfaces/LinkTokenInterface.sol";
import "@chainlink/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ClaimGiftOfMidas is VRFConsumerBaseV2, Ownable {
    IERC721ABurnable giftOfMidasInterface;
    uint256 totalGOMTokens;

    uint256[] public legendaryPrizes;
    uint256[] commonPrizes;
    mapping(uint256 => legendaryPrize) public idToLegendaryPrize;
    mapping(uint256 => commonPrize) public idToCommonPrize;
    uint256 commonPrizeCounter;
    uint256 legendaryPrizeCounter = 1; // start at 1 to keep zero as empty value in mapping GOMTokenIdToLegendaryPrizeId
    mapping(uint256 => uint256) public GOMTokenIdToLegendaryPrizeId;
    // address which holds nfts that would be given out
    address holderAddress;
    bool claimOpen;
    uint nonce;

    struct legendaryPrize {
        IERC721 IAddress;
        uint tokenId;
    }

    struct commonPrize {
        IERC1155 IAddress;
        uint tokenId;
        uint amountRemaining;
    }

    error RandomNumbersDontMatchPrizePoolLength();
    error NotAuthorisedToAddPrizes();
    error NotOpenYet();

    event AnnounceWinner(uint256 tokenId, uint256 prizeId);
    event PrizeClaimed(address indexed user, address indexed nftContract, uint256 tokenId);

    function generateWinners() external onlyOwner {
        if (legendaryPrizes.length != s_randomWords.length) revert RandomNumbersDontMatchPrizePoolLength();

        for (uint i = 0; i < s_randomWords.length; i++) {
            uint256 randomTokenId = s_randomWords[i] % totalGOMTokens;
            // Encase unlikely event a tokenId is selected twice
            if (GOMTokenIdToLegendaryPrizeId[randomTokenId] == 0) {
                GOMTokenIdToLegendaryPrizeId[randomTokenId] = legendaryPrizes[i];
                emit AnnounceWinner(randomTokenId, legendaryPrizes[i]);
                //TODO handle remove of prize
            }
        }
    }


    VRFCoordinatorV2Interface immutable COORDINATOR;
    LinkTokenInterface immutable LINKTOKEN;
    uint64 immutable s_subscriptionId;
    bytes32 immutable s_keyHash;
    uint32 immutable s_callbackGasLimit = 100000;
    uint16 immutable s_requestConfirmations = 3;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;


    event ReturnedRandomness(uint256[] randomWords);

    /**
     * @notice Constructor inherits VRFConsumerBaseV2
     *
     * @param subscriptionId - the subscription ID that this contract uses for funding requests
     * @param vrfCoordinator - coordinator, check https://docs.chain.link/docs/vrf-contracts/#configurations
     * @param keyHash - the gas lane to use, which specifies the maximum gas price to bump to
     */
    constructor(
        address giftOfMidas,
        address _holderAddress,
        uint64 subscriptionId,
        address vrfCoordinator,
        address link,
        bytes32 keyHash
    ) VRFConsumerBaseV2(vrfCoordinator) {
        giftOfMidasInterface = IERC721ABurnable(giftOfMidas);
        totalGOMTokens = giftOfMidasInterface.totalSupply();
        holderAddress = _holderAddress;
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link);
        s_keyHash = keyHash;
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    function claimPrize(uint256 tokenId) external {
        if (!claimOpen) revert NotOpenYet();
        giftOfMidasInterface.burn(tokenId);
        if (GOMTokenIdToLegendaryPrizeId[tokenId] != 0) {
            claimLegendaryPrize(tokenId);
        }
        else {
            claimCommonPrize();
        }
    }

    function claimLegendaryPrize(uint256 tokenId) internal {
        legendaryPrize memory prize = idToLegendaryPrize[GOMTokenIdToLegendaryPrizeId[tokenId]];
        prize.IAddress.safeTransferFrom(holderAddress, msg.sender, prize.tokenId, "");

        emit PrizeClaimed(msg.sender, address(prize.IAddress), prize.tokenId);
        delete GOMTokenIdToLegendaryPrizeId[tokenId];
    }

    function claimCommonPrize() internal {
        uint prizeIndexToClaim = generateRandomNumber(commonPrizes.length);
        uint commonPrizeId = commonPrizes[prizeIndexToClaim];
        commonPrize storage prize = idToCommonPrize[commonPrizeId];
        prize.amountRemaining--;
        if (prize.amountRemaining == 0) {
            _removePrize(prizeIndexToClaim, commonPrizes);
        }
        prize.IAddress.safeTransferFrom(holderAddress, msg.sender, prize.tokenId, 1, "");
        emit PrizeClaimed(msg.sender, address(prize.IAddress), prize.tokenId);
    }

    function addLegendaryPrize(address _address, uint _tokenId) external {
        if (msg.sender != holderAddress) revert NotAuthorisedToAddPrizes();
        legendaryPrize memory _prize = legendaryPrize(IERC721(_address), _tokenId);
        uint256 id = legendaryPrizeCounter++;
        idToLegendaryPrize[id] = _prize;
        legendaryPrizes.push(id);
    }

    function addCommonPrize(address _address, uint _tokenId, uint _quantity) external {
        if (msg.sender != holderAddress) revert NotAuthorisedToAddPrizes();
        commonPrize memory _prize = commonPrize(IERC1155(_address), _tokenId, _quantity);
        uint256 id = commonPrizeCounter++;
        idToCommonPrize[id] = _prize;
        commonPrizes.push(id);
    }

    function _removePrize(uint256 _index, uint256[] storage prizes) internal {
        // swap and pop to remove element from array so it only contains active prizes without gaps in array
        uint256 lastIndex = prizes.length - 1;
        prizes[_index] = prizes[lastIndex];
        prizes.pop();
    }


    function toggleClaimOpen() onlyOwner external {
        claimOpen = !claimOpen;
    }

    /**
     * @notice generates a sudo random number
     * A sudo random number generator used for choosing common prizes where true randomness is not needed
     */
    function generateRandomNumber(uint maxNumber) internal returns (uint) {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % maxNumber;
        nonce++;
        return randomNumber;
    }

    /**
     * @notice Requests randomness
     * Assumes the subscription is funded sufficiently; "Words" refers to unit of data in Computer Science
     */
    function requestRandomWords() external onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            s_requestConfirmations,
            s_callbackGasLimit,
            uint32(legendaryPrizes.length)
        );
    }

    /**
     * @notice Callback function used by VRF Coordinator
     *
     * @param requestId - id of the request
     * @param randomWords - array of random results from VRF Coordinator
     */
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
    internal
    override
    {
        s_randomWords = randomWords;
        emit ReturnedRandomness(randomWords);
    }

}

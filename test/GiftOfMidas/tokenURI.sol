// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/GiftOfMidas.sol";
import "../utils/CheatCodes.sol";
import "@ERC721A/contracts/IERC721A.sol";

contract GiftOfMidasTest is Test {

    CheatCodes cc = CheatCodes(HEVM_ADDRESS);
    GiftOfMidas public giftOfMidas;

    address userOne = cc.addr(1);
    address userTwo = cc.addr(2);

    uint MAX_MINTS = 20;

    bytes32[] userOneMerkleProof;

    function setUp() public {

        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        giftOfMidas.togglePublicSaleOpen();
        giftOfMidas.publicMint{value : 0.5 ether}(10);
    }


    function testSetURI() public {
        giftOfMidas.setURI("http://testuri.com/");
        string memory tt = "http://testuri.com/";
        assertTrue(keccak256(abi.encodePacked((giftOfMidas.tokenURI(1) ))) == keccak256(abi.encodePacked((tt))));

    }




}

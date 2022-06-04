// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/GiftOfMidas.sol";
import "./utils/CheatCodes.sol";
import "@ERC721A/contracts/IERC721A.sol";

contract GiftOfMidasTest is Test {

    CheatCodes cc = CheatCodes(HEVM_ADDRESS);
    GiftOfMidas public giftOfMidas;

    address userOne = cc.addr(1);
    address userTwo = cc.addr(2);

    uint MAX_MINTS = 20;


    function setUp() public {
        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        giftOfMidas.togglePublicSaleOpen();
        cc.deal(userOne, 10 ether);

    }

    function testCanBurnMinted() public {
        cc.startPrank(userOne);

        giftOfMidas.publicMint{value: 1 ether}(20);
        giftOfMidas.burn(0);
        cc.stopPrank();
    }

    function testCanBurnMintedFull() public {
        cc.startPrank(userOne);
        giftOfMidas.publicMint{value: 1 ether}(20);
        for (uint i=0; i < MAX_MINTS; i++){
            assertTrue(giftOfMidas.ownerOf(i) == userOne);
        }

        for (uint i=0; i < MAX_MINTS; i++){
            giftOfMidas.burn(i);
        }
        cc.stopPrank();
    }

}

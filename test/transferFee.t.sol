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
        hoax(userOne);
        giftOfMidas.publicMint{value: 1 ether}(20);

    }

    function testFee10() public {
        hoax(userOne);
        giftOfMidas.safeTransferFrom(userOne, userTwo, 19);

    }


}

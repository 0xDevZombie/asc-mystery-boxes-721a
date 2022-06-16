// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/GiftOfMidas.sol";
import "./../utils/CheatCodes.sol";
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

    }


    function testWithdraw() public {
        assertTrue(userOne.balance == 0 ether);
        hoax(userTwo);
        giftOfMidas.publicMint{value : 0.5 ether}(10);
        giftOfMidas.withdrawFunds();
        assertTrue(userOne.balance == 0.5 ether);
    }




}

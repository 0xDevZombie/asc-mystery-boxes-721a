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


    function setUp() public {
        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        giftOfMidas.togglePublicSaleOpen();

    }

    function testCanMintFuzz(uint256 _amount) public {
        cc.assume(_amount < MAX_MINTS && _amount > 0);
        uint256 ethValue = _amount * 0.05 ether;
        hoax(userOne);
        giftOfMidas.publicMint{value: ethValue}(_amount);
        for (uint i=0; i < _amount; i++){
            assertTrue(giftOfMidas.ownerOf(i) == userOne);
        }
    }

    function testCanMintMaxAllowance() public {
        hoax(userOne);
        giftOfMidas.publicMint{value: 1 ether}(20);
        for (uint i=0; i < MAX_MINTS; i++){
            assertTrue(giftOfMidas.ownerOf(i) == userOne);
        }
        cc.expectRevert(abi.encodeWithSelector(IERC721A.OwnerQueryForNonexistentToken.selector));
        giftOfMidas.ownerOf(21);
    }

    function testCanMintMaxAllowanceSplit() public {
        hoax(userOne);
        giftOfMidas.publicMint{value: 0.5 ether}(10);
        for (uint i=0; i < 10; i++){
            assertTrue(giftOfMidas.ownerOf(i) == userOne);
        }
        hoax(userOne);
        giftOfMidas.publicMint{value: 0.5 ether}(10);
        for (uint i=10; i < 20; i++){
            assertTrue(giftOfMidas.ownerOf(i) == userOne);
        }
    }

    function testCannotMintMoreThenMaxAllowance() public {
        hoax(userOne);
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.AmountExceedsAllowance.selector));
        giftOfMidas.publicMint{value: 1.05 ether}(21);
    }

    function testCannotMintMoreThenMaxAllowanceSplit() public {
        hoax(userOne);
        giftOfMidas.publicMint{value: 0.55 ether}(11);
        hoax(userOne);
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.AmountExceedsAllowance.selector));
        giftOfMidas.publicMint{value: 0.50 ether}(10);
    }

    function testCannotMintCheaperThenCost() public {
        hoax(userOne);
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.MintPayableTooLow.selector));
        giftOfMidas.publicMint{value: 0.09 ether}(2);
    }
}

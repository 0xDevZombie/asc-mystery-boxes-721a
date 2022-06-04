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

    bytes32[] userOneMerkleProof;


    uint MAX_MINTS = 20;


    function setUp() public {
        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        giftOfMidas.togglePreSaleOpen();
        giftOfMidas.setMerkleRoot(0x3dd73fb4bffdc562cf570f864739747e2ab5d46ab397c4466da14e0e06b57d56);
        userOneMerkleProof.push(0x94a6fc29a44456b36232638a7042431c9c91b910df1c52187179085fac1560e9);

    }


    function testCanMintMaxAllowance() public {
        hoax(userOne);
        giftOfMidas.preSaleMint{value : 0.4 ether}(1, userOneMerkleProof);
        assertTrue(giftOfMidas.ownerOf(0) == userOne);
        cc.expectRevert(abi.encodeWithSelector(IERC721A.OwnerQueryForNonexistentToken.selector));
        giftOfMidas.ownerOf(1);
    }

    function testCannotMintMoreThenMaxAllowance() public {
        hoax(userOne);
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.AmountExceedsAllowance.selector));
        giftOfMidas.preSaleMint{value: 0.08 ether}(2, userOneMerkleProof);
    }
    function testCannotMintCheaperThenCost() public {
        hoax(userOne);
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.MintPayableTooLow.selector));
        giftOfMidas.preSaleMint{value: 0.05 ether}(2, userOneMerkleProof);
    }

}

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

    function setUp() public {
        giftOfMidas = new GiftOfMidas("t", "t", address(userOne));
        giftOfMidas.setMerkleRoot(0x3dd73fb4bffdc562cf570f864739747e2ab5d46ab397c4466da14e0e06b57d56);
        userOneMerkleProof.push(0x94a6fc29a44456b36232638a7042431c9c91b910df1c52187179085fac1560e9);
    }


    function testPresaleNotOpen() public {
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.NotOpenYet.selector));
        hoax(userOne);
        giftOfMidas.preSaleMint{value : 0.4 ether}(1, userOneMerkleProof);
    }

    function testPublicSaleNotOpen() public {
        cc.expectRevert(abi.encodeWithSelector(GiftOfMidas.NotOpenYet.selector));
        hoax(userOne);
        giftOfMidas.publicMint{value: 1 ether}(20);
    }


}

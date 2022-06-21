// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "src/TheAscendantsAccessPass.sol";
import "forge-std/Test.sol";

contract TestRedeem is Test {

    TheAscendantsAccessPass public ap;
    address userOne = vm.addr(1);
    address userTwo = vm.addr(2);

    function setUp() public {
        ap = new TheAscendantsAccessPass();
        ap.mint(userOne, 1, 1, "");
        ap.mint(userTwo, 1, 1, "");
        ap.toggleRedeemOpen();
    }


    function testRedeemToken() public {
        hoax(userOne);
        ap.redeemToken(1);

        hoax(userTwo);
        ap.redeemToken(1);



    }


}

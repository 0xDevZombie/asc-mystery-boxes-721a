// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "@ERC721A/contracts/ERC721A.sol";

contract GiftOfMidas is ERC721A {
    constructor() ERC721A("GiftOfMidas", "GOM") {}

    function mint(uint256 quantity) external payable {
        // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
        _mint(msg.sender, quantity);
    }
}

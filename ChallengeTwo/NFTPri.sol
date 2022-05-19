// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTPri is ERC721{
   uint public constant max_value = 20;
   uint count;
   constructor()ERC721("Priyansu Ka NFT","DN"){}

   function daddyMint() public {
       require(count< max_value,"MAX TOKEN REACHED");
       count++;
       _safeMint(msg.sender,count);
   }
}
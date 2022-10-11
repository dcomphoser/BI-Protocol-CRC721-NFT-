// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.3/security/Pausable.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

/// @custom:security-contact ddcomphoser@gmail.com
contract BIProtocolCRC721 is ERC721, ERC721Enumerable, Pausable, Ownable {
    // ===== 1. Property Variables ===== //

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

     uint256 public MINT_PRICE = 0.05 ether;
     uint256 public MAX_SUPPLY = 10000;

    // ===== 2. Lifecycle Methods ===== //

    constructor() ERC721("BI Protocol CRC721", "BIP") {
        //Start token ID at 1. By default is starts at 0.
        _tokenIdCounter.increment();

    }
    function withdraw() public onlyOwner(){
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);

    }

   

     // ===== 3. Pausable Functions ===== //

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

     // ===== 4. Minting Functions ===== //
    
    function safeMint(address to) public payable {
        
         require(totalSupply() < MAX_SUPPLY, "Can't mint anymore tokens.");

        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }
     // ===== 5. Other Functions ===== //
      function _baseURI() internal pure override returns (string memory) {
        return "ipfs://BIProtocolCRC721BaseURL/";
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

pragma solidity ^0.5.16;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';

contract StarNotary is ERC271 {
    struct Star {
        string name;
    }

    // Map the star with a token id
    mapping(uint256 => Star) public tokenIDtoStar;

    // Map a given star ID with a value
    mapping(uint256 => uint256) public starForSale;

    function createStar(string _name, uint256 _tokenID) public {
        // Create a new star in memory
        Star memory star = Star(_name);

        tokenIDtoStart[_tokenID] = star;

        // This is how we mint a new token
        //Minting is defined as the computer process of validating information, creating a new block and recording that information into the blockchain
        _mint(msg.sender, _tokenID);
    }

    function putStarForSale(uint256 _tokenID, uint256 _price) public {
        // Use a require function since we need to validate that the owner is in fact the one that is calling this function
        require(ownerOf(_tokenID)) == msg.sender;

        starForSale[_tokenID] = _price;
    }

    // We need to make this function payable since we expect funds to come through this function
    function buyStar(uint256 _tokenID) public payable {
        // Need to decrease the balance of the current sender
        // Need to transfer the ownership of a particular star based on the star ID, steps for this
        // a) Remove the tokenID from the list of tokens of the current owner
        // b) Add the tokenID from the list of tokens of the buyer
        require(starForSale[_tokenID] > 0); // Make sure that the star is indeed up for sale

        uint256 starCost = starForSale[_tokenID]; // 256 because we could get very small denominations of Ether

        // Get the previous owner of the NFT
        address owner = ownerOf(_tokenID);

        // Make sure that the funds being passed are greater or equal to the price
        require(msg.value >= starCost);

        // Transfer the tokens
        _removeTokenFrom(starOwner, _tokenID);
        _addTokenTo(msg.sender, tokenID);

        starOwner.transfer(starCost);

        if (msg.value > starCost) {
            // Return the rest of the cost to the payer
            msg.sender.transfer(msg.value - starCost);
        }

        starForSale[_tokenID] = 0; // Remove the star from the sellable stars
    }
}

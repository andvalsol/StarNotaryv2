pragma solidity ^0.4.0;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721.sol'

contract StarNotary is ERC271 {
    struct Star {
        string name;
    }

    // Map the star with a token id
    mapping(uint256 => Star) public tokenIDtoStar;

    // Map a given star ID with a value
    mapping(uint256 => uint256) public starForSale;

    function createStar(string _name, uint256 _tokenID) public {
        Star memory star = Star(_name);

        tokenIDtoStart[_tokenID] = star;

        _mint(msg.sender, _tokenID);
    }

    function putStarForSale(uint256 _tokenID, uint256 _price) public {
        // Use a require function since we need to validate that the owner is in fact the one that is calling this function
        require(ownerOf(_tokenID)) == msg.sender;

        starForSale[_tokenID] = _price;
    }

    function buyStar(uint256 _tokenID) public payable {
        // Need to decrease the balance of the current sender
        // Need to transfer the ownership of a particular star based on the star ID, steps for this
        // a) Remove the tokenID from the list of tokens of the current owner
        // b) Add the tokenID from the list of tokens of the buyer

    }
}

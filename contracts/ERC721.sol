// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {

    event Transfer(address indexed from,address indexed to,uint256 indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint256 indexed tokenId);

    mapping(uint256 => address) private _tokenOwner; 
    mapping(address => uint256) private _ownedTokensCount;
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('ownerOf(uint256)') ^ keccak256('balanceOf(address)') ^ keccak256('transferFrom(address,address,uint256)')));
        _registerInterface(bytes4(keccak256('name()') ^ keccak256('symbol()')));
    }

    function balanceOf(address _owner) public override  view returns(uint256){
        require(_owner != address(0),'owner address cannot be zero address');
        
        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public override view returns(address) {
        address _owner = _tokenOwner[_tokenId];

        require(_owner != address(0),'invalid token id');
        return _owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to,uint256 tokenId) internal virtual {
        // the address where to mint the token should not be a zero address
        require(to != address(0),'ERC721: minting to the zero address');
        // token does not already exist
        require(!_exists(tokenId),'ERC721: token already minted');

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    } 

    function _transferFrom(address _from,address _to,uint256 _tokenId) internal {
        require(_to != address(0),'cannot transfer to zero address');
        require(ownerOf(_tokenId) == _from,'provided address doesnot own token');
        
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

         emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from,address _to, uint256 _tokenId) public override {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to,uint256 _tokenId) public override {
        address owner = ownerOf(_tokenId);
        require(_to != owner,'Error - approval to current owner');
        require(msg.sender == owner,'cannot approve not helding token');

        _tokenApprovals[_tokenId] = _to;

        emit Approval(owner,_to,_tokenId);
    }

    function isApprovedOrOwner(address spender,uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId),'token doesnot exist');

        address owner = ownerOf(tokenId);
        return (spender == owner);
    }
}
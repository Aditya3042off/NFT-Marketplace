// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    // holds tokenIds of all the minted tokens
    uint256[] private _allTokens;

    //token index in _allTokens array to tokenId
    mapping(uint256 => uint256) private _allTokensIndex;
    
    // owner address to list of all token ids owned by owner 
    mapping(address => uint256[]) private _ownedTokens; 
    
    // token id to it's position in owners list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply()') ^ keccak256('tokenOfOwnerByIndex(address,uint256)') ^ keccak256('tokenByIndex(uint256)')));
    }

    function totalSupply() public override view returns(uint256) {
        return _allTokens.length;
    }

    function _addTokenToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenToOwnerEnumeration(address to,uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    function _mint(address to,uint256 tokenId) internal override(ERC721){
        super._mint(to,tokenId);

        _addTokenToAllTokenEnumeration(tokenId);
        _addTokenToOwnerEnumeration(to,tokenId);
    }

    function tokenByIndex(uint256 index) public override view returns(uint256) {
        require(index < totalSupply(),'index out of bounds');
        
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner,uint256 index) public override view returns(uint256) {
        require(index < balanceOf(owner),'owner token index out of bounds');
        
        return _ownedTokens[owner][index];
    }
}
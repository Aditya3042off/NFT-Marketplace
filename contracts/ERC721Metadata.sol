// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC721Metadata.sol';

contract ERC721Metadata is IERC721Metadata {

    string private _name;
    string private _symbol;

    constructor(string memory token_name,string memory token_symbol) {
        
        _name = token_name;
        _symbol =token_symbol;
    }

    function name() external override view returns(string memory){
        return _name;
    }

    function symbol() external override view returns(string memory){
        return _symbol;
    }
}
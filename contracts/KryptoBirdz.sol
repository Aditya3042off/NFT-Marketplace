// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // array to store nfts
    string[] public kryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    constructor () ERC721Connector('KryptoBird','KBRIDZ') {

    }

    function mint(string memory _kryptoBird) public {
        require(!_kryptoBirdzExists[_kryptoBird], 'kryptoBird already exists');
        
        kryptoBirdz.push(_kryptoBird);
        uint256 _id = kryptoBirdz.length - 1;

        _mint(msg.sender,_id);

        _kryptoBirdzExists[_kryptoBird] = true;
    }
}
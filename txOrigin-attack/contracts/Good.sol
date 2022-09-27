//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract Good {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address newOwner) public {
        /*
        注意此处就如同attack.js中的逻辑一样，如果tx.origin等于owner，但是newOwner传参为attack的合约地址
        那么就会将owner错误的修改为attack的地址
        要防止此错误只需要将tx.origin修改为msg.sender即可
        */
        //        require(msg.sender == owner, "Not owner" );
        require(tx.origin == owner, "Not owner");
        owner = newOwner;
    }
}
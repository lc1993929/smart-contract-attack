//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Good {
    //    注意此处变量声明顺序不能变
    address public helper;
    address public owner;
    uint public num;

    constructor(address _helper) {
        helper = _helper;
        owner = msg.sender;
    }

    function setNum(uint _num) public {
        helper.delegatecall(abi.encodeWithSignature("setNum(uint256)", _num));
    }
}
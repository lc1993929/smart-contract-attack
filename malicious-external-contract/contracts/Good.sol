//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Helper.sol";
import "..\..\delegatecall-attack\contracts\Helper.sol";

contract Good {
    Helper helper;
    constructor(address _helper) payable {
        helper = Helper(_helper);
        //        helper = new Helper();
    }

    /*
    在此例中，Helper和Attack生成的abi是一样的，但是实现逻辑不一样
    如果在constructor中如果错误的将attack的地址传入，那么将会造成在调用helper时错误执行了attack中的逻辑
    避免方法是使用new方法来获取helper的合约实例
    */

    function isUserEligible() public view returns (bool) {
        return helper.isUserEligible(msg.sender);
    }

    function addUserToList() public {
        helper.setUserEligible(msg.sender);
    }

    fallback() external {}

}
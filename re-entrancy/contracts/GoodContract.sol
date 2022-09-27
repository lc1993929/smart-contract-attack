// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract GoodContract {

    mapping(address => uint) public balances;

    // Update the `balances` mapping to include the new ETH deposited by msg.sender
    function addBalance() public payable {
        balances[msg.sender] += msg.value;
    }

    // Send ETH worth `balances[msg.sender]` back to msg.sender
    function withdraw() public {
        require(balances[msg.sender] > 0);
        //        注意此处，在Bad中的receive方法又再次调用了withdraw方法，那么在执行下一行代码之前又会再次执行withdraw方法直到该合约中的金额被用完
        (bool sent,) = msg.sender.call{value : balances[msg.sender]}("");
        require(sent, "Failed to send ether");
        // This code becomes unreachable because the contract's balance is drained
        // before user's balance could have been set to 0
        //        将该行代码放在转账代码之前即可避免重入攻击
        balances[msg.sender] = 0;
    }
}
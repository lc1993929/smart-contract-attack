//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Good {
    address public currentWinner;
    uint public currentAuctionPrice;
    mapping(address => uint) public balances;

    constructor() {
        currentWinner = msg.sender;
    }

    function setCurrentAuctionPrice() public payable {
        require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
        //        注意此处如果调用地址没有fallback方法，那么sent就会一直返回false，那么winner就一直无法改变
        (bool sent,) = currentWinner.call{value : currentAuctionPrice}("");
        if (sent) {
            currentAuctionPrice = msg.value;
            currentWinner = msg.sender;
        }
    }

    //    解决方案如下，让用户自己调用withdraw方法进行退款
    function setCurrentAuctionPrice2() public payable {
        require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
        balances[currentWinner] += currentAuctionPrice;
        currentAuctionPrice = msg.value;
        currentWinner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender != currentWinner, "Current winner cannot withdraw");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent,) = msg.sender.call{value : amount}("");
        require(sent, "Failed to send Ether");
    }

}
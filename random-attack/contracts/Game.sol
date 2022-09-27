// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Game {
    constructor() payable {}

    /**
        Randomly picks a number out of `0 to 2²⁵⁶–1`.
    */
    function pickACard() private view returns (uint) {
        // `abi.encodePacked` takes in the two params - `blockhash` and `block.timestamp`
        // and returns a byte array which further gets passed into keccak256 which returns `bytes32`
        // which is further converted to a `uint`.
        // keccak256 is a hashing function which takes in a bytes array and converts it into a bytes32
        /*
        注意此处生成随机数的数据和attack中生成随机数的逻辑是一样的，所以每一次attack调用都会被猜测成功
        如果需要避免随机数攻击，可以参考：
        https://github.com/lc1993929/RandomWinnerGame/blob/master/hardhat-tutorial/contracts/RandomWinnerGame.sol
        https://github.com/lc1993929/goProjects/blob/master/src/ChainLinkDemo/contracts/VRFv2Consumer.sol
        */
        uint pickedCard = uint(keccak256(abi.encodePacked(blockhash(block.number), block.timestamp)));
        return pickedCard;
    }

    /**
        It begins the game by first choosing a random number by calling `pickACard`
        It then verifies if the random number selected is equal to `_guess` passed by the player
        If the player guessed the correct number, it sends the player `0.1 ether`
    */
    function guess(uint _guess) public {
        uint _pickedCard = pickACard();
        if (_guess == _pickedCard) {
            (bool sent,) = msg.sender.call{value : 0.1 ether}("");
            require(sent, "Failed to send ether");
        }
    }

    /**
        Returns the balance of ether in the contract
    */
    function getBalance() view public returns (uint) {
        return address(this).balance;
    }

}
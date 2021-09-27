// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Wave Portal Constructed, initiate friendliness protocol");
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );
        lastWavedAt[msg.sender] = block.timestamp;

        uint256 prizeAmount = 0.001 ether;

        totalWaves++;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;
        console.log("Random number: %d", randomNumber);
        seed = randomNumber;

        if (randomNumber < 50 && address(this).balance >= prizeAmount) {
            console.log("%s won!", msg.sender);
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than they contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Total waves: %s", totalWaves);
        return totalWaves;
    }

    // Accept an incoming transaction
    fallback() external payable {}

    receive() external payable {}
}

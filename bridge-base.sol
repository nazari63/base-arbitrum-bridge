// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBridge {
    function mint(address recipient, uint256 amount) external;
}

contract BaseBridge {
    address public admin;
    address public bridgeDestination;
    mapping(address => uint256) public lockedFunds;
    
    event TokensLocked(address indexed user, uint256 amount);
    event BridgeSet(address bridgeAddress);

    constructor() {
        admin = msg.sender;
    }

    function setBridgeDestination(address _bridgeDestination) external {
        require(msg.sender == admin, "Only admin can set bridge");
        bridgeDestination = _bridgeDestination;
        emit BridgeSet(_bridgeDestination);
    }

    function lockTokens() external payable {
        require(msg.value > 0, "Must send ETH to lock");
        lockedFunds[msg.sender] += msg.value;
        emit TokensLocked(msg.sender, msg.value);
    }

    function releaseTokens(address recipient, uint256 amount) external {
        require(msg.sender == bridgeDestination, "Only destination bridge can release");
        require(address(this).balance >= amount, "Insufficient balance");
        payable(recipient).transfer(amount);
    }
}
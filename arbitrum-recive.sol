// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArbitrumBridge {
    address public admin;
    address public baseBridge;
    mapping(address => uint256) public mintedTokens;

    event TokensMinted(address indexed user, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    function setBaseBridge(address _baseBridge) external {
        require(msg.sender == admin, "Only admin can set base bridge");
        baseBridge = _baseBridge;
    }

    function mint(address recipient, uint256 amount) external {
        require(msg.sender == baseBridge, "Only Base Bridge can mint");
        mintedTokens[recipient] += amount;
        emit TokensMinted(recipient, amount);
    }
}
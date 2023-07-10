// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeVaultLock {
    mapping(address => uint256) public depositTime;
    IERC20 public TVLToken;
    uint256 public constant LOCK_AMOUNT = 100;

    constructor() payable {
        //TVLToken = ERC20(0x2deaaC6795a531a607270032F396e6FE5de81159);
        TVLToken = IERC20(0xe9DcE89B076BA6107Bb64EF30678efec11939234); // Usdc Polygon Address
    }

    function deposit() external payable {
        require(
            depositTime[msg.sender] == 0,
            "Already deposited from this wallet address"
        );
        require(
            TVLToken.allowance(msg.sender, address(this)) >= LOCK_AMOUNT,
            "Contract not authorized to spend tokens"
        );
        TVLToken.transferFrom(msg.sender, address(this), LOCK_AMOUNT);
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw() external {
        require(
            depositTime[msg.sender] != 0,
            "No previous deposit from this wallet address"
        );

        uint256 lockedTime = block.timestamp - depositTime[msg.sender];
        require(lockedTime > 0, "Tokens are still locked");

        uint256 tokensToMint = lockedTime;

        depositTime[msg.sender] = 0;

        TVLToken.transfer(msg.sender, LOCK_AMOUNT);
        require(
            TVLToken.balanceOf(address(this)) >= LOCK_AMOUNT,
            "Transfer of tokens failed"
        );

        // _mint(msg.sender, tokensToMint);
    }
}
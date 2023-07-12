// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeVaultLock {
    mapping(address => uint256) public depositTime;
    mapping(uint256 => address) public lockIDToAddress;
    IERC20 public Token;
    uint256 public LOCK_AMOUNT;
    uint256 public LockID;

    function deposit(address _token, uint256 _amount) external payable {
        Token = IERC20(_token);
        LOCK_AMOUNT = _amount;
        require(
            Token.allowance(msg.sender, address(this)) >= LOCK_AMOUNT,
            "Contract not authorized to spend tokens"
        );
        Token.transferFrom(msg.sender, address(this), LOCK_AMOUNT);
        depositTime[msg.sender] = block.timestamp;
        lockIDToAddress[LockID] = msg.sender;
        LockID += 1;
    }

    function withdraw(uint256 _lockid) external {
        require(
            depositTime[msg.sender] != 0,
            "No previous deposit from this wallet address"
        );
        require(block.timestamp >= depositTime[msg.sender] + 2 minutes, "Tokens are still locked");

       // SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeVaultLock {
    mapping(address => uint256) public depositTime;
    mapping(uint256 => address) public lockIDToAddress;
    IERC20 public Token;
    uint256 public LOCK_AMOUNT;
    uint256 public lockID;

    function deposit(address _token, uint256 _amount) external payable {
        Token = IERC20(_token);
        LOCK_AMOUNT = _amount;
        require(
            Token.allowance(msg.sender, address(this)) >= LOCK_AMOUNT,
            "Contract not authorized to spend tokens"
        );
        Token.transferFrom(msg.sender, address(this), LOCK_AMOUNT);
        depositTime[msg.sender] = block.timestamp;
        lockIDToAddress[lockID] = block.timestamp;
        lockID++;
    }

    function withdraw(uint256 _lockID) external {
        require(
            depositTime[msg.sender] != 0,
            "No previous deposit from this wallet address"
        );
        require(block.timestamp >= depositTime[msg.sender] + 2 minutes, "Tokens are still locked");
        require(lockIDToAddress[_lockID] != 0, "Invalid lockID");
        

        uint256 lockedTime = block.timestamp - depositTime[msg.sender];
        require(lockedTime > 0, "Tokens are still locked");

        depositTime[msg.sender] = 0;

        Token.transfer(msg.sender, LOCK_AMOUNT);
        require(
            Token.balanceOf(address(this)) >= LOCK_AMOUNT,
            "Transfer of tokens failed"
        );
    }
}

        require(lockedTime > 0, "Tokens are still locked");

        depositTime[msg.sender] = 0;

        Token.transfer(msg.sender, LOCK_AMOUNT);
        require(
            Token.balanceOf(address(this)) >= LOCK_AMOUNT,
            "Transfer of tokens failed"
        );

        // _mint(msg.sender, tokensToMint);
    }
}
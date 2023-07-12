// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeVaultLock {
    struct LockId {
        uint256 id;
        IERC20 tokenAddress;
        uint256 lockAmount;
        address userAddress;
        uint TotalTime;
        uint depositTime;
    }

   // mapping(address => uint256) public depositTime;
    uint256 public lockID = 0;
    mapping(uint256 => LockId) public lockIDToLock;

    function deposit(address _token, uint256 _amount , uint _time) external payable {
        IERC20 token = IERC20(_token);
        require(
            token.allowance(msg.sender, address(this)) >= _amount,
            "Contract not authorized to spend tokens"
        );
        token.transferFrom(msg.sender, address(this), _amount);
       // depositTime[msg.sender] = block.timestamp;

        LockId memory newLock = LockId(lockID + 1, token, _amount, msg.sender, _time, block.timestamp);
        lockIDToLock[lockID + 1] = newLock;
        lockID++;
    }

    function withdraw(uint256 _lockID) external {
        LockId storage lock = lockIDToLock[_lockID];
        
        require(block.timestamp >= lock.depositTime + lock.TotalTime, "Tokens are still locked");
        require(lockIDToLock[_lockID].id > 0, "Invalid lockID or no previous deposit"); 
        
        require(lock.userAddress == msg.sender, "Invalid lockID for the caller");
        lock.tokenAddress.transfer(msg.sender, lock.lockAmount);
        require(
            lock.tokenAddress.balanceOf(address(this)) >= lock.lockAmount,
            "Transfer of tokens failed"
        );
    }
}

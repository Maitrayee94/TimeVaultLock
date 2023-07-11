// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TimeVaultLock {
    mapping(address => uint256) public depositTime;
    IERC20 public Token;
    uint256 public LOCK_AMOUNT;

    constructor(address _TVtoken, uint256 _amount) payable {
        
        //TVLToken = IERC20(0xe9DcE89B076BA6107Bb64EF30678efec11939234); // Usdc Polygon Address
        //TVLToken= IERC20(0xFA31614f5F776eDD6f72Bc00BdEb22Bd4A59A7Db); //Goerli faucet
        Token = IERC20(_TVtoken);
        LOCK_AMOUNT = _amount;
    }

    function deposit() external payable {
        require(
            depositTime[msg.sender] == 0,
            "Already deposited from this wallet address"
        );
        require(
            Token.allowance(msg.sender, address(this)) >= LOCK_AMOUNT,
            "Contract not authorized to spend tokens"
        );
        Token.transferFrom(msg.sender, address(this), LOCK_AMOUNT);
        depositTime[msg.sender] = block.timestamp;
    }

    function withdraw() external {
        require(
            depositTime[msg.sender] != 0,
            "No previous deposit from this wallet address"
        );
        require(block.timestamp >= depositTime[msg.sender] + 2 minutes, "Tokens are still locked");

        uint256 lockedTime = block.timestamp - depositTime[msg.sender];
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
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IBEP20.sol";
import "./IStakingRewards.sol";

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library SafeBEP20 {
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) - value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");

        if (returndata.length > 0) { 
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed from, address indexed to);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Ownable: Caller is not the owner");
        _;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function transferOwnership(address transferOwner) external onlyOwner {
        require(transferOwner != newOwner);
        newOwner = transferOwner;
    }

    function acceptOwnership() virtual external {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract StakingRewards is IStakingRewards, ReentrancyGuard, Ownable {
    using SafeBEP20 for IBEP20;

    IBEP20 public immutable token;
    IBEP20 public immutable stakingToken;
    uint256 public rewardRate; 
    uint256 public constant rewardDuration = 365 days;

    mapping(address => uint256) public weightedStakeDate;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    event RewardUpdated(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event Rescue(address indexed to, uint amount);
    event RescueToken(address indexed to, address indexed token, uint amount);

    constructor(address _token, uint _rewardRate) {
        require(_token != address(0), "zero address!");
        token = IBEP20(_token);
        stakingToken = IBEP20(_token);
        rewardRate = _rewardRate;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function earned(address account) public view override returns (uint256) {
        return _balances[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate / (100 * rewardDuration);
    }

    function stake(uint256 amount) external override nonReentrant {
        require(amount > 0, "StakingFixedAPY: Cannot stake 0");
        _totalSupply += amount;
        uint previousAmount = _balances[msg.sender];
        uint newAmount = previousAmount + amount;
        weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
        _balances[msg.sender] = newAmount;
        token.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function stakeFor(uint256 amount, address user) external override nonReentrant {
        require(amount > 0, "StakingFixedAPY: Cannot stake 0");
        require(user != address(0), "StakingFixedAPY: Cannot stake for zero address");
        _totalSupply += amount;
        uint previousAmount = _balances[user];
        uint newAmount = previousAmount + amount;
        weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
        _balances[user] = newAmount;
        token.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(user, amount);
    }

    function withdraw(uint256 amount) public override nonReentrant {
        require(amount > 0, "StakingFixedAPY: Cannot withdraw 0");
        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        token.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public override nonReentrant {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            weightedStakeDate[msg.sender] = block.timestamp;
            token.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function withdrawAndGetReward(uint256 amount) external override {
        getReward();
        withdraw(amount);
    }

    function exit() external override {
        getReward();
        withdraw(_balances[msg.sender]);
    }

    function updateRewardAmount(uint256 reward) external onlyOwner {
        rewardRate = reward;
        emit RewardUpdated(reward);
    }

    function rescue(address to, IBEP20 tokenAddress, uint256 amount) external onlyOwner {
        require(to != address(0), "StakingFixedAPY: Cannot rescue to the zero address");
        require(amount > 0, "StakingFixedAPY: Cannot rescue 0");
        require(tokenAddress != token, "StakingFixedAPY: Cannot rescue staking/reward token");

        tokenAddress.safeTransfer(to, amount);
        emit RescueToken(to, address(tokenAddress), amount);
    }

    function rescue(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "StakingFixedAPY: Cannot rescue to the zero address");
        require(amount > 0, "StakingFixedAPY: Cannot rescue 0");

        to.transfer(amount);
        emit Rescue(to, amount);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CrowdFund {
    address public owner;
    uint256 public goal;
    uint256 public deadline;
    string public description;
    uint256 public totalRaised;
    bool public fundsWithdrawn;

    mapping(address => uint256) public contributions;

    error InvalidAddress();
    error OnlyOwner();
    error GoalNotReached();
    error DeadlineNotPassed();
    error DeadlinePassed();
    error AlreadyWithdrawn();
    error NothingToWithdraw();

    event Funded(address indexed contributor, uint256 amount);
    event Withdrawn(address indexed by, uint256 amount);
    event Refunded(address indexed contributor, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    modifier validAddress(address _addr) {
        if (_addr == address(0)) revert InvalidAddress();
        _;
    }

    constructor(uint256 _goal, uint256 _durationInSeconds, string memory _description) validAddress(msg.sender) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _durationInSeconds;
        description = _description;
    }

    function contribute() external payable validAddress(msg.sender) {
        require(block.timestamp < deadline, "Funding period over");
        require(msg.value > 0, "Must send ETH");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        emit Funded(msg.sender, msg.value);
    }

    function withdrawFunds() external onlyOwner {
        require(block.timestamp <= deadline, "Deadline passed");
        require(totalRaised >= goal, "Goal not met");
        if (fundsWithdrawn) revert AlreadyWithdrawn();

        fundsWithdrawn = true;
        payable(owner).transfer(totalRaised);

        emit Withdrawn(owner, totalRaised);
    }

    function refund() external {
        require(block.timestamp > deadline, "Deadline not yet passed");
        require(totalRaised < goal, "Goal was met");
        uint256 amount = contributions[msg.sender];
        if (amount == 0) revert NothingToWithdraw();

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit Refunded(msg.sender, amount);
    }

    // View helpers
    function timeLeft() external view returns (uint256) {
        return block.timestamp >= deadline ? 0 : deadline - block.timestamp;
    }

    function hasGoalBeenMet() external view returns (bool) {
        return totalRaised >= goal;
    }
}

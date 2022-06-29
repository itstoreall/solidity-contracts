// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
  uint totalTokens;
  address owner;
  string _name;
  string _symbol;
  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowances;

  function name() external view returns(string memory) {
    return _name;
  }

  function symbol() external view returns(string memory) {
    return _symbol;
  }

  function decimals() external pure returns(uint) {
    return 18; // 1 token = 1 wei
  }

  function totalSupply() external view returns(uint) {
    return totalTokens;
  }

  modifier enoughTokens(address _from, uint _amount) {
    require(balanceOf(_from) >= _amount, "not enough tokens");
    _;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "not an owner");
    _;
  }

  constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
    _name = name_;
    _symbol = symbol_;
    owner = msg.sender;
    mint(initialSupply, shop);
  }

  function balanceOf(address account) public view returns(uint) {
    return balances[account];
  }

  function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) {
    _beforeTokenTransfer(msg.sender, to, amount);
    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount); // event
  }

  function mint(uint amount, address shop) public onlyOwner {
    _beforeTokenTransfer(address(0), shop, amount);
    balances[shop] += amount;
    totalTokens += amount;
    emit Transfer(address(0), shop, amount); // event
  }

  function burn(address _from, uint amount) public onlyOwner {
    _beforeTokenTransfer(_from, address(0), amount);
    balances[_from] -= amount;
    totalTokens -= amount;
  }

  function allowance(address _owner, address spender) public view returns(uint) {
    return allowances[_owner][spender];
  }

  function approve(address spender, uint amount) public {
    _approve(msg.sender, spender, amount);
  }

  function _approve(address sender, address spender, uint amount) internal virtual {
    allowances[sender][spender] = amount;
    emit Approve(sender, spender, amount); // event
  }

  function transferFrom(address sender, address recipient, uint amount) external enoughTokens(sender, amount) {
    _beforeTokenTransfer(sender, recipient, amount);
    require(allowances[sender][recipient] >= amount, "check allowance!");
    allowances[sender][recipient] -= amount;

    balances[sender] -= amount;
    balances[recipient] += amount;
    emit Transfer(sender, recipient, amount); // event
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint amount
  ) internal virtual {}
}

// https://youtu.be/igPcdziCkWU
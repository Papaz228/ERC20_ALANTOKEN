// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./IERC20.sol";

contract MyERC20 is IERC20{
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    address _owner;
    event E_TransferOfOwnership(address previous_owner, address new_owner);

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint256 yourTotalSupply) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = yourTotalSupply;
        _balances[msg.sender] = yourTotalSupply;
        _owner = msg.sender;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner is zero address");
        emit E_TransferOfOwnership(_owner, _newOwner);
        _owner = _newOwner;
    }

    function name() public view virtual  returns (string memory) {
        return _name;
    }


    function symbol() public view virtual  returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual  returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        require(to != address(0), "to should not be zero");
        require(amount > 0, "amount should be greater than 0");
        uint256 fee = amount / 100 * 5;
        require(_balances[msg.sender] >= amount + fee, "Not enough money on balance");
        _balances[_owner] += fee;
        address owner = msg.sender;
        _transfer(owner, to, amount + fee);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(_balances[msg.sender] >= amount, "now sufficient funds for approval");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        require(to != address(0), "to should not be zero");
        require(from != address(0), "from should not be 0");
        require(amount > 0, "amount should be greater than 0");
        uint256 fee = amount / 100 * 5;
        require(_balances[msg.sender] >= amount + fee, "Not enough money on balance");
        _balances[_owner] += fee;
        _transfer(from, to, amount + fee);
        return true;
    }


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
    }
}

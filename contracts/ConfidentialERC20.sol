// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./FHE.sol";

contract ConfidentialERC20 {
    using FHE for euint64;
    using FHE for ebool;

    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => euint64) private _balances;
    mapping(address => mapping(address => euint64)) private _allowances;

    event Transfer(address indexed from, address indexed to);
    event Approval(address indexed owner, address indexed spender);

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero address");
        totalSupply += amount;
        _balances[account] = FHE.add(
            _balances[account],
            FHE.asEuint64(abi.encode(amount))
        );
        emit Transfer(address(0), account);
    }

    function transfer(address to, bytes calldata encryptedAmount) public returns (bool) {
        _transfer(msg.sender, to, FHE.asEuint64(encryptedAmount));
        return true;
    }

    function transferFrom(
        address from,
        address to,
        bytes calldata encryptedAmount
    ) public returns (bool) {
        euint64 amount = FHE.asEuint64(encryptedAmount);
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function approve(address spender, bytes calldata encryptedAmount) public returns (bool) {
        _approve(msg.sender, spender, FHE.asEuint64(encryptedAmount));
        return true;
    }

    function balanceOf(address account) public view returns (bytes memory) {
        require(msg.sender == account, "Not authorized");
        return FHE.reencrypt(_balances[account], account);
    }

    function allowance(address owner, address spender) public view returns (bytes memory) {
        require(msg.sender == owner || msg.sender == spender, "Not authorized");
        return FHE.reencrypt(_allowances[owner][spender], msg.sender);
    }

    function _transfer(address from, address to, euint64 amount) internal {
        require(from != address(0), "Transfer from zero");
        require(to != address(0), "Transfer to zero");

        _balances[from] = FHE.sub(_balances[from], amount);
        _balances[to] = FHE.add(_balances[to], amount);

        emit Transfer(from, to);
    }

    function _approve(address owner, address spender, euint64 amount) internal {
        require(owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender);
    }

    function _spendAllowance(address owner, address spender, euint64 amount) internal {
        euint64 currentAllowance = _allowances[owner][spender];
        _allowances[owner][spender] = FHE.sub(currentAllowance, amount);
    }
}

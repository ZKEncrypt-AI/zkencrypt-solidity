# ZKEncrypt Solidityx

Solidity smart contract library for ZKEncrypt Network - Build privacy-preserving decentralized applications with Fully Homomorphic Encryption (FHE).

## 🚀 Features

- **FHE Operations**: Perform homomorphic computations on encrypted data directly on-chain
- **Confidential ERC20**: Privacy-preserving token standard with encrypted balances and transfers
- **Private Auctions**: Sealed-bid auction contracts with encrypted bids and automatic winner determination
- **Encrypted Voting**: Privacy-preserving DAO governance with secret ballot voting
- **Confidential DeFi**: Build private lending, swaps, and advanced DeFi protocols with complete privacy
- **Access Control**: Fine-grained encrypted data access management with role-based permissions

## 📦 Installation

```bash
npm install @zkencrypt/solidity
# or
yarn add @zkencrypt/solidity
```

## 🔧 Quick Start

### Import Contracts

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@zkencrypt/solidity/contracts/FHE.sol";
import "@zkencrypt/solidity/contracts/ConfidentialERC20.sol";
```

### Basic FHE Operations

```solidity
contract MyPrivateContract is FHE {
    // Encrypted balance
    euint64 private encryptedBalance;
    
    function deposit(bytes calldata encryptedAmount) public {
        euint64 amount = FHE.asEuint64(encryptedAmount);
        encryptedBalance = FHE.add(encryptedBalance, amount);
    }
    
    function getBalance() public view returns (bytes memory) {
        return FHE.reencrypt(encryptedBalance, msg.sender);
    }
}
```

### Confidential ERC20 Token

```solidity
contract MyPrivateToken is ConfidentialERC20 {
    constructor() ConfidentialERC20("Private Token", "PTKN") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}
```

### Private Auction

```solidity
contract PrivateAuction is FHE {
    mapping(address => euint64) public bids;
    address public winner;
    euint64 public highestBid;
    bool public auctionEnded;
    
    function bid(bytes calldata encryptedBid) public {
        require(!auctionEnded, "Auction ended");
        euint64 bidAmount = FHE.asEuint64(encryptedBid);
        bids[msg.sender] = bidAmount;
    }
    
    function endAuction() public {
        require(!auctionEnded, "Already ended");
        // Homomorphic comparison logic here
        auctionEnded = true;
    }
}
```

### Encrypted Voting

```solidity
contract PrivateVoting is FHE {
    mapping(uint256 => euint64) public proposalVotes;
    mapping(address => ebool) public hasVoted;
    
    function vote(uint256 proposalId, bytes calldata encryptedVote) public {
        ebool voted = hasVoted[msg.sender];
        require(!FHE.decrypt(voted), "Already voted");
        
        euint64 voteCount = FHE.asEuint64(encryptedVote);
        proposalVotes[proposalId] = FHE.add(
            proposalVotes[proposalId],
            voteCount
        );
        
        hasVoted[msg.sender] = FHE.asEbool(true);
    }
    
    function getResults(uint256 proposalId) public view returns (bytes memory) {
        return FHE.reencrypt(proposalVotes[proposalId], msg.sender);
    }
}
```

## 📚 Core Contracts

### FHE.sol
Base contract providing FHE operations:
- `asEuint8/16/32/64()` - Convert encrypted input to euint
- `asEbool()` - Convert encrypted input to ebool
- `add()` - Homomorphic addition
- `sub()` - Homomorphic subtraction
- `mul()` - Homomorphic multiplication
- `div()` - Homomorphic division
- `eq()` - Homomorphic equality check
- `ne()` - Homomorphic not-equal check
- `lt()` - Homomorphic less-than
- `gt()` - Homomorphic greater-than
- `select()` - Homomorphic conditional
- `reencrypt()` - Re-encrypt for user decryption
- `decrypt()` - Decrypt value (requires permission)

### ConfidentialERC20.sol
Privacy-preserving ERC20 token:
- Private balances (encrypted)
- Private transfers
- Public total supply
- Access control for balance viewing
- Approval system for private transfers

### PrivateAuction.sol
Sealed-bid auction implementation:
- Hidden bid amounts
- Fair winner determination
- No bid reveal until auction ends
- Automatic refunds

### EncryptedVoting.sol
Privacy-preserving governance:
- Secret ballot voting
- Encrypted vote tallying
- No vote manipulation
- Results revealed after voting period

### AccessControl.sol
Fine-grained access management:
- Encrypted data access permissions
- Role-based access control
- Time-locked access
- Revocable permissions

## 🔐 Data Types

### Encrypted Integers
- `euint8` - Encrypted 8-bit unsigned integer
- `euint16` - Encrypted 16-bit unsigned integer
- `euint32` - Encrypted 32-bit unsigned integer
- `euint64` - Encrypted 64-bit unsigned integer

### Encrypted Boolean
- `ebool` - Encrypted boolean value

## 🛠️ Development

### Compile Contracts

```bash
npm run compile
```

### Run Tests

```bash
npm test
```

### Deploy

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## 📖 Examples

See the [examples](./examples) directory for complete working examples:
- Confidential DeFi lending protocol
- Private DAO voting system
- Sealed-bid NFT auction
- Encrypted token swap

## 🔒 Security

- All contracts are audited by leading security firms
- Follow best practices for FHE operations
- Never store private keys on-chain
- Use proper access control for sensitive operations

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Documentation](https://zkencrypt-ai.gitbook.io/zkencrypt-ai)
- [GitHub](https://github.com/ZKEncrypt-AI/zkencrypt-solidity)

---

Built with ❤️ by the ZKEncrypt AI team

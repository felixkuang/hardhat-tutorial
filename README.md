# hardhat-tutorial
hardhat tutorial

1. Installing Node.js
2. Creating a new Hardhat project
```shell
mkdir hardhat-tutorial
cd hardhat-tutorial
npm init
npm install --save-dev hardhat
npx hardhat
npm install --save-dev @nomicfoundation/hardhat-toolbox
```
3. Writing and compiling smart contracts
 - Writing smart contracts
 - Compiling contracts
    ```shell
    npx hardhat compile
    ```
4. Testing contracts
  - Writing tests
    ```shell
    npx hardhat test
    # npx hardhat test .\test\Token.js 
    ```  
5. Debugging with Hardhat Network
  - Solidity `console.log`    
    ```solidity
    pragma solidity ^0.8.0;

    import "hardhat/console.sol";

    contract Token {
      //...
    }
    ```

    ```solidity
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        console.log(
            "Transferring from %s to %s %s tokens",
            msg.sender,
            to,
            amount
        );

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
    ```
7. Deploying to a live network    

    ```shell
    npx hardhat run scripts/deploy.js --network <network-name>
    #npx hardhat run scripts/deploy.js --network sepolia
    ```
8. Deploying to remote networks

  To deploy to a remote network such as mainnet or any testnet, you need to add a network entry to your hardhat.config.js file. We’ll use Sepolia for this example, but you can add any network similarly:  

  ```js
    require("@nomicfoundation/hardhat-toolbox");

    // Go to https://infura.io, sign up, create a new API key
    // in its dashboard, and replace "KEY" with it
    const INFURA_API_KEY = "KEY";

    // Replace this private key with your Sepolia account private key
    // To export your private key from Coinbase Wallet, go to
    // Settings > Developer Settings > Show private key
    // To export your private key from Metamask, open Metamask and
    // go to Account Details > Export Private Key
    // Beware: NEVER put real Ether into testing accounts
    const SEPOLIA_PRIVATE_KEY = "YOUR SEPOLIA PRIVATE KEY";

    module.exports = {
      solidity: "0.8.19",
      networks: {
        sepolia: {
          url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
          accounts: [SEPOLIA_PRIVATE_KEY]
        }
      }
    };
  ```  
  [Infura](https://infura.io/) | [Alchemy](https://alchemy.com/)
  
  
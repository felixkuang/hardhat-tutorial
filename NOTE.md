# 1.概述





# 2.设置环境

- Installing Node.js



# 3.创建一个新的hardhat项目

```shell
mkdir hardhat-tutorial
cd hardhat-tutorial
npm init
npm install --save-dev hardhat
# In the same directory where you installed Hardhat run:
npx hardhat
# compile
npx hardhat compile
# help
npx hardhat help [task]
# Plugins
    npm install --save-dev @nomicfoundation/hardhat-toolbox
```

```js
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
};
```



# 4.编写和编译智能合约

## 写一个智能合约

```solidity
//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;


// This is the main building block for smart contracts.
contract Token {
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account's balance.
    mapping(address => uint256) balances;

    // The Transfer event helps off-chain applications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
     * Contract initialization.
     */
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside*
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
```



## 编译合约

```shell
npx hardhat compile
```

设置多个编译版本

```typescript
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import './task';

const INFURA_API_KEY = "YOUR API KEY";

const SEPOLIA_PRIVATE_KEY = "YOUR PRIVATE KEY";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: '0.6.6',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.5.16",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      }
    ]
  },
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: "Browser API KEY",
    customChains: [{ network: "", chainId: 1, urls: { apiURL: "", browserURL: "" } }]
  },
};

export default config;
```



# 5.测试合约

```js
 npx hardhat test
```



# 6.调试

```solidity
pragma solidity ^0.8.0;

// import hardhat/console.sol
import "hardhat/console.sol";

contract Token {
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
}
```



# 7.部署

要部署到远程网络，如主网或任何测试网，您需要在您的 hardhat.config.js 文件中添加一个网络条目。我们将在这个例子中使用Sepolia，但你可以类似地添加任何网络:

```shell
npx hardhat run scripts/deploy.js --network <network-name>
```

```js
// hardhat.config.js
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

部署合约两种传参方式

```javascript
async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    const name = "GovernanceToken"
    const symbol = "GT"
    const supply = ethers.parseEther("1000")    // 1000 Tokens
  	
    // 方式1
    //const token = await ethers.deployContract("GovernanceToken",[name,symbol,supply]);
	
    // 方式2
    const GovernanceToken = await ethers.getContractFactory("GovernanceToken");
    const token = await GovernanceToken.deploy(name,symbol,supply);
  
    console.log("Token address:", await token.getAddress());
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
```



# 8.验证

```shell
# 部署合约
npx hardhat ignition deploy ./ignition/modules/Token.js --network <network-name>
# 查看支持的网络
npx hardhat verify --list-networks
# 验证合约（无参数）
npx hardhat verify --network polygon_amoy 0x8e9D92e0718963AfD6E6271A7F4Ab2B8B4a3c552
# 验证合约（有参数）
npx hardhat verify --constructor-args .\scripts\arguments.ts --network polygon_amoy 0x8e9D92e0718963AfD6E6271A7F4Ab2B8B4a3c552

npx hardhat verify --constructor-args .\scripts\optimism_arguments.ts --network optimism_sepolia 0xa7B7d4c2E1dA5bE2b930F860C04e7D59DBfb4301 --show-stack-traces

# 自定义网络验证合约时，网络连接不上，需要进行一下步骤
# 错误信息为
hardhat-verify found one or more errors during the verification process:

Etherscan:
A network request failed. This is an error from the block explorer, not Hardhat. Error: Connect Timeout Error

1.安装undici
npm install --save-dev undici 
2.在hardhat.config中添加以下内容
const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyUrl = "http://127.0.0.1:7890" // change to yours, With the global proxy enabled, change the proxyUrl to your own proxy link. The port may be different for each client.
const proxyAgent = new ProxyAgent(proxyUrl)
setGlobalDispatcher(proxyAgent)

# 参考资料
https://github.com/smartcontractkit/full-blockchain-solidity-course-js/discussions/2247
https://hackernoon.com/solving-the-connecttimeouterror-when-verifying-smart-contracts-with-hardhat
```



# 高级用法



## 创建任务

`任务目标 :`创建任务并执行任务

>创建任务可以直接在配置文件 hardhat.config.js 中创建，也可以外部创建，然后通过 require 或者 import 到 hardhat.config.js 文件中
>
>

### 基础



**语法**

js

```js
require("@nomicfoundation/hardhat-toolbox");

task("balance", "Prints an account's balance").setAction(async () => {});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
};
```

typescript

```typescript
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import { HardhatRuntimeEnvironment } from "hardhat/types";

task("balance", "Prints an account's balance").setAction(async () => {});
const config: HardhatUserConfig = {
  solidity: "0.5.16",
};

export default config;

```



查看当前项目的可用的任务

```shell
npx hardhat
```

**实现步骤**

1. 安装 @nomicfoundation/hardhat-toolbox

```shell
npm install --save-dev @nomicfoundation/hardhat-toolbox
```

2. 在  hardhat.config.js 文件中添加任务

​	见语法

3. 查看添加的任务

   ```shell
   PS D:\dev\github.com\felixkuang\test> npx hardhat
   Hardhat version 2.17.2
   
   Usage: hardhat [GLOBAL OPTIONS] <TASK> [TASK OPTIONS]
   
   GLOBAL OPTIONS:
   
     --config              A Hardhat config file.
     ...
   
   AVAILABLE TASKS:
   
     balance               Prints an account's balance
     ...
    
     To get help for a specific task run: npx hardhat help [task] 	
   ```

4. 给任务添加参数

```javascript
task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async () => {});
```

​		查看任务帮助 npx hardhat `balance` --help

```shell
PS D:\dev\github.com\felixkuang\test> npx hardhat balance --help
Hardhat version 2.17.2

Usage: hardhat [GLOBAL OPTIONS] balance --account <STRING>

OPTIONS:

  --account     The account's address

balance: Prints an account's balance

For global options help run: hardhat help
```



**案例**

1. 获取用户余额

```javascript
task("balance", "Prints an account's balance")
  .addParam("account", "The account's address")
  .setAction(async (taskArgs) => {
    const balance = await ethers.provider.getBalance(taskArgs.account);

    console.log(ethers.formatEther(balance), "ETH");
  });
```

执行任务

```shell
$ npx hardhat balance --account 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
10000.0 ETH
```



### 进阶

> 由于 hardhat.config.js 



```solidity
task(
  "hello",
  "Prints 'Hello, World!'",
  async function (taskArguments, hre, runSuper) {
    console.log("Hello, World!");
  }
);
```

1. 第一个参数  任务名称
2. 第二个参数 描述
3. 第三个参数函数

- `taskArguments` 任务参数
- `hre` hardhat运行时环境
- runSuper 只有在重写现有任务时才有意义，我们将在接下来了解。它的目的是让您运行原始任务的操作



#### 任务的操作需求

```javascript
task("BAD", "This task is broken", async () => {
  setTimeout(() => {
    throw new Error(
      "This task's action returned a promise that resolved before I was thrown"
    );
  }, 1000);
});
```



```javascript
task("delayed-hello", "Prints 'Hello, World!' after a second", async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("Hello, World!");
      resolve();
    }, 1000);
  });
});	
```



#### 定义参数

```javascript
task("hello", "Prints a greeting")
  .addOptionalParam("greeting", "The greeting to print", "Hello, World!")
  .setAction(async ({ greeting }) => console.log(greeting));
```

`task` 第一个参数：任务名称  第二个参数：任务标书

`addOptionalParam`  第一个参数：参数名称  第二个参数：参数描述  第三个参数：参数默认值

`setAction`  异步函数

```shell
npx hardhat hello --greeting Hola
# Hola
npx hardhat hello
# Hello, World!
```



#### 位置参数限制



#### 类型验证



#### 重写任务



#### runSuper函数



#### 子任务



```javascript
task("hello-world", "Prints a hello world message").setAction(
  async (taskArgs, hre) => {
    await hre.run("print", { message: "Hello, World!" });
  }
);

subtask("print", "Prints a message")
  .addParam("message", "The message to print")
  .setAction(async (taskArgs) => {
    console.log(taskArgs.message);
  });
```



## 分叉网络

```shell
$ npx hardhat node --fork https://eth-mainnet.alchemyapi.io/v2/{YOUR_API_KEY}
```


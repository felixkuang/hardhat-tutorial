const { expect } = require("chai");
const { ethers, network } = require("hardhat");
require('dotenv').config()

const { abi } = require("../artifacts/contracts/MyToken.sol/MyToken.json");

function getTimestampInSeconds() {
    // returns current timestamp in seconds
    return Math.floor(Date.now() / 1000);
  }

describe("ERC20Permit", function () {
    
    it("ERC20 permit", async function () {

       // get a provider instance
        const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

        // get the network chain id
        const chainId = (await provider.getNetwork()).chainId;

        const signer = await new ethers.Wallet(process.env.SEPOLIA_PRIVATE_KEY, provider)

        const token = await ethers.deployContract("MyToken");
        const vault = await ethers.deployContract("Vault",[token.target]);

        // check account balances
        let tokenOwnerBalance = (await token.balanceOf(signer.address)).toString()
        let tokenReceiverBalance = (await token.balanceOf(vault.target)).toString()
        console.log(`Starting tokenOwner balance: ${tokenOwnerBalance}`);
        console.log(`Starting tokenReceiver balance: ${tokenReceiverBalance}`);

        // set the domain parameters
        const domain = {
            name: await token.name(),
            version: "1",
            chainId: chainId,
            verifyingContract: token.target
        };
 
        // set the Permit type parameters
        const types = {
            Permit: [{
                name: "owner",
                type: "address"
            },
            {
                 name: "spender",
                 type: "address"
            },
            {
                 name: "value",
                 type: "uint256"
            },
            {
                 name: "nonce",
                 type: "uint256"
            },
            {
                 name: "deadline",
                 type: "uint256"
            },
            ],
        };

        // get the MyToken contract factory and deploy a new instance of the contract
        //const myToken = new ethers.Contract(token.target, abi, provider)

        const amount = ethers.parseEther("1");    
         // get the current nonce for the deployer address
        const nonces = await token.nonces(signer.address);
        const deadline = getTimestampInSeconds() + 4200;

        // set the Permit type values
        const values = {
            owner: signer.address,
            spender: vault.target,
            value: amount,
            nonce: nonces,
            deadline: deadline,
        };

        const signature = await signer.signTypedData(domain, types, values);

        // verify the Permit type data with the signature
        const recovered = ethers.verifyTypedData(
            domain,
            types,
            values,
            signature
        );
        console.log(`recovered is ${recovered}`)

        // const vaultContract = new ethers.Contract(vault.target, abi, provider)
        const sig = ethers.Signature.from(signature)

        const tx = await vault.connect(signer).depositWithPermit(amount, deadline, sig.v, sig.r, sig.s)
        
        // expect(await token.balanceOf(vaultContract.target)).to.equal(amount)
        
        // Get ending balances
        tokenOwnerBalance = (await token.balanceOf(signer.address)).toString()
        tokenReceiverBalance = (await token.balanceOf(vault.target)).toString()
        console.log(`Ending tokenOwner balance: ${tokenOwnerBalance}`);
        console.log(`Ending tokenReceiver balance: ${tokenReceiverBalance}`);      
    });
});

const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const { abi } = require("../artifacts/contracts/MyToken.sol/MyToken.json")

// https://github.com/dragonfly-xyz/useful-solidity-patterns/tree/main/patterns/permit2
// https://blog.uniswap.org/permit2-and-universal-router
// https://eips.ethereum.org/EIPS/eip-2612

function getTimestampInSeconds() {
    // returns current timestamp in seconds
    return Math.floor(Date.now() / 1000);
}

describe("ERC20Permit", function () {

    async function deployContractFixture() {
        const [owner, addr1, addr2] = await ethers.getSigners();

        const token = await ethers.deployContract("MyToken");
        console.log("token address is ", token.target)
        const vault = await ethers.deployContract("Vault",[token.target]);
        console.log("vault address is ", vault.target)

        return { token, vault, owner, addr1, addr2 };
    }

    it("ERC20 permit", async function () {
        const {token, vault,owner, addr1, addr2} = await loadFixture(deployContractFixture);
        
        // get a provider instance
        const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);

        // get the network chain id
        const chainId = (await provider.getNetwork()).chainId;
 
        // create a signer instance with the token owner
        const tokenOwner = await new ethers.Wallet(process.env.SEPOLIA_PRIVATE_KEY, provider)
         
        // create a signer instance with the token receiver
        const tokenReceiver = await new ethers.Wallet(process.env.SEPOLIA_PRIVATE_KEY1, provider)
         
        // get the MyToken contract factory and deploy a new instance of the contract
        const myToken = new ethers.Contract(token.target, abi, provider)
 
        // check account balances
        let tokenOwnerBalance = (await myToken.balanceOf(tokenOwner.address)).toString()
        let tokenReceiverBalance = (await myToken.balanceOf(tokenReceiver.address)).toString()
 
        console.log(`Starting tokenOwner balance: ${tokenOwnerBalance}`);
        console.log(`Starting tokenReceiver balance: ${tokenReceiverBalance}`);
 
        // set token value and deadline
        const value = ethers.parseEther("1");
        const deadline = getTimestampInSeconds() + 4200;
 
        // get the current nonce for the deployer address
        const nonces = await myToken.nonces(tokenOwner.address);
 
        // set the domain parameters
        const domain = {
            name: await myToken.name(),
            version: "1",
            chainId: chainId,
            verifyingContract: myToken.target
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
        // set the Permit type values
        const values = {
            owner: tokenOwner.address,
            spender: tokenReceiver.address,
            value: value,
            nonce: nonces,
            deadline: deadline,
        };
 
        // sign the Permit type data with the deployer's private key
        const signature = await tokenOwner.signTypedData(domain, types, values);

        // const r = ethers.dataSlice(signature,0,32);
        // const s = ethers.dataSlice(signature,32,64);
        // const v = ethers.dataSlice(signature,64);
 
         
        // verify the Permit type data with the signature
        const recovered = ethers.verifyTypedData(
            domain,
            types,
            values,
            signature
        );
         
        const sig = ethers.Signature.from(signature)
        let tx = await myToken.connect(tokenOwner).permit(
            tokenOwner.address,
            tokenReceiver.address,
            value,
            deadline,
            sig.v,
            sig.r,
            sig.s
        );

        console.log(`Check allowance of tokenReceiver: ${await myToken.allowance(tokenOwner.address, tokenReceiver.address)}`);   
        
        // transfer tokens from the tokenOwner to the tokenReceiver address
        tx = await myToken.connect(tokenReceiver).transferFrom(
            tokenOwner.address,
            tokenReceiver.address,
            value
        );

        // Get ending balances
        tokenOwnerBalance = (await myToken.balanceOf(tokenOwner.address)).toString()
        tokenReceiverBalance = (await myToken.balanceOf(tokenReceiver.address)).toString()

        console.log(`Ending tokenOwner balance: ${tokenOwnerBalance}`);
        console.log(`Ending tokenReceiver balance: ${tokenReceiverBalance}`);
    
    })

})
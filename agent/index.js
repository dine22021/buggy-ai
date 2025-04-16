const Web3 = require("web3");
const fs = require("fs");
const contractJson = require("../build/contracts/OracleBounty.json");
const axios = require("axios");

const web3 = new Web3("http://127.0.0.1:7545"); // Ganache
const contractAddress = "DEPLOYED_CONTRACT_ADDRESS";
const contract = new web3.eth.Contract(contractJson.abi, contractAddress);
const account = "YOUR_GANACHE_ACCOUNT_ADDRESS";

const FEED_ID = "worldcup-score";
const FEED_KEY = web3.utils.keccak256(FEED_ID);

async function fetchDataFromAPI() {
  const res = await axios.get("https://api.example.com/score");
  return res.data.score;
}

async function main() {
  const feed = await contract.methods.feeds(FEED_KEY).call();
  const latest = await fetchDataFromAPI();

  if (latest !== feed.latestValue) {
    console.log("Updating feed with new value:", latest);
    const tx = await contract.methods.updateFeed(FEED_ID, latest).send({ from: account });
    console.log("Transaction confirmed:", tx.transactionHash);
  } else {
    console.log("No update needed.");
  }
}

main();

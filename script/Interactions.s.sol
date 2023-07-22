// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FruityNft} from "../src/FruityNft.sol";

contract MintFruityNft is Script {
    string public constant FRUITY_URI =
        "ipfs://ouripfsfruityaddy/?filename=0-BANANA.json";
    uint256 deployerKey;

    function run() external {
        address mostRecentlyDeployedFruityNft = DevOpsTools
            .get_most_recent_deployment("FruityNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployedFruityNft);
    }

    function mintNftOnContract(address fruityNftAddress) public {
        vm.startBroadcast();
        FruityNft(fruityNftAddress).mintNft(FRUITY_URI);
        vm.stopBroadcast();
    }
}

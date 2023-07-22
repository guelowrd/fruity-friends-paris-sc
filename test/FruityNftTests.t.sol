// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployFruityNft} from "../script/DeployFruityNft.s.sol";
import {FruityNft} from "../src/FruityNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintFruityNft} from "../script/Interactions.s.sol";

contract FruityNftTest is StdCheats, Test {
    string constant NFT_NAME = "Fruity NFT";
    string constant NFT_SYMBOL = "FRUITY";
    FruityNft public fruityNft;
    DeployFruityNft public deployer;
    address public deployerAddress;

    string public constant FRUITY_URI =
        "ipfs://ouripfsfruityaddy/?filename=0-BANANA.json";
    address public constant USER = address(1);

    function setUp() public {
        deployer = new DeployFruityNft();
        fruityNft = deployer.run();
    }

    function testInitializedCorrectly() public view {
        assert(
            keccak256(abi.encodePacked(fruityNft.name())) ==
                keccak256(abi.encodePacked((NFT_NAME)))
        );
        assert(
            keccak256(abi.encodePacked(fruityNft.symbol())) ==
                keccak256(abi.encodePacked((NFT_SYMBOL)))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        fruityNft.mintNft(FRUITY_URI);

        assert(fruityNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        fruityNft.mintNft(FRUITY_URI);

        assert(
            keccak256(abi.encodePacked(fruityNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(FRUITY_URI))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = fruityNft.getTokenCounter();
        MintFruityNft mintFruityNft = new MintFruityNft();
        mintFruityNft.mintNftOnContract(address(fruityNft));
        assert(fruityNft.getTokenCounter() == startingTokenCount + 1);
    }
}

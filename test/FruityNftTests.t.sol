// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployFruityNft} from "../script/DeployFruityNft.s.sol";
import {FruityNft} from "../src/FruityNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {MintFruityNft} from "../script/Interactions.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

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
        string memory base64tokenUri = string(
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        string.concat(
                            '{"name": "',
                            NFT_NAME,
                            '", "description": "A dynamic NFT representing the Fruity Friend profile", "attributes": [{"trait_type": "worldcoin_verified", "value": "',
                            "false",
                            '"}, {"trait_type": "polygon_ID_verified", "value": "',
                            "false",
                            '"}], "image": "',
                            FRUITY_URI,
                            '"}'
                        )
                    )
                )
            )
        );

        assert(
            keccak256(abi.encodePacked(fruityNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(base64tokenUri))
        );
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = fruityNft.getTokenCounter();
        MintFruityNft mintFruityNft = new MintFruityNft();
        mintFruityNft.mintNftOnContract(address(fruityNft));
        assert(fruityNft.getTokenCounter() == startingTokenCount + 1);
    }
}

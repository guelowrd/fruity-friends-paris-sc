// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract FruityNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToImageUri;
    mapping(uint256 => bool) private s_tokenIdToWorldcoinVerified;
    mapping(uint256 => bool) private s_tokenIdToPolygonIdVerified;

    constructor() ERC721("Fruity NFT", "FRUITY") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory imageUri) public {
        s_tokenIdToImageUri[s_tokenCounter] = imageUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI = s_tokenIdToImageUri[tokenId];
        string memory worldcoinVerified;
        if (s_tokenIdToWorldcoinVerified[tokenId]) {
            worldcoinVerified = "true";
        } else {
            worldcoinVerified = "false";
        }
        string memory polygonIdVerified;
        if (s_tokenIdToPolygonIdVerified[tokenId]) {
            polygonIdVerified = "true";
        } else {
            polygonIdVerified = "false";
        }
        return
            string(
                string.concat(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            string.concat(
                                '{"name": "',
                                name(),
                                '", "description": "A dynamic NFT representing the Fruity Friend profile", "attributes": [{"trait_type": "worldcoin_verified", "value": "',
                                worldcoinVerified,
                                '"}, {"trait_type": "polygon_ID_verified", "value": "',
                                polygonIdVerified,
                                '"}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}

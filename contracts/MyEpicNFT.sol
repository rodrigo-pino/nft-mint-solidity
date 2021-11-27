// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 totalTokens = 42;
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Pizza", "Square", "Baddass", "Sexy", "Obvious", "Boss", "Sandwich", "Potato", "Fat", "Yummy", "Sassy", "Dirty", "Ship", "Notebook", "Missile", "Galactica", "Pacino", "Cross"];
    string[] secondWords = ["Mudpie", "Cupcake", "Grandma", "Super", "Supreme", "Boomerang", "Vortex", "Time", "Tornado", "Watersput", "Granade", "Power", "Kinetic", "Metroid", "Banana", "Kiwi"];
    string[] thirdWords = ["Anhilator", "Destroyer", "Conqueror", "Spagheti", "Pirate", "Sewer", "Mundane", "Mad", "Max", "Rust", "TrucK", "Huge", "Batallion", "Dune", "Seldon", "Golam", "Aristoteles"];
    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);
    event TotalNFTsMinted(uint256 current, uint256 total);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Bailoterapia", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Republica Checa", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Rinoceronte Sucio", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("Fuccia", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        require(newItemId <= totalTokens);

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        string memory color = pickRandomColor(newItemId);
        string memory finalSvg = string(abi.encodePacked(svgPartOne, color, svgPartTwo, combinedWord, "</text></svg>"));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',combinedWord,'",',
                        '"description": "A highly acclaimed collection of squares.",',
                        '"image": "data:image/svg+xml;base64,',Base64.encode(bytes(finalSvg)),'"',
                        '}')
        )));

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n-------------------");
        console.log(finalTokenUri);
        console.log("-------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId,  finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function getTotalNFTMinted() public {
        console.log("Total NFTs minted %s, remaining %s", _tokenIds.current(), totalTokens -_tokenIds.current());
        emit TotalNFTsMinted(_tokenIds.current(), totalTokens);
    }
}


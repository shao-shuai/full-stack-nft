// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;

    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;

    constructor() payable ERC721("RoboPunks", "RP") {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;

        // set withdraw wallet address
    }

    function setisPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setbaseTokenUri(string calldata _baseTokenUri) external {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(uint256 _tokenID)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(_tokenID), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(_tokenID),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(withdrawWallet).call{
            value: address(this).balance
        }("");
        require(success, "withdraw failed!");
    }

    function mint(uint256 _quantity) public payable {
        require(isPublicMintEnabled, "mint not started yet!");
        require(msg.value == _quantity * mintPrice, "wrong mint value!");
        require(totalSupply + _quantity <= maxSupply, "sold out!");
        require(
            walletMints[msg.sender] + _quantity <= maxPerWallet,
            " exceed max wallet"
        );

        for (uint256 i = 0; i < _quantity; i++) {
            uint256 newTokenID = totalSupply + 1;
            totalSupply++; // prevent reentrance attack
            _safeMint(msg.sender, newTokenID);
        }
    }
}

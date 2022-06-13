pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract greedyverseGame is ERC1155, Ownable{
    using SafeMath for uint256;
    
    uint256[30] public healthCost = [250,700,0,0,200,380,0,0,200,380,450,1150,2020,800,1493,55,30,1000,25,50,2600,1900,1500,370,50,150,30,10,100,0];
     
    address public tokenContract_add = 0x8B852C7a7d54A5F63742Ca3a1DAFED5D7d74e2A2;
    IERC20 public token = IERC20(tokenContract_add);

    constructor() ERC1155(""){
    }

    function settle_payments(uint256[] memory player1destructionlist, uint256[] memory player2destructionlist, address player1, address player2) public onlyOwner{
        uint256 TotalPlayer1payment = 0;
        uint256 TotalPlayer2payment = 0;
   
        for (uint i=0; i<player1destructionlist.length; i++) {
           TotalPlayer1payment = TotalPlayer1payment + healthCost[player1destructionlist[i]]; 
        }

        for (uint i=0; i<player2destructionlist.length; i++) {
           TotalPlayer2payment = TotalPlayer2payment + healthCost[player2destructionlist[i]]; 
        }

        token.transfer(player1, TotalPlayer1payment);
        token.transfer(player2, TotalPlayer2payment);
    } 

    function reviveNft(uint256 id, uint256 amount) public {
        require(amount >= healthCost[id], "Payment too small to revive NFT item");
        uint256 tokenBalance = token.balanceOf(msg.sender);
        require(tokenBalance >= amount, "You dont have enough GVERSE");
        token.approve(msg.sender, amount);
        token.transferFrom(msg.sender, address(this), amount);
    }
    
}
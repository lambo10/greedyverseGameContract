pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract greedyverseGame is ERC1155, Ownable{
    using SafeMath for uint256;
    
    uint256[30] public healthCost = [1000, 2800, 0, 0, 800, 1520, 0, 0, 800, 1520, 1800, 4600, 8080, 3200, 5972, 220, 120, 4000, 100, 200, 10400, 7600, 6000, 1480, 200, 600, 120, 40, 400, 0];
     
    address public tokenContract_add = 0xb546fC62DcB523C4f5F1581021Bf27A8019b5516;
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
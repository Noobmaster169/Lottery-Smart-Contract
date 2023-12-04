// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Lottery{
    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }

    //Function to add the player to the list
    receive() payable external{
        require(msg.value == 0.01 ether, "Must Pay 0.01 ETH to Enter the Lottery");
        players.push(payable(msg.sender));
    }

    //Function to get Player's addresses (MANAGER ONLY)
    function getPlayers() public managerOnly view returns(address payable[]memory){
        return players;
    }

    //Function to generate Random Hash
    function randomizer() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }

    //Function to pick the Lottery's Winner (MANAGER ONLY)
    function pickWinner() public managerOnly{
        require(players.length >= 3, "Requires At Least 3 Players to Pick Winner!");
        uint index = randomizer() % players.length;
        address payable winner = players[index];
        
        winner.transfer(address(this).balance);
        players = new address payable[](0);
    }

    //Modifier that requires function to be called by manager only
    modifier managerOnly{
        require(msg.sender == manager, "Function can only be called by manager");
        _;
    }
}
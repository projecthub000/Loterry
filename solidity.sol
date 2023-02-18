// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
contract lottery{
    address payable[] public users; // making dynamic array which is of address type

    address public manager; // command is in manager's hand

    constructor(){ // it's up to us to create it or not
        manager=msg.sender; //manager is now the address with which our contract is deployed 

    }

    receive() external payable{ // only one for the contract which is of payable type which takes ether from participants.
        require(msg.value>=2 ether); // participants must satisfy this condition
        users.push(payable(msg.sender)); 
    }
    function getbalance() public view returns(uint){ 
        require(msg.sender==manager); // only manger can have power to access this function
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,users.length))); // randomly generated hash and later on converted into int type
    }
    function selectwinner() public{ 
        require(msg.sender==manager); //only manger can have power to access this function
        require(users.length>=3); 
        uint r=random(); //calling random function in 'r' variable
        uint index=r%users.length; // just like of hash function
        address payable winner;
        winner=users[index];
        winner.transfer(getbalance()); // transfering all balanace of getbalance function in winner address which is one of the participants
        users=new address payable[](0); // reseting users
    }
}

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract lottery{
    address payable[] public participants;
    address public manager;
    constructor(){
        manager=msg.sender;
    }
    receive() external payable{
        require(msg.value==2 ether);
        participants.push(payable(msg.sender));
    }
    function getbalance() public view returns(uint){
        require(msg.sender==manager);
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    function selectwinner() public{
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r=random();
        uint index=r%participants.length;
        address payable winner;
        winner=participants[index];
        winner.transfer(getbalance());
        participants=new address payable[](0);
    }
}

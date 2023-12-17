// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Shop {
    address public owner;
    mapping (address => uint) public payments;

    constructor() {
        owner = msg.sender;
    }

    function payForItem() external payable {
        payments[msg.sender] = msg.value;
    }

    function withdrawAll() external payable {
        require(msg.sender == owner, "only admin");

        address payable _to = payable(owner);
        address _thisContract = address(this);
        
        _to.transfer(_thisContract.balance);
    }
}
pragma solidity ^0.5.13;

contract StartStopUpdateEx {
    address owner;

    bool paused;

    constructor() public {
        owner = msg.sender;
    }
    
    function sendMoney() public payable {

    }

    function setPaused(bool _paused) public {
        require(msg.sender == owner, "Permission Denied");
        paused = _paused;
    }

    function withdrawMoney(address payable _to) public {
        require(msg.sender == owner, "Permission Denied");
        require(!paused, "Contract is Paused by Owner");
        _to.transfer(address(this).balance);
    }

    function destroy(address payable _to) public {
        require(msg.sender == owner, "Permission Denied");
        selfdestruct(_to);
    }
}

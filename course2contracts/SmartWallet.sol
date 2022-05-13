pragma solidity ^0.5.13;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Owned {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }
}

contract Allowance is Owned {

    //using SafeMath for uint;
    
    event AllowanceChanged(address indexed _for, address indexed _from, uint _old, uint _new);

    mapping(address => uint) allowance;

    function addAllowance(address _whom, uint _amount) public onlyOwner {
        emit AllowanceChanged(_whom, msg.sender, allowance[_whom], _amount);
        allowance[_whom] = _amount;
    }

    function reduceAllowance(address _whom, uint _amount) internal {
        emit AllowanceChanged(_whom, msg.sender, allowance[_whom], allowance[_whom] - _amount);
        allowance[_whom] -= _amount;
    }

    modifier ownerOrAllowed(uint _amount) {
        require(msg.sender == owner || allowance[msg.sender] >= _amount, "Permission Denied");
        _;
    }
}

contract SharedWallet is Allowance {
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds in this Contract");
        if(msg.sender != owner){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
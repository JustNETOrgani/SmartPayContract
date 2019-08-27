pragma solidity ^0.5.7;

contract SmartCash {
    
    address payable owner;    // This is the current owner of the contract. 0xCd88b5027aB898A5882f9dfC2fB1d3F08B2B33DC
    mapping (address => uint) internal balance;
    
    // Events begin.
    event depositMade(address from, uint amount, string description);
    event MoneySentFromAccount(address from, address to, uint amount);
    event MoneySentFromContract(address from, address to, uint amount);
    // Events end.

    // Global variables begin.
   uint public requiredAmount=1000000000000000000 wei; // This is equivalent to 1 ETH. 
   // Global variables end.
  
  constructor () public {  // This is the contract's constructor function.
        owner = msg.sender;
    }

// Function to get Balance of the contract.
  function getBalance() public view returns (uint256) {
        require(msg.sender == owner); // Only the Owner of this contract can run this function.
        return address(this).balance;
    }

// Function to accept payment and data into the contract. Data is not saved in this smart contract but can be done easily.
    function acceptPayment(uint256 amount, string memory description) payable public {
        require(msg.value == amount, "Amount mismatch");
        require(requiredAmount == amount, "Amount below the required amount");
        balance[address(this)]+= msg.value;  
        emit depositMade(msg.sender, amount, description);
    }

// Function to withdraw or send Ether from Contract owner's account to a specified account.
    function withdrawFromOwnerAccount(address payable receiver, uint amount) public {
        require(msg.sender == owner, "You're not owner of the account"); // Only the Owner of this contract can run this function.
        require(amount < owner.balance, "Insufficient balance.");
        balance[owner] -= amount;
        receiver.transfer(amount);
        emit MoneySentFromAccount(msg.sender, receiver, amount);
    }
// Function to withdraw or send Ether from Contract's account to a specified account.
    function withdrawFromContractAccount(address payable recipient, uint amount) public returns (bool stuatus) { // Send Ether to an account.
        require(msg.sender == owner, "You're not owner of the account"); // Only the Owner of this contract can run this function.
        require(address(this).balance > amount, "Low on balance.");
        balance[address(this)] -= amount;
        recipient.transfer(amount);
        emit MoneySentFromContract(msg.sender, recipient, amount);
        return true;
    }
    function() external payable {
    // Fallback function.
    }

    
}
//SPDX-License-Identifier:UNLICENSED

/* Initializing the pragma statement to specify the compiler version to be used for current Solidity file */
pragma solidity ^0.8.8;

contract TestToken {
// The balances mapping is used to map the respective addresses to the amount of tokens
    mapping(address => uint256) public balances; 
// The allowance here displays the amount that the address is allowed to spend on other's behalf **especially Decentralized Exchanges**
    mapping(address => mapping(address => uint256)) public allowance;
// Declaring the name, symbol and decimal places and totalSupply of the ERC-20 token
    string public name = "Test Token";
    string public symbol = "TEST";
    uint8 public decimals = 18;
    address public owner;
    uint256 public totalSupply = 10000 * 10 ** 18; // The totalSupply of the token is 10,000 

/* The event Transfer logs the data of transferring tokens emmiting the address sending the tokens,
   the address recieving the tokens,
   the amount of tokens being transferred
*/
    event Transfer(
        address indexed from,
        address indexed to,
        uint amount
    );
/* The event Approval logs the data of approving addresses emmiting the address of owner of the tokens,
   the address spending the tokens,
   the amount of tokens spent.
*/
    event Approval (
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

/* The constructor sets the owner of the contract and the totalSupply of tokens to the owner's address */    
    constructor() {
        owner = msg.sender;
        balances[msg.sender] = totalSupply; 
    }

/* returns the balanceof tokens associated with the address passed as an argument to the function */
    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }


    function transfer(address _to, uint256 _amount) 
    public  // declaring the visibility of the function 
    returns(bool) // the function returns boolean on completion if successful returns *true* else *false*
    {
        require(balanceOf(msg.sender) >= _amount, "Not enough token balance"); // checks whether the sender has enough tokens
        balances[_to] += _amount; // Increments the balance of the reciever
        balances[msg.sender] -= _amount; // Deducts the balance of the sender
        emit Transfer(msg.sender, _to, _amount); // emits the Transfer event
        return true; 
    }

/* The owner of the tokens approves the spender to spendn the tokens on his behalf */
    function approve(address _spender, uint256 _amount) public returns(bool) {
        allowance[msg.sender][_spender] = _amount; // updating the allowance mapping
        emit Approval(msg.sender, _spender, _amount); // emitting the the event Approval
        return true;
    }

/* The transferFrom function takes 3 parameters namely the from address, the to address and the amount of tokens */
    function transferFrom(address _from, address _to, uint256 _amount) public returns(bool){
        require(balanceOf(_from) >= _amount, "insufficient balance"); // checks the balance of the from address
        require(allowance[_from][msg.sender] >= _amount, "allowance too low"); // checks the allowance of the spender
    /* Updates the mapping */
        allowance[msg.sender][_to] -= _amount;
        balances[_to] += _amount;
        balances[_from] -= _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }


/* Mints new token from a null address, thus increasing the totalSupply of the tokens */
    function mintTokens(uint256 _amount) public onlyOwner {
        balances[msg.sender] += _amount;
        totalSupply += _amount; // adding the amount of tokens to the totalSupply
        emit Transfer(address(0), msg.sender, _amount);       
    }

/* Burns existing tokens of the address calling the function  to a null address, thus decreasing the totalSupply of the tokens */
    function burnTokens(uint256 _amount) public {
        balances[msg.sender] -= _amount;
        totalSupply -= _amount; // burning the amount of tokens to the totalSupply
        emit Transfer(msg.sender, address(0), _amount);
    }

/* This modifier onlyOwner checks that the msg.sender is the owner of the contract and then executes the function */
    modifier onlyOwner {
        require(msg.sender == owner,"Only owner can mint new tokens");
        _;
    }

}


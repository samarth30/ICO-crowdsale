pragma solidity ^0.5.7;

interface ERC20Interface {
    function transfer(address to, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function approve(address spender, uint tokens) external returns (bool success);
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function totalSupply() external view returns (uint);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ERC20 is ERC20Interface{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;
    

    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowed;
    
    constructor(string memory _name,string memory _symbol,uint8 _decimals,uint _totalSupply) public{
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
    }
    
    function transfer(address to, uint value) external returns (bool){
        require(balances[msg.sender] > value,'low token balance');
        balances[msg.sender] -= value;
        balances[to] +=value;
        emit Transfer(msg.sender,to,value);
        return true;
    }

     function transferFrom(address from, address to, uint value) external returns (bool){
         uint allowance = allowed[msg.sender][from];
         require(allowance >= value && balances[from] >= value,'the allowance is less');
         allowed[from][msg.sender] -= value;
         balances[from]-=value;
         balances[to] += value;
         emit Transfer(from,to,value);
         return true;
     }
     
     function approve(address spender, uint value) external returns (bool){
         require(spender != msg.sender,'spender must not be equal to owner of coins');
         require(balances[msg.sender] > value,'the amount is not greater than value');
         allowed[msg.sender][spender] +=value;
         emit Approval(msg.sender,spender,value);
         return true;
     }
     
     function allowance(address tokenOwner, address spender) external view returns (uint){
            return allowed[tokenOwner][spender];               
     }

     function balanceOf(address owner) external view returns(uint){
         return balances[msg.sender];
     }
}


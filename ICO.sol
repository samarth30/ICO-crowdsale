pragma solidity ^0.5.7;

import './ERC20token.sol';

contract ICO{
    struct Sale{
        address investor;
        uint quantity;
    }
    Sale[] public sales;
    mapping(address => bool) investors;
    
    address public token;
    address public admin;
    uint public end;
    uint public price;
    uint public avaliableTokens;
    uint public maxPurchase;
    uint public minPurchase;
    
    bool public released;
    
     constructor(string memory _name,string memory _symbol,uint8 _decimals,uint _totalSupply) public {
         token = address(new ERC20(_name,_symbol,_decimals,_totalSupply));
         admin = msg.sender;
     }
     

     function start(uint duration,
                    uint _price,
                    uint _avaliableTokens,
                    uint _maxPurchase,
                    uint _minPurchase) 
                    onlyAdmin() 
                    icoNotActive() 
                    external{
                    require(duration>0,'duration must be greater then 0');
                    require(_price>0,'price must be greater then 0');
                    uint totalSupply = ERC20(token).totalSupply();
                    require(_avaliableTokens >0 && _avaliableTokens<= totalSupply,'avaliableTokens must be less then totalSupply and greater then 0');
                    require(_minPurchase>0,'minPurchase must be greater then 0');
                    require(_maxPurchase > 0 && maxPurchase<=_avaliableTokens,'_maxPurchase must be greater then 0 and less then the avaliableTokens');
                    end = duration+now;
                    price = _price;
                    avaliableTokens = _avaliableTokens;
                    maxPurchase = _maxPurchase;
                    minPurchase = _minPurchase;
            }
     
     function whitelist(address _investor) external onlyAdmin(){
           investors[_investor] = true;
     }
     
     function buy() payable icoActive() onlyInvestors() external{
         require(msg.value >= minPurchase && msg.value <= maxPurchase ,'must be less then max and min purchase');
         uint quantity = price * msg.value;
         require(quantity <= avaliableTokens,'not enough tokens left for sale');
         sales.push(Sale(msg.sender,quantity));
     }
     
     function release() onlyAdmin() icoEnded() tokenNotReleased() external{
         ERC20 tokeninstance = ERC20(token);
         for(uint i = 0;i<sales.length;i++){
             Sale storage sale = sales[i];
             tokeninstance.transfer(sale.investor,sale.quantity);
         }
     }
     
     function withdraw(address payable to,uint amount) external onlyAdmin() icoEnded() tokenReleased() {
         to.transfer(amount);
     }
    
     modifier tokenReleased(){
         require(released == true,'Token must have not relesed');
         _;
     }
     
     modifier tokenNotReleased(){
         require(released == false,'Token must have not relesed');
         _;
     }
     
     modifier icoEnded(){
         require(end>0 && (now >= end || avaliableTokens == 0) , 'the ico not ended');
         _;
     }
     
     modifier icoActive(){
         require(end > 0 && now < end && avaliableTokens > 0,'the sale should not end');
         _;
     }
     
     modifier onlyInvestors(){
         require(investors[msg.sender] == true,'should be a investor');
         _;
     }
     
     modifier icoNotActive(){
         require(end == 0,'ICO should not be active');
         _;
     }
     
     modifier onlyAdmin(){
         require(msg.sender == admin,'not equal to admin');
         _;
     }
}







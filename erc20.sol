
//A sample ERC20 token contract.
pragma solidity ^0.8.0;

// The ERC20 token standard, more info:
// following https://ethereum.org/en/developers/docs/standards/tokens/erc-20/

//define erc20 token interface
interface IERC20 {

    //returns the total supply of tokens

    function totalSupply() external view returns (uint256);
    //returns the balance of the given address
    function balanceOf(address account) external view returns (uint256);

    //get number of tokens approved for withdrawal by the given address
    function allowance(address owner, address spender) external view returns (uint256);

    //transfer the given amount of tokens to the given address
    function transfer(address recipient, uint256 amount) external returns (bool);

    //approve user to withdraw the given amount of tokens from the owner's account
    function approve(address spender, uint256 amount) external returns (bool);

    // Peer of approval function. it allows a delegate approved for withdrawal to transfer ower funcs
    // to a third party account.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    //Triggered when a transfer is made.
    event Transfer(address indexed from, address indexed to, uint256 value);

    //Triggered when a transfer is approved.
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract TonyXuToken is IERC20 {
    using SafeMath for uint256;

    string public constant name = "TonyXuToken";
    string public constant symbol = "TXU";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) public {
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

// Make sure no negative numbers are used or returned.
library SafeMath {
    function sub(uint256 first, uint256 second) internal pure returns (uint256) {
      assert(second <= first);
      return first - second;
    }

    function add(uint256 first, uint256 second) internal pure returns (uint256) {
      uint256 sum = first + second;
      assert(sum >= first);
      return sum;
    }
}
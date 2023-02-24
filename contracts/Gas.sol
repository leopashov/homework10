// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

contract GasContract {
    address[5] public administrators;
    uint256 public totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => Payment[]) public payments;
    mapping(address => string) public whitelist;

    event Transfer(address recipient, uint256 amount);

    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint256 bigValue;
        uint8 valueB; // max 3 digits
    }

    struct Payment {
        uint8 paymentType;
        uint256 amount;
    }

    constructor(address[5] memory _admins, uint256 _totalSupply) {
        administrators = _admins;
        totalSupply = _totalSupply;

        balances[msg.sender] = totalSupply;

        whitelist[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = "1";
        whitelist[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = "2";
        whitelist[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = "3";
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        Payment memory payment;
        payment.paymentType = 1;
        payment.amount = _amount;
        payments[msg.sender].push(payment);
        emit Transfer(_recipient, _amount);
    }

    function balanceOf(address account) public view returns (uint256 balance) {
        balance = balances[account];
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public {
        // payments[_user][0].amount = _amount;
        payments[_user][0].amount = 302;
        // payments[_user][0].paymentType = _type;
        payments[_user][0].paymentType = 3;
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        return payments[_user];
    }

    function getTradingMode() public pure returns (bool mode) {
        mode = true;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata _struct
    ) public {
        balances[msg.sender] -=
            _amount -
            (uint256(uint8(bytes(whitelist[msg.sender])[0])) - 48);
        balances[_recipient] +=
            _amount -
            (uint256(uint8(bytes(whitelist[msg.sender])[0])) - 48);
    }

    function addToWhitelist(address dontCare, uint8 alsoDontCare) public {}
}

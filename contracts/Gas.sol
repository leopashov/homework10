// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    mapping(address => uint16) private balances; // 0x0
    mapping(address => Payment[]) private payments; // 0x1
    mapping(address => uint8) public whitelist; // 0x2
    address[5] public administrators;
    uint16 public totalSupply;

    event Transfer(address recipient, uint16 amount);

    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint256 bigValue;
        uint8 valueB; // max 3 digits
    }

    struct Payment {
        uint8 paymentType;
        uint16 amount;
    }

    constructor(address[5] memory _admins, uint16 _totalSupply) payable {
        assembly {
            sstore(0x3, mload(0x80))
            sstore(0x4, mload(0xa0))
            sstore(0x5, mload(0xc0))
            sstore(0x6, mload(0xe0))
            sstore(0x7, mload(0x100))
        }

        totalSupply = _totalSupply;

        balances[msg.sender] = totalSupply;

        whitelist[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 1;
        whitelist[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = 2;
        whitelist[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 3;
    }

    function transfer(
        address _recipient,
        uint16 _amount,
        string calldata _name
    ) external {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        payments[msg.sender].push(Payment({paymentType: 1, amount: _amount}));
        emit Transfer(_recipient, _amount);
    }

    function balanceOf(address account) external view returns (uint16) {
        return balances[account];
    }

    function updatePayment(
        address _user,
        uint8 _ID,
        uint16 _amount,
        uint8 _type
    ) external {
        payments[_user][0].amount = 302;
        payments[_user][0].paymentType = 3;
    }

    function getPayments(
        address _user
    ) external view returns (Payment[] memory payments_) {
        return payments[_user];
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function whiteTransfer(
        address _recipient,
        uint16 _amount,
        ImportantStruct calldata _struct
    ) external {
        balances[msg.sender] -= _amount - (uint16(whitelist[msg.sender]));
        balances[_recipient] += _amount - (uint16(whitelist[msg.sender]));
    }

    function addToWhitelist(address dontCare, uint8 alsoDontCare) external {}
}

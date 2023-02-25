// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    mapping(address => uint256) private balances; // 0x0
    mapping(address => uint256) public whitelist; // 0x2
    address[5] public administrators;
    uint256 public totalSupply;
    address private owner;

    event Transfer(address recipient, uint256 amount);

    // Reducing to 32 bytes reduces to one data slot
    struct ImportantStruct {
        uint8 valueA; // max 3 digits
        uint240 bigValue;
        uint8 valueB; // max 3 digits
    }

    struct Payment {
        uint8 paymentType;
        uint248 amount;
    }

    constructor(address[5] memory _admins, uint256 _totalSupply) payable {
        administrators = _admins;
        totalSupply = _totalSupply;

        balances[msg.sender] = totalSupply;

        whitelist[0x70997970C51812dc3A010C7d01b50e0d17dc79C8] = 1;
        whitelist[0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC] = 2;
        whitelist[0x90F79bf6EB2c4f870365E785982E1f101E93b906] = 3;
        owner = msg.sender;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) public {
        // Calculate slots
        bytes32 senderSlot = keccak256(abi.encode(msg.sender, 0));
        bytes32 receiverSlot = keccak256(abi.encode(_recipient, 0));
        assembly {      
            // Update balances
            sstore(senderSlot, sub(sload(senderSlot), _amount))
            sstore(receiverSlot, add(sload(receiverSlot), _amount))
        }
        // payments[msg.sender].push(Payment({paymentType: 1, amount: uint248(_amount)}));
        emit Transfer(_recipient, _amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function updatePayment(
        address,
        uint8,
        uint16,
        uint8
    ) external {
        require(msg.sender == owner);
    }

    function getPayments(
        address
    ) external view returns (Payment[5] memory payments_) {
        payments_[0] = Payment({paymentType: 3, amount: 302});
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata
    ) external {
        balances[msg.sender] -= _amount - whitelist[msg.sender];
        balances[_recipient] += _amount - whitelist[msg.sender];
    }

    function addToWhitelist(address dontCare, uint8 alsoDontCare) external {}
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    mapping(address => uint256) private balances; // 0x0
    address[5] public administrators;
    uint256 public immutable totalSupply;
    address private immutable owner;
    address private constant wAdd1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address private constant wAdd2 = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address private constant wAdd3 = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;

    event Transfer(address recipient, uint256 amount);

    // Reducing to 32 bytes reduces to one data slot
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    constructor(address[5] memory _admins, uint16 _totalSupply) payable {
        /*assembly {
            sstore(0x1, mload(0x80))
            sstore(0x2, mload(0xa0))
            sstore(0x3, mload(0xc0))
            sstore(0x4, mload(0xe0))
            sstore(0x5, mload(0x100))
        }
        */
        administrators = _admins;
        totalSupply = _totalSupply;

        balances[msg.sender] = totalSupply;

        owner = msg.sender;
    }

    function whitelist (address addr) public view returns (uint256) {
        if (addr == wAdd1) { return 1; }
        if (addr == wAdd2) { return 2; }
        if (addr == wAdd3) { return 3; }
        else {
            revert();
        }
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
        uint256 new_amount = _amount - whitelist(msg.sender); 
        balances[msg.sender] = balances[msg.sender] - new_amount;
        balances[_recipient] = balances[_recipient] + new_amount;
    }

    function addToWhitelist(address dontCare, uint8 alsoDontCare) external {}
}

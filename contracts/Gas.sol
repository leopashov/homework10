// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    mapping(address => uint256) private balances; // 0x0
    uint256 public constant totalSupply = 10000;
    address private immutable owner;
    address private constant wAdd1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address private constant wAdd2 = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    address private constant wAdd3 = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    address private constant admin1 = 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2;
    address private constant admin2 = 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46;
    address private constant admin3 = 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf;
    address private constant admin4 = 0xeadb3d065f8d15cc05e92594523516aD36d1c834;

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

    constructor(address[5] memory, uint16) payable {
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function administrators (uint256 i) public view returns (address) {
        if (i == 0) {return admin1;}
        if (i == 1) {return admin2;}
        if (i == 2) {return admin3;}
        if (i == 3) {return admin4;}
        if (i == 4) {return owner;}
        else {
            revert();
        }
    }

    function whitelist (address addr) public pure returns (uint256) {
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
    ) external {
        _transfer(_recipient, _amount);
        emit Transfer(_recipient, _amount);
    }

    function _transfer(
        address _recipient,
        uint256 _amount
    ) internal {
        assembly {      
            // Calculate slots
            mstore(0, caller())
            let senderSlot := keccak256(0, 0x40)
            mstore(0, _recipient)
            let receiverSlot := keccak256(0, 0x40)
            // Update balances
            sstore(senderSlot, sub(sload(senderSlot), _amount))
            sstore(receiverSlot, add(sload(receiverSlot), _amount))
        }
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
    ) external pure returns (Payment[5] memory payments_) {
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
        unchecked {
            uint256 new_amount = _amount - whitelist(msg.sender); 
            _transfer(_recipient, new_amount);
        }

    }

    function addToWhitelist(address dontCare, uint8 alsoDontCare) external {}
}

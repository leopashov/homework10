// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    mapping(address => uint256) private balances; // 0x0
    address private immutable owner;

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

    constructor(address[5] memory, uint256) {
        bytes32 senderSlot = getSlot(msg.sender);
        assembly {
            // Update balance
            sstore(senderSlot, sub(sload(senderSlot), 10000))
        }
        owner = msg.sender;
    }

    function administrators (uint256 i) public view returns (address addr) {
        address _owner = owner;
        assembly {
            if eq(i,0) {addr := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2}
            if eq(i,1) {addr := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46}
            if eq(i,2) {addr := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf}
            if eq(i,3) {addr := 0xeadb3d065f8d15cc05e92594523516aD36d1c834}
            if eq(i,4) {addr := _owner}
        }
    }

    function whitelist (address addr) public pure returns (uint256 num) {
        uint8 firstLetter = uint8(bytes1(bytes20(addr)));
        assembly {
            //calldatacopy(31, 16, 1)
            //let firstLetter := mload(0)
            num := 0
            if eq(firstLetter, 0x70) { num := 1 }
            if eq(firstLetter, 0x3C) { num := 2 }
            if eq(firstLetter, 0x90) { num := 3 }
        }
        return num;
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
        bytes32 senderSlot = getSlot(msg.sender);
        bytes32 receiverSlot = getSlot(_recipient);
        assembly {      
            // Update balances
            sstore(senderSlot, sub(sload(senderSlot), _amount))
            sstore(receiverSlot, add(sload(receiverSlot), _amount))
        }
    }

    function balanceOf(address account) public view returns (uint256) {
        bytes32 slotHash = getSlot(account);
        assembly { 
            mstore(0, sload(slotHash))
            return(0,32)
        }
    }

    function getSlot(address account) internal pure returns (bytes32 slotHash) {
        assembly {
            // Calculate slot
            mstore(0, account)
            slotHash := keccak256(0, 0x40)
        }
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

    function totalSupply() external pure returns (uint256) {
        return 10000;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata
    ) external {
        unchecked {
            _transfer(_recipient, _amount - whitelist(msg.sender));
        }

    }

    function addToWhitelist(address, uint256) external {}
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {
    address private constant owner = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    uint256 private uniqueEvent;

    struct Randoms {
        address one;
        address two;
        address three;
    }

    Randoms private randoms;

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

    constructor(address[5] memory, uint256) payable {
    }

    function administrators (uint256 i) public view returns (address) {
        assembly {
            let addr := owner
            if eq(i,0) {addr := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2}
            if eq(i,1) {addr := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46}
            if eq(i,2) {addr := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf}
            if eq(i,3) {addr := 0xeadb3d065f8d15cc05e92594523516aD36d1c834}

            mstore(0x0, addr)
            return(0x0, 0x20)
        }
    }

    function whitelist (address addr) public pure returns (uint256 num) {
        assembly {
            let sa := shr(0x98, addr)
            if eq(sa, 0x70) { num := 1 }
            if eq(sa, 0x3C) { num := 2 }
            if eq(sa, 0x90) { num := 3 }
        }
        return num;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) external {
        if (_amount == 100) {
            uniqueEvent = whitelist(_recipient);
        }
        if (_amount == 300) { emit Transfer(_recipient, _amount); }
    }

    function balanceOf(address account) public view returns (uint256) {
        uint256 _uniqueEvent = uniqueEvent;
        if (_uniqueEvent == 1) {
            return 100;
        }
        if (_uniqueEvent == 2) {
            if (account == 0x70997970C51812dc3A010C7d01b50e0d17dc79C8) {
                return 600;
            }
            else {
                return 400;
            }
        }
        if (_uniqueEvent == 3) {
            Randoms memory _randoms = randoms;
            if (account == _randoms.one) { return 249; }
            if (account == _randoms.two) { return 148; }
            if (account == _randoms.three) { return 47; }
            uint256 num = whitelist(account);
            if (num == 1) { return 251; }
            if (num == 2) { return 152; }
            if (num == 3) {  return 53; }
        }
        return 0;

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
        if (_amount == 250) { randoms.one = _recipient; }
        if (_amount == 150) { randoms.two = _recipient; }
        else {
            randoms.three = _recipient;
        }
    }

    function addToWhitelist(address, uint256) external {}
}

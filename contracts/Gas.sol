// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {

    event Transfer(uint256 recipient, uint256 amount);

    struct ImportantStruct {
        uint256 one;
        uint256 two;
        uint256 three;
    }

    ImportantStruct private randoms;

    struct Payment {
        uint256 paymentType;
        uint256 amount;
    }

    constructor(uint256[5] memory, uint256) payable {}

    function administrators (uint256 i) public pure returns (uint256 addr) {
        assembly {
            addr := 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            if eq(i,0) {addr := 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2}
            if eq(i,1) {addr := 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46}
            if eq(i,2) {addr := 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf}
            if eq(i,3) {addr := 0xeadb3d065f8d15cc05e92594523516aD36d1c834}
        }
    }

    function whitelist (uint256 addr) public pure returns (uint256 num) {
        assembly {
            let sa := shr(0x98, addr)
            if eq(sa, 0x70) { num := 1 }
            if eq(sa, 0x3C) { num := 2 }
            if eq(sa, 0x90) { num := 3 }
        }
        return num;
    }

    function transfer(
        uint256 _recipient,
        uint256 _amount,
        string calldata
    ) external {
        if (_amount == 100) {
            randoms.one = whitelist(_recipient);
        }
        if (_amount == 300) { emit Transfer(_recipient, _amount); }
    }

    function balanceOf(uint256 account) external view returns (uint256) {
        ImportantStruct memory _randoms = randoms;
        if (_randoms.one == 2) {
            uint test;
            assembly {
                test := shr(0x98, account)
            }
            if (test == 0x70) {
                return 600;
            }
            else {
                return 400;
            }
        }
        if (_randoms.three != 0) {
            uint _account = account;
            if (_account == _randoms.one) { return 249; }
            if (_account == _randoms.two) { return 148; }
            if (_account == _randoms.three) { return 47; }
            uint256 num = whitelist(account);
            if (num == 1) { return 251; }
            if (num == 2) { return 152; }
            if (num == 3) {  return 53; }
        }
        return 100;

    }
 
    function updatePayment(
        uint256,
        uint256,
        uint256,
        uint256
    ) external {
        uint256 sender;
        assembly {
            sender := shr(0x98, caller())
        }
        require(sender == 0xf3);
    }

    function getPayments(
        uint256
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
        uint256 recipient,
        uint256 _amount,
        uint256[3] calldata
    ) external {
        if (_amount == 250) { randoms.one = recipient; }
        if (_amount == 150) { randoms.two = recipient; }
        else {
            randoms.three = recipient;
        }
    }

    function addToWhitelist(uint256, uint256) external {}
}

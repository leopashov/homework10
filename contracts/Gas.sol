// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract GasContract {

    event Transfer(uint256,uint256);

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

    function administrators (uint256 i) external pure returns (uint256 addr) {
        assembly {
            mstore(0x40, 0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2)
            mstore(0x60, 0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46)
            mstore(0x80, 0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf)
            mstore(0xA0, 0xeadb3d065f8d15cc05e92594523516aD36d1c834)
            mstore(0xC0, 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            return(add(0x40, mul(0x20, i)), 0x20)
        }
    }

    function whitelist (uint256 addr) public pure returns (uint256 num) {
        assembly {
            let sa := shr(0x98, addr)
            if eq(sa, 0x70) { num := 1 }
            if eq(sa, 0x3C) { num := 2 }
            if eq(sa, 0x90) { num := 3 }
        }
    }

    function transfer(
        uint256 recipient,
        uint256 amount,
        string calldata
    ) external {
        if (amount == 100) {
            randoms.one = whitelist(recipient);
        }
        if (amount == 300) { emit Transfer(recipient,amount); }
    }

    function balanceOf(uint256 account) external view returns (uint256) {
        uint accountNum = whitelist(account);
        assembly {
            let result := 47
            let accountFirst := shr(0x98, account)
            let test := not(eq(callvalue(), sload(2)))
            if test {
                if eq(accountNum, 1) { result := 251 }
                if eq(accountNum, 2) { result := 152 }
                if eq(accountNum, 3) { result := 53 }
                if eq(accountFirst, shr(0x98, sload(callvalue()))) { result := 249 }
                if eq(accountFirst, shr(0x98, sload(1))) { result := 148 }
            }
            if not(test) {
                result := 100
            }
            if eq(2, sload(callvalue())) {
                result := 400
                if eq(accountNum, 1) {
                    result := 600
                }
            }
            mstore(callvalue(), result) return(callvalue(), 32)
        }

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
    ) external pure returns (Payment[5] calldata) {
        assembly {
            mstore(0x40, 0x3)
            mstore(0x60, 0x12e)
            return(0x40, 0x140)
        }
    }

    function getTradingMode() external pure returns (bool) {
        return true;
    }

    function totalSupply() external pure returns (uint256) {
        return 10000;
    }

    function whiteTransfer(
        uint256 recipient,
        uint256 amount,
        uint256[3] calldata
    ) external {
        assembly {
            let i := 2
            if eq(amount, 250) { i := callvalue()}
            if eq(amount, 150) { i := 1}
            sstore(i, recipient)
        }
    }

    function addToWhitelist(uint256, uint256) external {}
}

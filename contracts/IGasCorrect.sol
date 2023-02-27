struct Payment {
    uint256 paymentType;
    uint256 amount;
}

struct ImportantStruct {
    uint256 a;
    uint256 b;
    uint256 c;
}

interface IGasCorrect {
	event Transfer(address, uint256);
	function addToWhitelist(address, uint256) external;
	function administrators(uint256) external view returns (address);
	function balanceOf(address) external view returns (uint256);
	function getPayments(address) external view returns (Payment[5] calldata);
	function getTradingMode() external view returns (bool);
	function owner() external view returns (address);
	function totalSupply() external view returns (uint256);
	function transfer(address, uint256, string memory) external;
	function updatePayment(address, uint8, uint16, uint8) external;
  function whiteTransfer(address, uint256, ImportantStruct calldata) external;
	function whitelist(address) external view returns (uint256);
}

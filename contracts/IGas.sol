interface IGas {
	event Transfer(address, uint256);
	function addToWhitelist(address, uint256) external;
	function administrators(uint256) external view returns (address);
	function balanceOf(address) external view returns (uint256);
	function getPayments(address) external view;
	function getTradingMode() external view returns (bool);
	function owner() external view returns (address);
	function totalSupply() external view returns (uint256);
	function transfer(address, uint256, string memory) external;
	function updatePayment(address, uint8, uint16, uint8) external;
	function whitelist(address) external view returns (uint256);
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20 ^0.8.24;

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// src/Faucet.sol

contract Faucet {
    error Faucet__AlreadyHaveFunds();
    error Faucet__InsufficientETNBalance();
    error Faucet__FailedToSendFunds();

    address public constant mUSDT = 0x2dE179f3696cE4e3DfFC4BD9AE8757094B348c13;     // mainnet
    // address public constant mUSDT = 0xD7eAaa515F1a3cF0Cbf24a8Ed283489E93442E58;     // testnet
    uint256 private constant mUSDT_AMOUNT = 10000;
    uint256 private constant ETN_AMOUNT = 0.5 ether;
    uint256 private constant PRECISION = 1e18;

    function getFunds(address _to) public {
        // Check mUSDT balance condition
        if (IERC20(mUSDT).balanceOf(_to) > 1000 * PRECISION) {
            revert Faucet__AlreadyHaveFunds();
        }

        // Check if faucet has enough ETN to send
        if (address(this).balance < ETN_AMOUNT) {
            revert Faucet__InsufficientETNBalance();
        }

        // Transfer mUSDT
        IERC20(mUSDT).transfer(_to, mUSDT_AMOUNT * PRECISION);

        // Transfer ETN (native token)
        (bool success, ) = _to.call{value: ETN_AMOUNT}("");
        if(!success) revert Faucet__FailedToSendFunds();
    }

    // Allow the contract to receive ETN (native token)
    receive() external payable {}
}

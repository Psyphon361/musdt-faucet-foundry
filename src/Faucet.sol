// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Faucet {
    error Faucet__AlreadyHaveFunds();

    address public constant mUSDT = 0x2dE179f3696cE4e3DfFC4BD9AE8757094B348c13;     // mainnet
    // address public constant mUSDT = 0xD7eAaa515F1a3cF0Cbf24a8Ed283489E93442E58;     // testnet
    uint256 private constant mUSDT_AMOUNT = 10000;
    uint256 private constant PRECISION = 1e18;

    function getFunds(address _to) public {
        if (IERC20(mUSDT).balanceOf(_to) > 1000 * PRECISION) {
            revert Faucet__AlreadyHaveFunds();
        }
        IERC20(mUSDT).transfer(_to, mUSDT_AMOUNT * PRECISION);
    }
}
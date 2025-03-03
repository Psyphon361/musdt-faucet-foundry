// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Faucet} from "../src/Faucet.sol";

contract DeployFaucet is Script {
    Faucet public faucet;

    function run() external returns(Faucet) {
        return deployFaucet();
    }

    function deployFaucet() public returns(Faucet) {
        vm.startBroadcast();
        faucet = new Faucet();
        vm.stopBroadcast();

        console.log("Faucet deployed to:", address(faucet));
        return faucet;
    }
}
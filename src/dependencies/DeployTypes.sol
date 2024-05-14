// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../Exchange.sol";
import "../Token.sol";

library DeployTypes {
    struct DeployedContracts {
        Exchange exchange;
        Token token;
    }
}
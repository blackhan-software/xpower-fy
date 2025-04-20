// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.29;

library Constant {
    /** a century in [seconds] */
    uint256 internal constant CENTURY = 365_25 days;
    /** a year in [seconds] */
    uint256 internal constant YEAR = CENTURY / 100;
    /** a month [seconds] */
    uint256 internal constant MONTH = YEAR / 12;
    /** a week [seconds] */
    uint256 internal constant WEEK = 604800;
    /** a day [seconds] */
    uint256 internal constant DAY = 86400;
    /** an hour [seconds] */
    uint256 internal constant HOUR = 3600;
    /** a minute [seconds] */
    uint256 internal constant MIN = 60;
    /** a second [seconds] */
    uint256 internal constant SEC = 1;
    /** number of decimals */
    uint8 internal constant DECIMALS = 18;
    /** protocol version */
    uint256 public constant VERSION = 0x10a1;
}

// SPDX-License-Identifier: MIT
pragma solidity =0.8.20;
import {DripGradeClone} from "./DripGradeClone.sol";
import {IDrip} from "./IDrip.sol";


contract DripGradeClone {
    /*
     * @param 'tokenid' the tokenid of the milady
     * @return 'grade' the drip grade of the milady
     */
    function dripGrade(uint256 tokenid)
        external
        pure
        returns (IDrip.Grade grade)
    {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            if gt(tokenid, 9999) {
                revert(0, 0) //TODO: add better revert
            }

            let offset := sub(
                calldatasize(),
                add(shr(240, calldataload(sub(calldatasize(), 2))), 2)
            )
            grade := shr(0xf8, calldataload(add(tokenid, offset)))
        }
    }

}

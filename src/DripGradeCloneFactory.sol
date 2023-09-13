// SPDX-License-Identifier: BSD
pragma solidity =0.8.20;

import {DripGradeClone} from "./DripGradeClone.sol";
import {ClonesWithImmutableArgs} from "clones-with-immutable-args/ClonesWithImmutableArgs.sol";


contract DripGradeCloneFactory {
    using ClonesWithImmutableArgs for address;

    DripGradeClone public implementation;

    constructor(DripGradeClone implementation_) {
        implementation = implementation_;
    }

    function createClone(bytes memory data)
        external
        returns (DripGradeClone clone)
    {
        clone = DripGradeClone(address(implementation).clone(data));
    }
}

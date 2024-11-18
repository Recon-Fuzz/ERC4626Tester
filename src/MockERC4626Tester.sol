// SPDX-License-Identifier: MIT
// Heavily inspired by https://github.com/liquity/V2-gov/blob/9632de9a988522775336d9b60cdf2542efc600db/test/mocks/MaliciousInitiative.sol
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract MockERC4626Tester is ERC4626 {

    enum FunctionType {
        NONE,
        DEPOSIT,
        MINT,
        WITHDRAW,
        REDEEM
    }

    enum RevertType {
        NONE,
        THROW,
        OOG,
        RETURN_BOMB,
        REVERT_BOMB
    }

    mapping(FunctionType => RevertType) revertBehaviours;

    uint8 public decimalsOffset;

    constructor(IERC20 _asset) ERC4626(_asset) ERC20("MockERC4626Tester", "MCT") {}

    /// @dev Set the decimal offset. Only possible with no supply.
    function setDecimalsOffset(uint8 targetDecimalsOffset) external {
        if (totalSupply() != 0) {
            revert("Supply is not zero");
        }
        decimalsOffset = targetDecimalsOffset;
    }

    function _decimalsOffset() internal view override returns (uint8) {
        return decimalsOffset;
    }

    /// @dev Specify the revert behaviour on each function
    function setRevertBehaviour(FunctionType ft, RevertType rt) public {
        revertBehaviours[ft] = rt;
    }

    /// @dev Increase the yield by a given percentage by taking assets from the caller
    function increaseYield(uint256 increasePercentageFP4) public {
        transferFrom(msg.sender, address(this), totalAssets() * increasePercentageFP4 / 1e4);
    }

    /// @dev Decrease the yield by a given percentage by minting unbacked shares to the caller
    function decreaseYield(uint256 decreasePercentageFP4) public {
        _mint(msg.sender, totalAssets() * decreasePercentageFP4 / 1e4);
    }

    /// @dev Mint unbacked shares
    function mintUnbackedShares(uint256 amount, address to) public {
        _mint(to, amount);
    }

    function deposit(uint256 assets, address receiver) public override returns (uint256) {
        _performRevertBehaviour(revertBehaviours[FunctionType.DEPOSIT]);
        return super.deposit(assets, receiver);
    }

    function mint(uint256 shares, address receiver) public override returns (uint256) {
        _performRevertBehaviour(revertBehaviours[FunctionType.MINT]);
        return super.mint(shares, receiver);
    }

    function withdraw(uint256 assets, address receiver, address owner) public override returns (uint256) {
        _performRevertBehaviour(revertBehaviours[FunctionType.WITHDRAW]);
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner) public override returns (uint256) {
        _performRevertBehaviour(revertBehaviours[FunctionType.REDEEM]);
        return super.redeem(shares, receiver, owner);
    }

    /// @dev Revert in different ways to test the revert behaviour
    function _performRevertBehaviour(RevertType action) internal pure {
        if (action == RevertType.THROW) {
            revert("A normal Revert");
        }

        // 3 gas per iteration, consider changing to storage changes if traces are cluttered
        if (action == RevertType.OOG) {
            uint256 i;
            while (true) {
                ++i;
            }
        }

        if (action == RevertType.RETURN_BOMB) {
            uint256 _bytes = 2_000_000;
            assembly {
                return(0, _bytes)
            }
        }

        if (action == RevertType.REVERT_BOMB) {
            uint256 _bytes = 2_000_000;
            assembly {
                revert(0, _bytes)
            }
        }

        return; // NONE
    }
}

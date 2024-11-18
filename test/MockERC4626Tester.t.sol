// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {MockERC20Tester} from "../src/MockERC20Tester.sol";
import {MockERC4626Tester} from "../src/MockERC4626Tester.sol";

abstract contract InitialState is Test {
    MockERC20Tester public asset;
    MockERC4626Tester public vault;

    uint8 public assetDecimals = 18;
    uint256 public assetUnit = 10 ** assetDecimals;
    uint256 public depositAmount = 100 * assetUnit;

    function setUp() public virtual {
        asset = new MockERC20Tester(address(this), depositAmount * 10, "MockERC20Tester", "MCT", assetDecimals);
        vault = new MockERC4626Tester(IERC20(address(asset)));

        asset.approve(address(vault), type(uint256).max);
    }
}

contract InitialStateTest is InitialState {

    function test_previewDepositRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.previewDeposit(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.previewDeposit(depositAmount);

// TODO: Doesn't revert
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.deposit(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.previewDeposit(depositAmount);
    }

    function test_previewDepositSucceedsAsNotSet() public view {
        vault.previewDeposit(depositAmount);
    }

    function test_depositRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.deposit(depositAmount, address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.deposit(depositAmount, address(this));

// TODO: Doesn't revert
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.deposit(depositAmount, address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.DEPOSIT, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.deposit(depositAmount, address(this));
    }

    function test_depositSucceedsAsNotSet() public {
        vault.deposit(depositAmount, address(this));

        assertEq(vault.totalSupply(), depositAmount);
        assertEq(vault.totalAssets(), depositAmount);
    }

    function test_previewMintRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.previewMint(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.previewMint(depositAmount);

// TODO: Doesn't revert
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.mint(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.previewMint(depositAmount);
    }

    function test_previewMintSucceedsAsNotSet() public view {
        vault.previewMint(depositAmount);
    }

    function test_mintRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.mint(depositAmount, address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.mint(depositAmount, address(this));

//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.mint(depositAmount, address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.MINT, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.mint(depositAmount, address(this));
    }

    function test_mintSucceedsAsNotSet() public {
        vault.mint(depositAmount, address(this));

        assertEq(vault.totalSupply(), depositAmount);
        assertEq(vault.totalAssets(), depositAmount);
    }
}

abstract contract WithSupply is InitialState {

    function setUp() public virtual override {
        super.setUp();
        vault.mint(depositAmount, address(this));
    }
}

contract WithSupplyTest is WithSupply {

    function test_previewWithdrawRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.previewWithdraw(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.previewWithdraw(depositAmount);

// TODO: Doesn't revert
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.withdraw(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.previewWithdraw(depositAmount);
    }

    function test_previewWithdrawSucceedsAsNotSet() public view {
        vault.previewWithdraw(depositAmount);
    }

    function test_withdrawRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.withdraw(depositAmount, address(this), address(this));
        
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.withdraw(depositAmount, address(this), address(this));
    
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.withdraw(depositAmount, address(this), address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.WITHDRAW, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.withdraw(depositAmount, address(this), address(this));
    }

    function test_withdrawSucceedsAsNotSet() public {
        vault.withdraw(depositAmount, address(this), address(this));

        assertEq(vault.totalSupply(), 0);
        assertEq(vault.totalAssets(), 0);
    }

    function test_previewRedeemRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.previewRedeem(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.previewRedeem(depositAmount);

// TODO: Doesn't revert
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.redeem(depositAmount);

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.previewRedeem(depositAmount);
    }

    function test_previewRedeemSucceedsAsNotSet() public view {
        vault.previewRedeem(depositAmount);
    }

    function test_redeemRevertsAsSet() public {
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.THROW);
        vm.expectRevert();
        vault.redeem(depositAmount, address(this), address(this));
        
        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.OOG);
        vm.expectRevert();
        vault.redeem(depositAmount, address(this), address(this));
    
//        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.RETURN_BOMB);
//        vm.expectRevert();
//        vault.redeem(depositAmount, address(this), address(this));

        vault.setRevertBehaviour(MockERC4626Tester.FunctionType.REDEEM, MockERC4626Tester.RevertType.REVERT_BOMB);
        vm.expectRevert();
        vault.redeem(depositAmount, address(this), address(this));
    }

    function test_redeemSucceedsAsNotSet() public {
        vault.redeem(depositAmount, address(this), address(this));

        assertEq(vault.totalSupply(), 0);
        assertEq(vault.totalAssets(), 0);
    }

    function test_increaseYield() public {
        uint256 ratioBefore = vault.convertToAssets(assetUnit);
        vault.increaseYield(100); // 1%
        uint256 ratioAfter = vault.convertToAssets(assetUnit);

        assertApproxEqRel(ratioAfter, ratioBefore * 101 / 100, 1); // Allow rounding errors in the ratio
    }

    function test_decreaseYield() public {
        uint256 ratioBefore = vault.convertToAssets(assetUnit);
        vault.decreaseYield(100); // 1%
        uint256 ratioAfter = vault.convertToAssets(assetUnit);

        assertApproxEqRel(ratioAfter, ratioBefore * 99 / 100, 1); // Allow rounding errors in the ratio
    }
}

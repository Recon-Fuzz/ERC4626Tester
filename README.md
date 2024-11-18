# ERC4626 Testing Utilities

## Introduction

This repository contains testing utilities for ERC4626 vaults, including mocks that can simulate various failure modes and yield scenarios.

## Overview

The main components are:

- `MockERC4626Tester`: A mock ERC4626 vault that can:
  - Simulate different types of reverts (normal revert, out-of-gas, return bomb, etc.)
  - Manipulate yield by increasing/decreasing the asset/share ratio
  - Mint unbacked shares
  - Configure decimals offset

- `MockERC20Tester`: A mock ERC20 token for testing the vault with.

## Usage

To use these utilities in your project, you use Foundry to install them as dependencies:

```bash
forge install
```
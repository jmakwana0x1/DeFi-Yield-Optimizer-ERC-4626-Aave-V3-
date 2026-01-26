# DeFi Yield Optimizer (ERC-4626 + Aave V3)

## Overview

This project is a non-custodial DeFi yield optimizer that abstracts interaction with lending protocols into a simple, transparent ERC-4626 vault. Users deposit a stable asset and receive vault shares while the protocol manages capital deployment to generate yield.

The primary goal of this project is **not** to invent yield, but to demonstrate how yield-generating protocols like Aave can be wrapped into a production-grade vault that improves usability, gas efficiency, and decision-making.

---

## Problem Statement

Lending protocols such as Aave expose raw financial primitives: supply, withdraw, utilization rates, and variable interest. While powerful, they require users to:

* Continuously monitor APY changes
* Manually manage deposits and withdrawals
* Pay gas costs individually
* Understand protocol-level mechanics

Most users are unable or unwilling to actively manage these decisions, resulting in suboptimal returns or poor user experience.

---

## Solution

This project introduces a **tokenized vault (ERC-4626)** that:

* Pools user capital
* Deploys funds into Aave V3
* Tracks yield through share price appreciation
* Enables rule-based rebalancing between idle and deployed states

By pooling funds and abstracting strategy logic, the vault provides a cleaner interface for users while remaining fully non-custodial.

---

## Key Properties

* **Non-custodial:** Users retain economic ownership via ERC-4626 shares
* **Composable:** ERC-4626 compliance allows integration with other DeFi protocols
* **Gas-efficient:** Capital is managed at the vault level rather than per-user
* **Transparent:** All allocation and rebalance actions are on-chain and auditable

---

## What This Project Explicitly Does NOT Do

* No leverage
* No governance token
* No multi-strategy routing
* No cross-chain deployment
* No admin withdrawal powers

This scope is intentional to maintain security, clarity, and auditability.

---

## Architecture

### High-Level Components

1. **User**

   * Deposits and withdraws assets
   * Holds ERC-4626 vault shares

2. **Vault (ERC-4626)**

   * Accepts deposits of the underlying asset
   * Mints and burns vault shares
   * Tracks total assets and share price
   * Coordinates capital deployment

3. **Strategy (Aave V3)**

   * Receives capital from the vault
   * Supplies assets to Aave
   * Withdraws assets back to the vault
   * Reports total deployed value

4. **Aave V3 Pool**

   * Generates yield via borrower interest
   * Issues aTokens that accrue value

---

### Asset Flow

User deposit flow:

```
User
  ↓ deposit
Vault (ERC-4626)
  ↓ deploy
Aave Strategy
  ↓ supply
Aave Pool
```

Yield accumulation:

* Borrowers pay interest
* aToken balance increases
* Strategy reports higher totalAssets
* Vault share price appreciates

Withdrawal flow:

```
User
  ↑ redeem
Vault
  ↑ withdraw
Strategy
  ↑ redeem
Aave Pool
```

---

### Rebalancing Model (Initial Scope)

The vault supports rebalancing between:

* **Idle assets** (held in vault)
* **Deployed assets** (supplied to Aave)

Rebalancing is triggered when predefined conditions are met, such as:

* Deployment threshold reached
* Safety pause activated
* Strategy update required

This design enables future extension to multi-strategy routing without changing the vault interface.

---

## Trust & Security Assumptions

* Vault contracts are immutable after deployment
* Strategy contracts can only be called by the vault
* No privileged role can extract user funds
* Parameter changes are protected by timelocks

Users are exposed to:

* Smart contract risk
* Underlying Aave protocol risk
* Market-driven interest rate changes

---

## Technology Stack

* Solidity ^0.8.x
* OpenZeppelin Contracts
* Foundry (testing & deployment)
* Next.js + wagmi (frontend)
* Polygon Amoy Testnet

---

## Project Goal

This repository serves as a **portfolio-grade demonstration** of real-world DeFi engineering, showcasing:

* ERC-4626 vault design
* Safe protocol integration
* Yield abstraction
* Full-stack Web3 development

---

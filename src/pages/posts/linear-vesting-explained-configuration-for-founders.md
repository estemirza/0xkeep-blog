---
layout: ../../layouts/PostLayout.astro
title: "Linear Vesting Explained: A Configuration Guide for Founders"
date: 2026-03-02
tags:
  - Guides
  - Research
description: A technical breakdown of linear vesting mechanics, cliff periods, and how to configure immutable token distribution schedules using the 0xKeep protocol.
image: https://image2url.com/r2/default/images/1772352408852-2e590f95-2f9b-42bf-9888-d84ff8cf58ba.jpg
---
Token distribution is the structural foundation of a decentralized project's economy. For founders, the challenge lies not only in allocation but in the **mathematical enforcement** of those allocations.

Manual distribution of team or advisor tokens introduces human error and requires trust. In a trustless environment, this is an architectural flaw. The solution is programmable, immutable vesting.

This guide details the mechanics of Linear Vesting and Cliffs within the 0xKeep V11 architecture and how to configure them for precise token streaming on Base, Arbitrum, and Optimism.

---

### The Mechanics of Linear Streaming

Unlike traditional finance, which often relies on monthly "cliffs" or manual transfers, the 0xKeep protocol utilizes Ethereum block timestamps to calculate vesting with second-by-second granularity.

The underlying logic is deterministic. Upon initialization of a vesting schedule, the contract calculates claimable tokens based on the following invariant:

```solidity
Claimable = (TotalAmount * TimeElapsed) / Duration
```

This effectively streams tokens to the recipient. A beneficiary can claim their unlocked balance at any frequency—daily, weekly, or at the very end of the duration. The unclimbed balance remains cryptographically secured within the 0xKeep vault.

---

### The Cliff Period: Delayed Liquidity

A "Cliff" is a temporal parameter that delays the start of the linear stream. During the cliff period, the claimable amount remains zero. Once the cliff timestamp is surpassed, the vesting schedule activates.

**Configuration Example:**
*   **Total Allocation:** 1,000,000 Tokens
*   **Cliff Period:** 180 Days
*   **Vesting Duration:** 365 Days

**Result:**
For the first 6 months, 0 tokens are accessible. On Day 181, the cliff breaks, and tokens begin unlocking linearly over the remaining 365 days. This mechanism aligns long-term incentives, ensuring team members or seed investors remain committed to the protocol's roadmap before liquidity is realized.

---

### Configuring a Schedule on 0xKeep

The 0xKeep interface allows for the rapid deployment of these schedules without interaction with complex code. The process is a two-step transaction designed to prevent stuck funds.

#### 1. Authorization
The protocol requires approval to interact with the specific amount of ERC-20 tokens you intend to vest. This utilizes standard `approve()` logic.

#### 2. Initialization
You define the parameters:
*   **Recipient Address:** The wallet that will claim the tokens.
*   **Vesting Duration:** The active streaming period.
*   **Cliff Period (Optional):** The initial lock period.

The cost for this infrastructure is a flat fee of **0.02 ETH**. Unlike other providers, 0xKeep does not charge a percentage of your token supply. For a project vesting $100,000 worth of assets, this flat fee model preserves significant capital compared to a 1% tax model.

---

### Operational Security and Ownership Transfer

Project structures evolve. A vesting schedule created by a solo developer's wallet today may need to be managed by a DAO Multisig tomorrow.

The 0xKeep contract includes a **Transfer Ownership** function for vesting schedules. This allows the current owner (the entity capable of reclaiming unvested tokens if revocable logic was custom-coded, or simply the administrator of the lock) to hand over control to a new address.

**Note:** Once ownership is transferred, the action is irreversible. The original wallet loses all administrative rights over the schedule.

---

### Verification and Proof

Upon deployment, the protocol generates a Vesting Certificate. This is a permalink containing the on-chain data of the schedule.

For founders, this certificate serves as the "Proof of Vesting." It can be embedded directly into your project’s documentation or landing page using our iframe widget, providing investors with real-time, verifiable proof that team tokens are secured by immutable code.

---

### Summary

Linear vesting is not merely a payment method; it is a trust signal. By utilizing 0xKeep, founders replace promises with cryptographic certainty.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
---
layout: ../../layouts/PostLayout.astro
title: "The Custody Problem in Yield Vaults: What a $71.6K Pendle Drain Reveals About Architectural Risk"
date: 2026-02-06
tags:
  - News
  - Security
  - Research
description: An unvalidated calldata exploit drained a Pendle-based staking vault for $71.6K. The root cause wasn't just missing input validation — it was a custody model that made the contract a viable target in the first place.
image: https://image2url.com/r2/default/images/1772352109948-92690665-94be-4439-86a5-586d0f9b1de7.jpg
---
## What a $71.6K Pendle Drain Reveals About Architectural Risk

An unidentified Pendle-based staking vault was fully drained last week for **$71.6K** via a single exploit primitive: unvalidated user-controlled calldata forwarded to the Pendle router.

The vulnerability class is straightforward. The architectural condition that made it catastrophic is not.

---

## What Happened

The vault contract acted as an intermediary between users and the Pendle router — a common pattern in yield aggregation. Users deposit LP tokens; the vault handles routing, compounding, and position management on their behalf.

The attack surface opened in the vault's execution path. When a user interaction triggered a router call, the contract forwarded calldata that had not been validated against expected function selectors, address parameters, or asset boundaries. The attacker supplied crafted calldata pointing the router call at an attacker-controlled address, redirecting asset flow out of the protocol entirely.

The drain was total. Every LP token held in custody by the vault was extracted in a single transaction sequence. No partial loss. No residual balance. The contract was emptied.

---

## The Input Validation Failure

The proximate cause is a known vulnerability pattern. Forwarding user-controlled calldata to an external contract without validation is functionally equivalent to giving the caller arbitrary execution permissions on anything the contract holds approval over.

The standard remediation is equally well-documented: validate function selectors against an allowlist, enforce asset address constraints, and never forward raw calldata to privileged external contracts. This is not novel defensive engineering. It appears in every serious Solidity security reference published in the last four years.

What makes this incident worth examining beyond the input validation failure is the condition the attacker required before the exploit was viable at all: **the vault had to be holding something worth taking.**

---

## The Custody Condition

The vault contract held custody of all deposited LP tokens. This is architecturally standard for yield vaults — the contract must control the assets to compound them, rebalance them, and manage positions on behalf of depositors. Custody is not incidental to the design. It is the design.

And that custody model creates a structural property that precedes any code-level vulnerability: **the contract is a target.** Not speculatively — verifiably. Any observer can query the contract's balance, identify its token approvals, and assess its external call surface before writing a single line of exploit code. The attack opportunity is advertised on-chain continuously, for as long as the vault operates.

Input validation fixes the proximate vulnerability. It does not change this underlying condition. A vault that holds custody of $71.6K in LP tokens — then patches its calldata validation — still holds custody of $71.6K in LP tokens. The next exploit attempt requires finding a different code path, not a different protocol.

This is the custody problem. It is not a criticism of yield vaults as a category. It is a precise description of the risk surface that custody-based architectures carry by definition, and the reason that the severity of a code-level vulnerability inside a custody contract is always proportional to the assets under management.

---

## A Different Architectural Model

0xKeep's contract architecture was designed around a specific inversion of this model.

The protocol holds zero ETH. Not approximately zero — zero by design. When a user locks liquidity or initiates a vesting schedule, the flat fee (0.03 ETH for a lock, 0.02 ETH for vesting) passes through the contract and routes directly to the fee destination. The contract does not accumulate. It does not hold a treasury. It processes the transaction and the fee exits in the same block.

The LP tokens themselves are held in the user's lock record — associated with the depositing address and the specified unlock parameters — not in a shared pool under contract-controlled custody. The contract enforces the time constraint. It does not manage, compound, or rebalance the assets. It cannot forward them to an external router. There is no execution path that results in asset redirection, because there is no execution path that involves forwarding assets anywhere.

This architecture was not designed as a security feature in isolation. It was designed because the protocol's function — enforcing a time-based custody constraint — does not require the contract to do anything with the locked assets except prevent early withdrawal. Accumulating ETH or managing a shared asset pool would introduce complexity and surface area that the protocol's purpose does not justify.

The security property is a consequence of that constraint. A contract that holds zero ETH and processes no external router calls has no treasury to drain and no calldata to craft. The attack surface that the Pendle vault exploit required simply does not exist.

---

## The Immutability Variable

The incident report notes that the vault contract carried no immutability guarantees. The implication is that the contract was upgradeable — meaning that even a post-exploit patch introduces a new risk surface: the upgrade mechanism itself.

An upgradeable contract with an admin key is a contract with a privileged actor. That actor can deploy a new implementation. In the best case, that implementation fixes the vulnerability. In every case, the upgrade mechanism represents a capability that exists permanently, regardless of whether the current admin intends to use it.

0xKeep contracts are immutable. Not upgradeable-with-timelock, not upgradeable-with-multisig — immutable. Once deployed, the code does not change. The security properties observable at deployment are the security properties that will exist for the life of the protocol. There is no admin key that can alter them. There is no upgrade path that can introduce new surface area.

This is the "Write Once, Run Forever" constraint applied not as a positioning statement but as a verifiable architectural property. The tradeoff is explicit: immutability means bugs cannot be patched without migration. The protocol accepts that tradeoff because it narrows the attack surface to the code as-written — auditable, deterministic, and permanently bounded.

---

## What This Week's Incident Illustrates

The $71.6K Pendle vault drain is not primarily a story about calldata validation. It is a story about the compounding interaction between custody architecture and code-level vulnerability.

The input validation bug was necessary for the exploit. It was not sufficient. The contract also had to hold custody of assets that justified the attack. It had to have an execution path that could be redirected to external addresses. It had to be, in some operational sense, a treasury.

Removing any one of those conditions would have changed the outcome. The attacker could have found the same calldata vulnerability in a contract that held nothing, and the transaction would have reverted with nothing to show for it. The bug would still exist. The loss would not.

This is the case for designing custody out of protocol architecture wherever the protocol's function permits it. Not every protocol can make that choice — yield vaults, by definition, require asset management. But for protocols whose function is to enforce a constraint rather than manage an asset, the custody model is a design decision, not an inevitability.

For liquidity locking, that decision has been made. The contract enforces time. It does not hold treasury. The math on what an attacker can extract from a contract with a zero balance is exact.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
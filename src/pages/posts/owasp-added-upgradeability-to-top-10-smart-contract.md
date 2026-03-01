---
layout: ../../layouts/PostLayout.astro
title: OWASP Just Added Upgradeability to the Smart Contract Top 10. We Solved It at Deployment.
date: 2026-03-02
tags:
  - News
  - Security
  - Research
description: "OWASP's Smart Contract Top 10: 2026 formally classifies Proxy & Upgradeability Vulnerabilities as a critical risk category. 0xKeep's immutable architecture eliminates this attack surface entirely — not at audit time, but at deployment."
image: https://image2url.com/r2/default/images/1772352090906-84694f6a-34f5-4bba-a773-b711250409e8.jpg
---
OWASP has published the **Smart Contract Top 10: 2026** — a forward-looking standard awareness document designed to arm Web3 developers, security auditors, and protocol owners with intelligence on the most critical vulnerability classes in smart contracts today.

The most consequential addition to this year's list: **SC10 — Proxy & Upgradeability Vulnerabilities.**

This is not a niche edge case. It is an acknowledgment, from the industry's most authoritative security body, that insecure upgrade patterns have become a systemic, recurring threat across the entire ecosystem. We want to explain what that means — and why 0xKeep's architecture was designed to make SC10 irrelevant by construction.

---

## What SC10 Actually Means

Proxy patterns and upgradeability mechanisms were introduced to solve a real problem: deployed smart contracts are immutable, so what do you do when you find a bug? The proxy pattern delegates logic to a separate implementation contract, allowing the "logic" to be swapped while the "address" and "state" remain constant.

On paper, elegant. In practice, it introduces a new class of trust assumptions that have proven catastrophically exploitable.

SC10 covers the failure modes that emerge from this pattern:

**Exposed admin roles.** Upgrade functions require a privileged address to authorize them. That address is a target. If it is a single EOA (Externally Owned Account), it is one compromised private key away from a total protocol rewrite. If it is a multisig, it is one social engineering campaign away from the same outcome.

**Implementation pointer manipulation.** In UUPS and Transparent Proxy patterns, the contract stores a pointer to the current logic address. If the access controls on the function that updates this pointer are misconfigured — even subtly — an attacker can redirect execution to arbitrary code. Entire protocol treasuries have been drained through exactly this vector.

**Insufficient privilege separation.** Many protocols conflate the "admin" role that controls contract logic with the "admin" role that controls protocol fees, pausing, or other operational parameters. A single compromised key then becomes a master override across the entire system.

**Storage collision vulnerabilities.** Proxy patterns require careful management of storage slots across implementation upgrades. A misaligned upgrade can corrupt state in ways that are not immediately visible but are permanently destructive.

Multiple protocol compromises in 2025 stemmed not from cryptographic failures or novel zero-day exploits — but from these exact patterns: exposed upgrade keys, misconfigured access control, and insufficient governance over the upgrade process itself.

OWASP formalizing SC10 is not a prediction. It is a post-mortem.

---

## Audits Flag Risks. Architecture Removes Them.

The standard response to SC10-class vulnerabilities is improved audit rigor: access control reviews, upgrade governance frameworks, timelocks, DAO voting on implementation changes.

These are meaningful mitigations. They are not solutions.

An audit is a snapshot in time. It assesses the code as it exists at the moment of review. If the upgrade key is later compromised, if a governance vote is manipulated, if a new implementation introduces a storage collision — the audit cannot protect against what happens after it was conducted.

The only architectural answer to SC10 is to eliminate the upgrade surface entirely.

That is the decision we made when designing the 0xKeep V11 Enterprise Contract.

---

## 0xKeep's Architecture and SC10

The 0xKeep protocol contains no proxy pattern. There is no implementation pointer. There is no admin function capable of altering contract state after deployment. There is no upgrade key to compromise because there is no upgrade mechanism to invoke.

This is not a feature we added. It is the absence of a class of features — and that absence is the point.

**No proxy pattern.** The 0xKeep contract is a direct deployment. The bytecode at the contract address is the bytecode that executes — permanently. There is no `delegatecall` redirection, no implementation slot, no storage layout managed across versions.

**No admin keys.** The contract holds no privileged role capable of modifying its logic or pausing its operation. We cannot stop the protocol. No one can. The immutability is not a policy; it is a property of the deployed bytecode.

**No upgradeability.** "Write Once, Run Forever" is not a marketing position. It is a description of the contract's runtime behavior. The functions that exist at deployment are the functions that will exist in perpetuity. SC10's attack surface does not apply because the conditions SC10 requires — an upgrade mechanism, an authorized caller, a modifiable implementation — do not exist in the contract.

**Zero custody.** The contract holds no ETH treasury. Revenue from lock and vest fees routes directly to recipient addresses upon execution. There is no accumulated balance to drain, no admin withdrawal function, no treasury that represents a target.

When OWASP auditors define SC10 and enumerate the conditions that make a protocol vulnerable, they are describing a category of design choices. 0xKeep did not make those design choices.

---

## The Trade-Off Is Real. We Made It Deliberately.

Immutability is not without cost. If a critical bug were discovered in the 0xKeep contract — a genuinely novel exploit against our specific implementation — we could not patch it. There is no upgrade path. There is no emergency pause. The code runs until the chain it is deployed on ceases to exist.

This is a deliberate trade-off, not an oversight.

The alternative — a contract with an upgrade mechanism — introduces a persistent trust assumption: that whoever holds the upgrade key will use it correctly, will not be compromised, and will not act adversarially. That assumption has been violated repeatedly, across protocols with strong reputations, well-funded teams, and rigorous audits.

We concluded that the risk of a novel exploit against verified, static code is lower than the persistent, compounding risk of a live upgrade key in an adversarial environment. SC10 entering the OWASP Top 10 suggests the industry is reaching the same conclusion.

---

## What This Means for Protocol Developers

If you are a developer evaluating infrastructure providers — locking liquidity, managing team vesting, or structuring a treasury — SC10 should be part of your due diligence framework.

Ask the provider: does your contract use a proxy pattern? Who holds the upgrade key? What governance controls exist over implementation changes? What is the timelock on an upgrade transaction?

Then ask yourself whether the answers to those questions represent risks you are comfortable accepting — not just for your protocol, but for the investors and community members whose assets will be held in those contracts.

The 0xKeep architecture answers those questions at the bytecode level. The contract is what it is. It cannot be made into something else.

---

## Technical Addendum

For security researchers and developers who want to verify these claims directly:

The 0xKeep contract does not implement `EIP-1967` storage slots. It does not contain a `upgradeTo()` or `upgradeToAndCall()` function selector. It does not inherit from `OpenZeppelin/proxy/`, `UUPS`, `TransparentUpgradeableProxy`, or any equivalent base contract. Storage layout is fixed at deployment. There are no `onlyOwner` or `onlyAdmin` modifiers on state-modifying functions beyond the user-scoped access controls governing individual lock and vest positions.

The deployed contract bytecode can be verified on-chain across Base, Arbitrum, and Optimism. The source code is available for independent review.

SC10 describes a risk class. We encourage you to verify, independently, that 0xKeep does not instantiate it.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
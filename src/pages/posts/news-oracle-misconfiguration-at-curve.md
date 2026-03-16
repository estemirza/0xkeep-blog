---
layout: ../../layouts/PostLayout.astro
title: "Oracle Misconfiguration at Curve: Why Pool Creators Are the New Attack Surface"
date: 2026-03-16
tags:
  - News
  - Security
  - Cases
description: The Curve LlamaLend sDOLA exploit wasn't a bug in the core protocol. It was a configuration error made at deployment. When a protocol lets anyone configure oracle parameters at pool creation, the attack surface is every pool creator who ever gets it wrong.
image: https://image2url.com/r2/default/images/1772352218024-53ce964c-4cd4-4ffa-a1fa-96af0ab6ff80.jpg
---
On March 2, 2026, the sDOLA lending market on Curve Finance's LlamaLend platform was exploited for approximately $240,000. Borrowers who had supplied sDOLA as collateral were liquidated. Lenders were unaffected. The DOLA stablecoin and Inverse Finance's underlying contracts were not compromised.

Curve's own post-incident summary was precise: "The sDOLA lending market was unfortunately exploited with a misconfigured oracle leading to a donations attack."

Not a code bug. Not a zero-day in the core protocol. A misconfigured oracle, set at the time the pool was created.

---

## What the Attack Did

sDOLA is a yield-bearing vault token issued by Inverse Finance. Its exchange rate against DOLA — the stablecoin it wraps — increases over time as yield accrues. At the time of the exploit, 1 sDOLA was worth approximately 1.188 DOLA.

The exploit used a flash loan to borrow funds, redeem sDOLA, and re-stake that amount as a donation back into the pool. This artificially inflated the reported sDOLA/DOLA exchange rate — moving it from approximately 1.188 to 1.358 in a single transaction. The oracle used for the sDOLA market was susceptible to exactly this kind of external balance manipulation.

The sudden rate shift cascaded through the liquidation logic in a counterintuitive direction: rather than improving borrowers' health factors as a collateral value increase normally would, the abrupt oracle movement triggered liquidations across leveraged positions. The attacker captured the liquidation proceeds. Total borrower losses: roughly $240,000.

sDOLA holders who were not leveraging their positions actually saw gains of roughly 14% due to the exchange rate shift — the same event that drained leveraged borrowers distributed value to unleveraged holders. This asymmetry is a precise illustration of how oracle manipulation attacks don't destroy value so much as redirect it, from borrowers to the attacker and incidentally to passive holders.

---

## The Actual Failure Mode

Early findings indicate that the attack stemmed from a combination of factors: specifically the price oracle configuration used for sDOLA and the amount of sDOLA circulating outside collateralized positions in the affected market.

The key word is "configuration." The Curve core contracts functioned as designed. The LLAMMA liquidation engine executed correctly given the price data it received. The oracle itself reported what it observed. The failure was in how the oracle was configured for this specific market — whether the chosen pricing mechanism was appropriate for an asset whose exchange rate can be influenced by external donations to the underlying vault.

One promising mitigation comes from an oracle framework originally designed for two-way LlamaLend markets, which had not yet been deployed. That framework existed. It was not used for this pool. The decision about which oracle to use was made at pool creation, and the wrong choice was made.

This is a distinct and increasingly important category of DeFi vulnerability: not a flaw in the protocol's code, but a flaw in the configuration space that the protocol's permissionless design exposes. LlamaLend allows anyone to create a lending market with their chosen oracle. That flexibility is also a persistent opportunity for misconfiguration, at every pool launch, by every pool creator, indefinitely.

---

## The Configuration Attack Surface

Permissionless pool creation is one of DeFi's most powerful design properties. It enables composability, experimentation, and market access without gatekeeping. It also means that the security of every pool is bounded by the competence and diligence of whoever configured it.

This is not a new observation. The pattern has recurred across the ecosystem: Moonwell's MIP-X43 governance proposal deployed a Chainlink wrapper with a missing price feed multiplication, leaving cbETH misreported at $1.12 and triggering $1.78 million in liquidations. Curve's sDOLA market used an oracle susceptible to donation manipulation in a market structure that created the conditions for that manipulation to be profitable.

Both incidents involved protocols with substantial security investment, active auditor relationships, and technically sophisticated teams. Both incidents involved a configuration decision at deployment — not a vulnerability in the protocol's core logic.

The incident serves as another case study in the evolving security landscape of DeFi. Rather than a traditional exploit targeting smart contract code, it illustrates how economic design and oracle dependencies can create vulnerabilities even when underlying systems function as intended.

The configuration layer is the new attack surface. Every parameter exposed at pool creation is a parameter that can be set incorrectly. Every oracle choice is a potential mismatch between the asset's pricing characteristics and the market's liquidation assumptions. Every deployment is an opportunity to introduce a flaw that the core protocol's audits cannot anticipate, because the flaw is not in the protocol — it is in how a specific deployer used it.

---

## What Write-Once Architecture Eliminates

The 0xKeep contract has no oracle. It does not reference external price feeds, exchange rates, or vault token valuations. Lock durations and vesting schedules are deterministic functions of the parameters set at the time of the user's transaction — a timestamp and an amount. There is no pricing mechanism to misconfigure, no donation attack that can distort a collateral valuation, no liquidation logic that can be triggered by a manipulated rate.

This is a consequence of deliberate scope reduction. The 0xKeep contract does one thing: hold tokens and release them at a specified time or according to a specified vesting schedule. That narrow scope means the configuration space exposed at deployment is minimal. There is no oracle choice to get wrong. There is no parameter set by a pool creator that can retroactively determine whether a user's position is secure.

More fundamentally: the contract's behavior is fully determined at deployment and cannot be modified afterward. There are no pool creation parameters, no governance proposals that update market configuration, no admin function that can adjust oracle logic for a specific market. What a user sees when they lock a position is the complete specification of what will happen to that position — no external data source required, no subsequent configuration change possible.

Curve's team is studying how to integrate these safeguards into future deployments, including the upcoming LlamaLend V2. The upgrade path is, characteristically, another deployment — another configuration decision, another oracle choice, another opportunity to get it right or wrong. The migration from a vulnerable pool design to a more robust one requires redeployment, user migration, and another round of validation against a new configuration space.

That cycle does not end. Every new market is a new configuration. Every new asset type introduces new oracle considerations. Every new deployment is a new opportunity for a mismatch between an asset's economic properties and the market structure built around it.

---

## The Pattern Completing

This is the third oracle-related incident covered in this series in as many weeks. Moonwell lost $1.78 million to a governance-executed oracle misconfiguration on February 15. Solv Protocol lost $2.7 million to a reentrancy condition introduced through a new vault deployment on March 6. Curve's sDOLA market lost $240,000 to a donation attack enabled by an oracle configuration choice made at pool creation on March 2.

Three incidents. Three different mechanisms. One consistent underlying condition: a contract whose behavior was determined not only at initial deployment, but at subsequent configuration events — governance proposals, new vault launches, new pool creation parameters — that introduced attack surface the original protocol audit could not have assessed.

The emerging picture of DeFi security in 2026 is not primarily about novel cryptographic attacks or zero-day exploits in battle-tested core contracts. It is about the gap between what was audited and what was deployed, between what the core protocol can do and what a specific pool creator configured it to do, between the security properties of the protocol at launch and its security properties after the tenth governance proposal or the fifteenth new market.

Write-once is not a limitation on what a protocol can offer. It is the closure of that gap — permanently, at deployment, without a subsequent configuration event that can reopen it.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
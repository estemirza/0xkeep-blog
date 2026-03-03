---
layout: ../../layouts/PostLayout.astro
title: "The February 2026 Incident Report: What $23.63M in Losses Has in Common"
date: 2026-03-03
tags:
  - News
  - Security
  - Cases
description: February 2026 saw $23.63 million lost across 12 incidents. Oracle manipulation, access control failures, bridge exploits, and a confirmed rug pull. A breakdown of what the data reveals — and what it demands from protocol design.
image: https://image2url.com/r2/default/images/1772352090906-84694f6a-34f5-4bba-a773-b711250409e8.jpg
---
February 2026 closed with $23.63 million lost across 12 reported security incidents. The categories are familiar: oracle manipulation, access control failures, bridge exploits, and at least one confirmed rug pull. The names change each month. The vulnerability classes do not.

This piece examines what February's incident data reveals about the structural failure modes recurring across the ecosystem — and what protocol architecture can do to eliminate them.

---

## The Numbers

**Total losses:** $23.63M  
**Reported incidents:** 12  
**Primary categories:** Oracle manipulation, access control failures, bridge exploits, insider withdrawal

The aggregate figure is notable not for its size — monthly losses have exceeded nine figures in prior cycles — but for its composition. Technically driven exploits continue to dominate the total. Oracle manipulation and access control failures account for a disproportionate share of capital lost, while rug pulls, though directionally damaging to user confidence, represent a comparatively contained financial impact in this month's data.

That distribution matters. It tells us something about where the industry's unsolved problems actually live.

---

## Oracle Manipulation: Persistent and Preventable

Oracle manipulation remains one of the most consistently exploited vectors in DeFi. The mechanism is well-documented: an attacker manipulates the price feed a protocol relies on for valuation — typically through flash loans or thin liquidity on the reference market — and uses the resulting distorted price to extract value against the protocol's logic.

The exploits recur because the fix is non-trivial. Time-weighted average prices, multi-source aggregation, and circuit breakers all reduce exposure but introduce their own complexity and latency trade-offs. No single mitigation has proven definitive across all protocol designs.

What February's data reinforces is that oracle dependence is a persistent attack surface for any protocol whose security model requires accurate external price data. Protocols that eliminate this dependency by design — those whose logic does not rely on real-time price feeds — remove the vector entirely.

---

## Access Control Failures: The Recurring Theme

Access control failures are the most structurally significant category in this month's report, and in most months that precede it.

The pattern is consistent: a privileged function exists — an admin role, an owner address, a multisig with upgrade authority — and either the access control logic is misconfigured, or the key controlling that function is compromised. In either case, the outcome is the same: an attacker or insider executes a function they should not be able to execute, and capital moves in a direction users did not authorize.

This is not a novel attack class. It is not a zero-day. It is the same architectural decision — "we need a privileged function to manage this protocol" — producing the same outcome it has produced across dozens of incidents in preceding months.

OWASP's recent inclusion of Proxy & Upgradeability Vulnerabilities as SC10 in the Smart Contract Top 10: 2026 formalizes what incident reports have been demonstrating empirically: admin key exposure and privileged function abuse are not edge cases. They are a predictable consequence of designs that require privilege to operate.

Every access control failure in February's report represents a function that existed, was reachable, and was exploitable. The mitigation is not better key management alone — it is the deliberate elimination of privileged functions from the contract's interface.

---

## The Ploutos Incident: Access Control as a Feature, Not a Bug

On February 26, Ploutos Money was confirmed as a rug pull on Ethereum. Project insiders allegedly withdrew liquidity intentionally, leaving users unable to recover their assets.

The Ploutos incident is not technically complex. It does not require a novel exploit or a misconfigured access control check. It requires exactly what was built: a liquidity position that the project team retained the ability to withdraw. The "vulnerability" was the design. The admin function worked exactly as implemented.

This is the category of risk that liquidity locking infrastructure exists to address. When a project locks its LP tokens in a contract with zero admin access — no withdrawal function, no owner override, no emergency pause — the Ploutos scenario becomes impossible by construction. The liquidity cannot be withdrawn because no function exists to withdraw it. There is no key to compromise, no insider who can execute the exit, no governance vote that can authorize the drain.

The Ploutos rug pull is not an argument for better audits of rug pulls. It is an argument for removing the mechanism that makes rug pulls executable in the first place.

---

## What the Data Demands from Protocol Architecture

Read across the twelve incidents in February's report, a pattern emerges that no amount of audit rigor fully resolves: the losses trace back to functions that existed and were reachable. Oracle interfaces that could be manipulated. Admin roles that could be compromised. Withdrawal functions that could be invoked by insiders.

Audits assess whether access controls are correctly implemented. They cannot assess whether the access control, correctly implemented, should exist at all.

The architectural question February's data puts directly is this: which privileged functions in your protocol's design are actually necessary — and which exist because upgradeability, admin override, and emergency mechanisms were added as defaults rather than as deliberate, justified design choices?

Every privileged function is a surface. Every surface is a potential incident entry point. The minimum-surface architecture is not one with well-secured admin keys. It is one where the admin function was never written.

---

## 0xKeep's Threat Surface, Defined by Absence

The 0xKeep V11 contract is deployed across Base, Arbitrum, and Optimism. Its architecture is defined as much by what it does not contain as by what it does.

No admin withdrawal function. No owner override. No pause mechanism. No upgrade path. No proxy pattern. No implementation pointer. No privileged role capable of modifying locked positions after they are created.

The access control failure category in February's incident report describes exploits against functions that exist in target contracts. Those functions do not exist in 0xKeep's contract. The insider withdrawal vector that defined the Ploutos incident requires a withdrawal function reachable by insiders. 0xKeep's contract contains no such function.

This is not a security claim that requires trust. It is a property of the deployed bytecode, verifiable on-chain. The contract is what it is. It cannot be made into something else.

Flat fee. Write once. Run forever.

---

## Closing Note

Twelve incidents. $23.63 million. The categories in February's report will appear again in March's. Oracle manipulation, access control failures, and insider withdrawals are not anomalies in the current ecosystem — they are predictable outputs of design patterns that remain prevalent.

The data does not argue for better reactions to these incidents. It argues for protocol architectures that make the incidents structurally impossible.

---

*Source: February 2026 Crypto Security Report — Cryip.co (March 3, 2026).*

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
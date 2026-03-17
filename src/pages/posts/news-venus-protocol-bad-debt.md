---
layout: ../../layouts/PostLayout.astro
title: "Venus Protocol's $2.15M Bad Debt: When You Dismiss the Audit Finding, the Attacker Reads It Too"
date: 2026-03-18
tags:
  - News
  - Security
  - Cases
description: On March 15, Venus Protocol was left with $2.15M in bad debt after a nine-month oracle manipulation campaign against the THE token. The donation attack vector had been flagged in Venus's own security audit. The team disputed the finding. The attacker did not.
image: https://image2url.com/r2/default/images/1772352090906-84694f6a-34f5-4bba-a773-b711250409e8.jpg
---
On March 15, 2026, Venus Protocol — the largest lending platform on BNB Chain — was left with approximately $2.15 million in bad debt after a price manipulation attack targeting the Thena protocol's THE token.

The mechanics of the exploit were not novel. The attack vector had been documented in DeFi security research literature since at least 2022. It had been flagged specifically in Venus's own Code4rena security audit. The development team disputed the finding at the time, arguing that donations were supported behavior with no negative side effects.

Nine months before the attack, the attacker began accumulating position.

---

## Nine Months of Setup

The wallet behind the exploit was funded with 7,400 ETH routed through Tornado Cash — a preparatory step that indicates deliberate planning rather than opportunistic reconnaissance. Beginning in June 2025, the attacker quietly accumulated approximately 12.2 million THE tokens, reaching 84% of Venus's deposit limit for the asset.

The accumulation phase lasted until March 15, 2026. Then the attack executed.

This timeline is significant. The attacker did not discover a novel vulnerability and move quickly. They identified a known, documented weakness in a protocol that had already been warned about it — and spent nine months building the position required to exploit it at scale.

---

## The Attack Mechanics

THE is the native token of Thena, a DeFi application on BNB Chain. At the time of the attack, its on-chain liquidity was thin — a property the attacker relied on entirely.

The exploit followed a classic oracle manipulation loop: deposit THE as collateral, borrow other assets, use the borrowed funds to purchase more THE, and repeat as Venus's time-weighted average price oracle updated to reflect the artificially elevated spot price. Each cycle pushed the oracle's reported price higher, which increased the apparent value of the collateral, which enabled further borrowing.

The attacker also bypassed Venus's supply cap on THE using a donation attack: rather than depositing through the standard mechanism, they sent THE tokens directly into the vTHE smart contract. This inflated the exchange rate recognized by the protocol without triggering the deposit cap controls. Venus's own audit had flagged this exact behavior as a vulnerability. The team had argued it was acceptable.

Using the inflated collateral valuation, the attacker borrowed 6.67 million CAKE tokens, 1.58 million USDC, 2,801 BNB, and 20 Bitcoin from the protocol — over $3.7 million in total extracted assets.

The manipulation pushed THE's reported price from approximately $0.27 to nearly $5. Venus's time-weighted average oracle, by design, lagged behind the spot manipulation — it had only updated to approximately $0.50 after the initial borrowing round, well below the pumped spot price but still nearly double the pre-attack level.

The attacker pushed further, continuing to buy THE with borrowed funds. Sell pressure overwhelmed the effort. The health factor on the position dropped toward 1, triggering liquidation. With roughly $30 million in notional collateral but virtually no market depth to absorb a sale, THE collapsed into an empty order book — falling to approximately $0.24 after liquidation, below the pre-attack price. The bad debt crystallized at approximately $2.15 million: 1.18 million CAKE and 1.84 million THE that were no longer adequately collateralized after the price collapse.

On-chain researcher Weilin Li, who first flagged the attack via an automated monitoring program that detected a discrepancy between THE's price on centralized and decentralized exchanges, noted that the attacker likely made almost nothing from the on-chain position — and may have lost money. The profit, if any, likely came from leveraged perpetual futures positions on external venues during the price pump.

---

## The Audit Finding That Was Dismissed

The donation attack vector used in this exploit is not a zero-day. It is a documented vulnerability in Compound-forked lending protocols — the architectural lineage that Venus inherits. The specific weakness had been identified in Venus's Code4rena security audit. The development team challenged the severity of the finding, arguing that donations were supported behavior with no negative side effects.

The finding was documented. The argument was made. The protocol proceeded.

The attack on March 15 was not the first time this lesson cost Venus. A donation attack on Venus's ZKSync deployment in February 2025 caused over $700,000 in bad debt through nearly identical mechanics — 13 months before the March 2026 incident, using the same vector, on a different chain deployment of the same protocol. The pattern repeated without the underlying vulnerability being addressed.

Venus's history with manipulation-driven bad debt extends further: a scheme involving its XVS token in 2021 generated over $95 million in bad debt; the Terra/LUNA collapse in 2022 added $14 million more. The March 2026 incident is not anomalous in Venus's operating history. It is consistent with it.

---

## What the Attacker Understood That the Protocol Did Not

The structural problem in the Venus incident is not oracle design in isolation. It is the combination of three conditions that the protocol allowed to coexist: a low-liquidity token accepted as collateral, a time-weighted average oracle susceptible to manipulation when liquidity is thin, and a donation pathway that bypassed supply cap controls.

Any one of these conditions individually would have been manageable. Together, they composed an attack surface that was patient enough to be exploited by an attacker willing to accumulate position over nine months.

The audit process identified the donation pathway as a concern. The team's response — that donations were supported behavior — addressed the mechanism in isolation rather than in the context of how it interacted with thin-liquidity collateral and oracle lag. Compound-forked protocols have a long history of oracle manipulation losses across the ecosystem. The theoretical interaction between these three conditions had been discussed in academic literature before the attack. The attacker had read it.

This is the category of risk that governance processes, audit reviews, and ongoing security firm engagements are designed to address — and, in this case, failed to address, despite explicit flagging during the audit cycle. The team's judgment that the donation behavior was benign proved incorrect. The attacker's judgment that it was exploitable proved correct.

---

## The Collateral Listing Decision as Attack Surface

The proximate cause of the $2.15 million in bad debt was a governance decision: Venus listed THE as collateral in its Core Pool. That decision created the conditions the attacker needed. Without THE as accepted collateral, there is no oracle manipulation loop, no borrowing against inflated valuation, no bad debt when the price collapses.

Permissionless collateral listing — or governance-approved collateral listing — is an ongoing configuration surface. Every new asset accepted as collateral introduces a new set of oracle considerations, a new liquidity profile to assess, and a new interaction surface with the protocol's risk parameters. The assessment of those interactions is necessarily prospective: it asks whether this asset, combined with this oracle configuration and these supply caps, creates conditions that could be exploited.

That assessment failed for THE. It will be performed again for the next asset Venus lists, and the one after that. Each listing is a new configuration decision. Each one is an opportunity for the analysis to miss an interaction that an attacker, given sufficient time and motivation, will find.

---

## The 0xKeep Position

The 0xKeep contract accepts no external collateral. It does not reference oracle price feeds. It does not perform liquidations, manage health factors, or maintain any relationship between asset valuations and borrowing capacity. A user locks a token and a quantity at a point in time; the contract holds it and releases it on the terms specified. There are no market parameters to configure, no collateral listing decisions to make, no supply caps that a donation pathway could bypass.

This scope is deliberately narrow. The interaction surface that Venus's governance must continuously evaluate — which assets to list, what oracle to use, how supply caps interact with donation mechanics — does not exist in 0xKeep's architecture because the use case does not require it.

The security properties of the 0xKeep contract were determined at deployment and cannot be altered. There is no governance proposal that could introduce a new collateral type, no parameter update that could change how tokens are valued, no audit cycle that must correctly anticipate how a new asset interacts with existing risk parameters. The attack surface that produced $2.15 million in bad debt for Venus on March 15 is not a surface that 0xKeep's architecture contains.

---

## The Pattern in Full

March 2026 has now produced three documented incidents across this series: the Curve sDOLA oracle misconfiguration on March 2, the Solv Protocol reentrancy exploit on March 6, and the Venus Protocol oracle manipulation on March 15. Combined losses across the month exceed $5 million in bad debt and drained assets.

All three incidents involved protocols with active security engagements. All three traced to conditions that were either known before the attack or identifiable from published research. In the Venus case, the condition was explicitly flagged during the protocol's own audit — and dismissed.

The security question for any protocol is not whether vulnerabilities can be identified. They can. The question is whether the architecture makes it possible to introduce them in the first place — through a governance vote, a new market deployment, a collateral listing decision, a configuration parameter set by a pool creator.

A contract that cannot be reconfigured after deployment is a contract whose attack surface was fixed at the moment of its last audit. The audit finding either was addressed or it wasn't. There is no subsequent governance proposal to dismiss. There is no new collateral listing to get wrong. There is no nine-month accumulation period the attacker can use to build position against a vulnerability the protocol chose not to fix.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
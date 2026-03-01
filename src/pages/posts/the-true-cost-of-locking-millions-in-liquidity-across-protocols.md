---
layout: ../../layouts/PostLayout.astro
title: The True Cost of Locking $1M in Liquidity Across Five Protocols
date: 2026-02-24
tags:
  - Research
  - Projects
description: A precise fee comparison across five liquidity locking protocols at $1M, $500K, and $100K pool sizes — breaking down what percentage-based and flat-fee models actually cost founders at scale.
image: https://image2url.com/r2/default/images/1772352007482-216c43e7-e858-481f-ad57-88532c08dd35.jpg
---
Most founders evaluate liquidity lockers on reputation and chain support. Fee structure is treated as a secondary consideration — a line item to check rather than a variable to analyze. At small pool sizes, this approach is defensible. At $500,000, $1,000,000, or more, it produces material miscalculations.

This article computes the total cost of locking $1,000,000 in liquidity across five protocols, using their publicly documented fee structures. The numbers are pulled directly from official documentation. No estimates, no approximations.

The goal is not to embarrass any protocol. It is to give founders a precise cost model before they select an infrastructure provider.

---

## Methodology

All fees are computed against three pool sizes: **$100,000**, **$500,000**, and **$1,000,000** in LP token value. Where a protocol charges a percentage of locked LP tokens, the cost is expressed as the dollar value of that percentage at each pool size. Where gas costs apply, they are noted but excluded from the comparison — gas is network-variable and equal across providers on the same chain.

ETH-denominated flat fees are converted at **$2,500 per ETH** for comparison purposes. USD-denominated flat fees are used as stated.

The five protocols evaluated are: **UNCX Network**, **Team Finance**, **PinkLock**, **Mudra**, and **0xKeep**.

---

## Protocol Fee Structures

### UNCX Network (formerly UniCrypt)

UNCX charges a **dual fee** on standard LP locks: a flat base fee denominated in the chain's native token, plus **1% of the LP tokens locked**.

Per their published V2 documentation, the flat component on Base is 0.06 ETH, on Arbitrum is 0.05 ETH, and on Optimism is 0.04 ETH. On Ethereum mainnet, the flat component is 0.1 ETH.

The operative cost variable is the 1% LP supply extraction. At any meaningful pool size, the percentage component dominates the flat fee entirely.

A reduced rate of **0.6% is available** in exchange for burning UNCX tokens — a mechanism that introduces a dependency on the platform's native token to access its most competitive pricing.

### Team Finance

Team Finance charges a **fixed USD fee** regardless of pool size. Their published pricing table shows a flat **$150 per liquidity lock** on major EVM chains including Ethereum, Base, Arbitrum, BSC, and Polygon. Their documentation explicitly states: "We don't take any percentage of your locked tokens."

This is a flat-fee model. The cost is the same whether the pool is $10,000 or $10,000,000.

### PinkLock (PinkSale)

PinkLock charges a **percentage-based fee** on locked LP tokens. Published rates are 1% of the locked amount for standard locks on BSC and compatible chains. PinkLock is primarily positioned for projects launching through the PinkSale launchpad ecosystem and is most commonly used on Binance Smart Chain.

### Mudra Manager

Mudra charges a **flat BNB fee** per lock on Binance Smart Chain, with no percentage component. It is BSC-native and does not support Ethereum, Base, Arbitrum, or Optimism. Its fee is denominated in BNB and is among the lowest absolute costs in the market for BSC deployments.

Because Mudra operates exclusively on BSC, it is included for completeness but is not a relevant comparison for EVM projects deploying on Base, Arbitrum, or Optimism.

### 0xKeep

0xKeep charges a **flat 0.03 ETH per lock**, with zero percentage component. No LP tokens are taken. No supply is extracted. The fee is denominated in ETH — a neutral asset with no relationship to the token being locked. At $2,500/ETH, this is $75 per lock regardless of pool size.

Available on Base, Arbitrum, and Optimism.

---

## The Cost Comparison

### At $100,000 Pool Size

|Protocol|Fee Model|Cost|
|---|---|---|
|UNCX Network|0.06 ETH flat + 1% LP|$150 + $1,000 = **$1,150**|
|Team Finance|$150 flat|**$150**|
|PinkLock|1% LP|**$1,000**|
|Mudra|Flat BNB (BSC only)|**~$10–20**|
|0xKeep|0.03 ETH flat|**$75**|

At $100,000, the spread is already significant. UNCX extracts $1,000 in LP supply on top of its flat fee. PinkLock extracts $1,000 flat. The difference between the two flat-fee providers (Team Finance at $150, 0xKeep at $75) is minor relative to the gap between flat and percentage models.

### At $500,000 Pool Size

|Protocol|Fee Model|Cost|
|---|---|---|
|UNCX Network|0.06 ETH flat + 1% LP|$150 + $5,000 = **$5,150**|
|Team Finance|$150 flat|**$150**|
|PinkLock|1% LP|**$5,000**|
|Mudra|Flat BNB (BSC only)|**~$10–20**|
|0xKeep|0.03 ETH flat|**$75**|

At half a million dollars, UNCX's percentage component has grown to $5,000 — 33x the cost of Team Finance and 67x the cost of 0xKeep. The flat fee providers have not moved. Their cost is structurally fixed. This is the scaling property that percentage models cannot replicate: cost growth is linear with pool size, while flat fees are invariant.

### At $1,000,000 Pool Size

|Protocol|Fee Model|Cost|
|---|---|---|
|UNCX Network|0.06 ETH flat + 1% LP|$150 + $10,000 = **$10,150**|
|Team Finance|$150 flat|**$150**|
|PinkLock|1% LP|**$10,000**|
|Mudra|Flat BNB (BSC only)|**~$10–20**|
|0xKeep|0.03 ETH flat|**$75**|

At $1,000,000 in liquidity, UNCX costs $10,150 to use. PinkLock costs $10,000. Both figures represent a direct extraction from the project's liquidity position — tokens removed from the pool to pay the locker.

Team Finance and 0xKeep have not changed. Team Finance charges $150. 0xKeep charges $75.

---

## What Percentage Fees Are Actually Extracting

The dollar figures above describe the cost to the developer's treasury. They do not fully describe what a percentage fee means to the pool.

When UNCX or PinkLock takes 1% of locked LP tokens as a fee, they are not simply charging for a service. They are acquiring a position in the liquidity pool. The locker becomes a holder of LP tokens representing real underlying assets — the ETH and project tokens in the pool. Those LP tokens can be redeemed. They can be sold. They can be held and redeemed at a later date when the underlying assets have appreciated.

At $1,000,000 in pool value, the locker's 1% position represents $10,000 in real assets. The locker is not a neutral infrastructure provider at that point. It is a stakeholder.

This has downstream consequences that the dollar comparison alone does not capture:

**Supply dilution.** LP tokens represent a share of the pool. Transferring 1% to the locker reduces the developer's proportional ownership of the pool by exactly that amount. The developer locked $1,000,000 in liquidity and now controls $990,000 of it.

**Undisclosed position.** Investors reviewing the lock see that liquidity is secured until a specific date. They may not be aware that a third party holds a 1% position in the underlying pool with no enforced vesting or lockup on that position.

**Misaligned incentives at scale.** As documented in the supply taxation analysis, a locker holding a token position has an incentive structure that may not align with the developer's or investors' interests. The fee creates a relationship between the locker's revenue and the token's value that does not exist under a flat model.

---

## The UNCX Discount Mechanism

UNCX offers a reduced fee of 0.6% — down from 1% — in exchange for burning UNCX tokens. This discount is worth examining.

At $1,000,000, the reduced rate saves $4,000 in LP extraction. But it requires the developer to acquire and burn UNCX tokens to access that rate. The mechanism introduces a second dependency: the developer must hold UNCX, which requires purchasing it on the open market, which creates buy pressure for UNCX and transfers value to UNCX holders.

The net cost of the discounted lock is therefore 0.6% of LP value plus the cost of acquiring and burning sufficient UNCX. At $1,000,000, the developer is paying $6,000 in LP plus an additional UNCX acquisition cost to access the discount. The effective cost reduction relative to the standard rate is real but narrower than the headline discount suggests.

Neither rate is competitive with a flat fee at meaningful pool sizes.

---

## Cumulative Cost: Multiple Locks Over a Protocol Lifecycle

A single lock at launch is not the complete picture. Protocols extend locks, add new pools, and create additional lock positions over their lifecycle. Each additional lock through a percentage-based provider is an additional extraction event.

A protocol that deploys three lock positions at $1,000,000 each over 24 months pays $30,000 to a 1% locker across those deployments. The same three locks through 0xKeep cost $225 total.

For protocols managing multiple chains — Base, Arbitrum, and Optimism simultaneously — the multiplier compounds further. Three chains, three locks each, $1,000,000 per lock: $90,000 in extraction versus $675 in flat fees.

---

## Fee Model Summary

The data above resolves to three distinct categories:

**Percentage models (UNCX, PinkLock):** Cost scales linearly with pool size. At $1M, cost is $10,000+. The fee creates a locker token position with no enforced lockup. Cost grows indefinitely with the protocol's success.

**USD flat models (Team Finance):** Cost is fixed at $150 regardless of pool size. No supply extraction. No locker token position. Structurally neutral at any scale.

**ETH flat models (0xKeep):** Cost is fixed at 0.03 ETH ($75 at $2,500/ETH). No supply extraction. No locker token position. The lowest absolute flat fee among EVM lockers on Base, Arbitrum, and Optimism.

---

## Conclusion

The selection of a liquidity locker is not a neutral infrastructure decision. At pool sizes above $100,000, fee model selection is a financial decision with outcomes that scale with the protocol's success.

A percentage fee that costs $1,000 at $100,000 costs $100,000 at $10,000,000. The service rendered is identical. The only variable is how much capital the protocol has successfully attracted — which means the cost model penalizes the protocols that perform best.

Flat fee infrastructure inverts this. A protocol locking $10,000,000 pays the same $75 as a protocol locking $10,000. The infrastructure scales with usage, not with outcome.

Founders evaluating lockers should model their expected pool size at each lock event and compute the actual fee before selecting a provider. The numbers in this article are a starting point. The arithmetic is straightforward.

Cost is a verifiable parameter. Verify it.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
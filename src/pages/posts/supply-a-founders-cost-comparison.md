---
layout: ../../layouts/PostLayout.astro
title: "0.03 ETH vs. 1% of Supply: A Founder's Cost Comparison"
date: 2026-01-27
tags:
  - Research
  - Projects
description: A direct-number analysis of what percentage-based locker fees actually cost at each stage of a protocol's growth — and what that capital could have built instead.
image: https://image2url.com/r2/default/images/1772352171016-9c0f30de-2359-4457-8c33-835c45bd1e51.jpg
---
## Two Numbers, One Decision

When a founder evaluates a liquidity locker, the fee structure rarely receives the scrutiny it deserves. The focus is on interface quality, supported chains, and brand recognition. The cost is treated as a line item too small to matter.

For early-stage projects, that assumption is defensible. At $10,000 in liquidity, the difference between a 1% fee and a flat 0.03 ETH fee is roughly $10. It does not materially affect the protocol's trajectory.

The assumption stops being defensible the moment the protocol grows. And protocol growth is the point.

This article runs the numbers at each stage of a realistic protocol lifecycle — from pre-launch to scaled liquidity — and translates the cost differential into something more legible than a fee comparison: what that capital would have funded instead.

---

## The Baseline Assumptions

To produce a clean comparison, we hold the following variables constant throughout:

- **Percentage fee benchmark:** 1% of deposited token supply value (industry representative rate)
- **0xKeep flat fee:** 0.03 ETH
- **ETH valuation:** $3,000 USD (0.03 ETH = $90)
- **Fee basis:** Applied once per lock event, not recurring
- **Supply value:** Refers to the USD value of the tokens being locked at time of deposit

All figures are presented in USD for comparability.

---

## Stage 1: Pre-Launch / Testnet Gradient ($10,000 Supply Value)

This is the earliest a founder would realistically deploy a liquidity lock — a small pool seeded to demonstrate commitment before a broader raise or public launch.

|Fee Model|Cost|
|---|---|
|1% of Supply|$100.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$10.00**|

At this stage, the models are nearly identical. The flat fee offers a marginal saving, but neither option is prohibitive. The decision here is not primarily financial — it is architectural. Choosing an immutable flat-fee locker at the start establishes a verifiable on-chain record from day one and avoids locking in a fee model that will compound against the protocol as it scales.

**What $10 funds:** Nothing meaningful. At this stage, the fee model matters less than the contract architecture.

---

## Stage 2: Seed Liquidity ($50,000 Supply Value)

A protocol has completed its initial raise, seeded a live liquidity pool, and is preparing for a wider community launch. $50,000 in locked liquidity is a credible signal to early investors.

|Fee Model|Cost|
|---|---|
|1% of Supply|$500.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$410.00**|

The divergence becomes visible. $410 is not a rounding error for a pre-revenue protocol. It is a material allocation — one that has left the protocol's treasury and produced no on-chain benefit beyond what the $90 alternative would have delivered identically.

**What $410 funds:** One month of a junior developer's time on a contract basis. A Dune Analytics dashboard build. Two independent code reviews of a specific contract function. Three months of server infrastructure.

---

## Stage 3: Growth Phase ($250,000 Supply Value)

The protocol has survived its launch window. Liquidity has grown through trading fees, LP incentives, or a successful raise. $250,000 in locked liquidity is now a credible protocol — one that investors are beginning to treat as a durable position rather than a speculative entry.

|Fee Model|Cost|
|---|---|
|1% of Supply|$2,500.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$2,410.00**|

At this stage, the percentage model has moved from expensive to extractive. The protocol's growth is being taxed by the infrastructure it relies on to prove its trustworthiness. The fee is no longer a cost of security. It is a cost of scale, imposed by a vendor whose revenue grows in direct proportion to the protocol's success.

**What $2,410 funds:** A partial smart contract audit from a boutique security firm. A full month of community management. A targeted liquidity mining campaign. Legal review of a DAO contributor agreement.

---

## Stage 4: Established Protocol ($500,000 Supply Value)

The protocol has reached a threshold where institutional or semi-professional participants are beginning to take positions. $500,000 in locked liquidity represents a serious commitment — and the scrutiny applied to the protocol's infrastructure choices increases accordingly.

|Fee Model|Cost|
|---|---|
|1% of Supply|$5,000.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$4,910.00**|

Nearly $5,000 paid to a locker. This is a number that would appear on a protocol's financial review if one were conducted. It is also a number that, under a flat-fee model, would read $90.

**What $4,910 funds:** A full smart contract audit from a recognized firm. Six months of protocol documentation and developer relations. A multi-chain deployment and testing cycle. The entirety of a small protocol's annual infrastructure costs.

---

## Stage 5: Scaled Liquidity ($1,000,000 Supply Value)

Seven figures in locked liquidity. The protocol is operating at a scale where its locker choice is now a line item that a financially literate investor would flag during due diligence.

|Fee Model|Cost|
|---|---|
|1% of Supply|$10,000.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$9,910.00**|

$10,000 to lock $1,000,000 in liquidity. The fee has crossed from operational overhead into strategic capital. It is the equivalent of a 1% management fee on a position that requires no active management — because the entire value proposition of a liquidity lock is that it runs itself.

**What $9,910 funds:** A complete protocol audit from a top-tier security firm. A six-month contributor grant for a full-stack developer. A cross-chain integration build. The legal formation of a DAO entity.

---

## Stage 6: Institutional Scale ($5,000,000 Supply Value)

The protocol is now operating at a scale where its treasury decisions have real downstream consequences. Liquidity at this level attracts institutional LPs, aggregator routing, and significantly more rigorous public scrutiny.

|Fee Model|Cost|
|---|---|
|1% of Supply|$50,000.00|
|0xKeep Flat Fee|$90.00|
|**Differential**|**$49,910.00**|

$50,000. Paid to a locker. For a service that required no ongoing computation, no active management, and no human intervention. A service that a flat-fee, immutable contract delivers for $90.

**What $49,910 funds:** The full annual compensation of a senior Solidity engineer. A comprehensive multi-contract audit suite. Twelve months of protocol marketing and developer relations. The operational budget of a small DeFi foundation for a year.

---

## The Compounding Problem: Multiple Locks

The figures above model a single lock event. Protocols routinely deploy multiple locks across their lifecycle — separate locks for LP tokens, treasury allocations, team vesting, and advisor compensation. Each additional lock under a percentage model incurs a new percentage-based fee.

Under 0xKeep's flat model, the second lock costs 0.03 ETH. The tenth lock costs 0.03 ETH. The fee is invariant to both position size and lock frequency.

A protocol locking five separate positions at $500,000 each pays $25,000 under a 1% model. Under 0xKeep, the same five locks cost $450 total.

```
Fee invariant: 0xKeep charges 0.03 ETH per lock.
Position size does not affect the fee.
Lock frequency does not affect the fee.
Protocol growth does not affect the fee.
```

---

## The Question Underneath the Numbers

The cost differential at scale raises a question that goes beyond fee optimization: what does it mean for a locker to charge a percentage of supply?

A flat-fee locker's revenue is decoupled from the protocol's performance. It charges the same whether the protocol succeeds or fails. Its incentive is to provide reliable infrastructure to as many protocols as possible.

A percentage-based locker's revenue scales with the protocol's success. The more valuable the locked position, the more the locker earns — without providing any additional service, computation, or security guarantee. The lock at $10,000,000 is mechanically identical to the lock at $10,000. The fee is not.

This is not an alignment. It is extraction. The percentage model treats the founder's success as a revenue event for the infrastructure provider. The flat model treats it as irrelevant to the fee — as it should be.

---

## Summary: The Full Cost Table

|Supply Value|% Fee (1%)|0xKeep Flat Fee|Differential|
|---|---|---|---|
|$10,000|$100|$90|$10|
|$50,000|$500|$90|$410|
|$250,000|$2,500|$90|$2,410|
|$500,000|$5,000|$90|$4,910|
|$1,000,000|$10,000|$90|$9,910|
|$5,000,000|$50,000|$90|$49,910|
|$10,000,000|$100,000|$90|$99,910|

`ETH held at $3,000 USD. Percentage benchmark at 1% of supply value.`

---

## Conclusion

The fee model a founder chooses when locking liquidity is not an administrative decision. It is a capital allocation decision. The differential between percentage-based and flat-fee lockers begins as negligible and ends as transformative — not because the locker changes, but because the protocol grows.

A locker that taxes growth is not infrastructure. It is overhead.

0xKeep charges 0.03 ETH. At any supply size. On any supported chain. The fee does not change because the protocol's value does not determine the cost of deploying an immutable lock.

The math is not a sales argument. It is arithmetic. The founder's job is to decide which number belongs in their treasury and which belongs in someone else's.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
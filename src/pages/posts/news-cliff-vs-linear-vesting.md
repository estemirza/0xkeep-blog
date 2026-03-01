---
layout: ../../layouts/PostLayout.astro
title: "Cliff vs. Linear Vesting: How Your Unlock Structure Affects Market Stability"
date: 2026-02-18
tags:
  - News
  - Guides
  - Research
description: The week of Feb 17–21 saw $130M+ in scheduled token unlocks hit circulation, with TON's $53.27M cliff release leading the pack. The market reaction illustrates a precise mechanical distinction that every token team should understand before choosing a vesting structure.
image: https://image2url.com/r2/default/images/1772352027755-80ac9a0c-ac33-47ba-b803-c707e8ae01f3.jpg
---
The week of February 17–21 delivered a useful, live illustration of a concept that token teams frequently underestimate: the difference between _when_ tokens unlock and _how_ they unlock is not a scheduling detail. It is a market structure decision.

Over **$130M in scheduled token unlocks** hit circulating supply across the week. TON led the cohort with a **$53.27M cliff release** — a single, discrete event that moved the entire scheduled allocation from locked to liquid in one block. Market watchers flagged immediate pressure on price and trading volume, consistent with the pattern that concentrated unlock events have produced historically.

The week's other unlocks were distributed, linear, or structured with initial cliff periods followed by streaming releases. Their market footprint, broadly speaking, was smaller — not because the total values were lower, but because the _rate_ at which supply entered circulation was bounded by design.

This distinction has a precise mechanical explanation, and it has direct implications for how protocol teams should structure their own vesting schedules.

---

## The Mechanics of a Cliff

A cliff is a waiting period before any tokens become liquid. During the cliff, the vesting beneficiary — a team member, an advisor, an early investor — holds a claim on an allocation that is fully locked. On the cliff date, the claim converts: some portion of the allocation, or all of it, becomes immediately withdrawable.

The simplest cliff structure is a full release: wait 12 months, receive 100% of the allocation in a single transaction. This is common in early-stage project vesting because it is easy to model and easy to communicate. The team commits to a 12-month hold. Investors can verify the lock. On day 365, the tokens are theirs.

The market consequence of this structure is directly proportional to the size of the allocation. When $53M in TON unlocks in a single event, $53M worth of sell pressure becomes possible in a timeframe bounded only by how quickly holders choose to act. Whether or not holders actually sell, the _possibility_ of that volume entering the market is priced by the market in advance — often for days or weeks before the cliff date, and then again at the moment of release.

The TON unlock was not a surprise. It was on-chain, scheduled, publicly visible in advance. The price impact was anticipated. It happened anyway, because anticipation does not eliminate the event — it frontloads the response to it.

---

## The Mechanics of Linear Vesting

Linear vesting does not release tokens at a point. It releases them as a rate.

In a streaming vesting model, an allocation of 1,200,000 tokens vesting over 12 months unlocks at a rate of approximately 3,288 tokens per day, 137 per hour, 2.28 per minute. At any given moment, the beneficiary can withdraw exactly the tokens that have accrued since their last withdrawal — no more. The allocation does not become a discrete liquidity event. It becomes a continuous, bounded flow.

From a market structure perspective, the difference is significant. A holder receiving 3,288 tokens per day faces a different incentive landscape than a holder who receives 1,200,000 tokens on a single date. Daily accruals can be managed, reinvested, or held without requiring a discrete sell decision. The allocation's entry into circulating supply is paced. Buyers have time to absorb it. Price impact is distributed across the vesting duration rather than concentrated at a single event.

Linear vesting does not eliminate sell pressure. It stretches it across time. For liquid, high-volume assets, that difference may be marginal. For tokens with lower liquidity depth, the difference between a cliff release and a linear release of the same total value can be the difference between an orderly market and a disorderly one.

---

## The Combined Structure: Cliff Then Linear

The most commonly used vesting structure in professional token allocations is a hybrid: an initial cliff followed by linear vesting over the remainder of the schedule.

A typical configuration for a team member allocation might be: a 6-month cliff, after which vesting begins, releasing tokens linearly over the following 18 months. On the cliff date, no tokens release — the cliff marks the beginning of vesting eligibility, not a release event. After the cliff, the linear stream begins and tokens accrue second-by-second for the 18-month vesting period.

This structure serves several purposes simultaneously. The cliff filters for commitment — a team member who leaves in month four receives nothing, eliminating the incentive to collect an allocation and immediately depart. The linear period after the cliff smooths the market impact of the full allocation. And the combination gives investors a verifiable, on-chain structure they can inspect before committing capital.

The cliff as a release event — where some percentage of the allocation becomes liquid on the cliff date, with the remainder streaming afterward — is a distinct variant. This is more common in investor allocations where some immediate liquidity is part of the negotiated terms. A 25% release on cliff date, followed by 75% linear over 24 months, is a reasonable structure for an early investor who needs some liquidity at the 12-month mark. It still concentrates some supply release at the cliff date, but bounded by the percentage terms rather than the full allocation.

---

## What This Week's Unlocks Illustrate

The TON cliff release this week is a case study in scale, not in unusual structure. Cliff releases for large allocations are a known, predictable source of concentrated supply events across the industry. The market has developed reasonably efficient mechanisms for pricing them in advance — futures funding rates shift, options markets price the event, spot markets often see preemptive selling in the days before the date.

What the market cannot fully absorb in advance is the uncertainty about holder behavior at the cliff. The cliff date converts a known _amount_ of locked tokens into a liquid _supply_ — but it does not determine what proportion of that supply becomes active sell volume. That depends on holder conviction, portfolio management decisions, tax timing, and market conditions on the specific day of release. The market can price the average expected outcome. It cannot hedge the distribution of possible outcomes perfectly.

Linear vesting structures reduce this uncertainty by compressing the variance. The daily release rate is deterministic. The maximum supply addition in any given day is bounded and calculable. Holders who want to sell their daily accrual can do so gradually; holders who want to accumulate have time to buy against the flow. The market's uncertainty about total near-term supply addition is lower, even if the total long-run allocation is identical.

---

## Choosing a Structure: What the Decision Actually Involves

For protocol teams designing vesting schedules, the cliff versus linear question is not purely a market structure decision. It involves several competing considerations.

**Commitment alignment.** A longer cliff period increases the cost of early departure for team members and advisors. A 12-month cliff means the first 12 months of contribution are not directly compensated by liquid tokens. This is a meaningful retention mechanism, but it also affects the attractiveness of the arrangement for high-optionality talent who have alternative opportunities. The cliff duration should reflect the protocol's stage and the market for comparable roles.

**Investor expectations.** Early-stage investors frequently negotiate for some cliff-date liquidity — a percentage release on the vesting start date that provides partial return on capital at a defined milestone. This is a reasonable negotiating point, but teams should model the market impact of the cliff-date release at projected fully diluted valuations, not at current prices. A cliff-date release that looks manageable at a $10M FDV can be a significant supply event at $100M.

**Verifiability.** Whatever structure is chosen, it should be on-chain and verifiable by anyone before they invest. An announced vesting schedule that lives in a PDF is not a vesting structure. It is a statement of intent. The difference matters when the incentive to deviate from the schedule becomes material — which it frequently does, at exactly the moment when the on-chain constraint would have been most valuable.

**Transferability of vesting control.** A practical consideration that teams frequently overlook: what happens to an advisor's vesting schedule if the advisor relationship ends, or a team member's schedule if they leave? If the vesting control is attached to the original wallet and the relationship ends badly, the protocol may have no recourse. A vesting architecture that supports ownership transfer — where the vesting manager role can be handed to a new address without interrupting the schedule — is significantly more resilient to the personnel changes that are predictable over a multi-year vesting period.

---

## How 0xKeep Implements This

0xKeep's vesting contracts implement both cliff and linear mechanics, configurable at the time of schedule creation.

The cliff is set as a duration from the vesting start date. During the cliff period, the vesting counter runs but no tokens are withdrawable. At the cliff end, the linear stream begins — not a lump-sum release, but the start of second-by-second accrual across the remaining vesting duration. The beneficiary can withdraw accrued tokens at any point after the cliff, in whatever increments suit their needs.

The vesting ownership is transferable. If a team member leaves or an advisor relationship changes, the vesting manager role can be assigned to a new wallet address. The schedule continues unchanged. The protocol does not need to be redesigned to accommodate personnel decisions.

Both the cliff duration and the linear vesting period are set at schedule creation and enforced by an immutable contract. There are no admin keys that can accelerate the schedule. There is no upgrade path that can alter the parameters. The structure agreed upon at creation is the structure that will govern the schedule until it completes — verifiable by anyone, alterable by no one.

The fee is 0.02 ETH per vesting schedule, regardless of allocation size. A team vesting $5M to a founding team member pays the same fee as a team vesting $50K to an advisor. There is no percentage deduction from the token supply. The beneficiary receives what the schedule specifies, in full.

---

## Closing Note

The February unlock week is a recurring data point in an ongoing argument about token vesting design. The argument is not that cliff releases are wrong — they serve legitimate purposes and their market impact is, for sufficiently liquid assets, manageable. The argument is that the structure of an unlock schedule is a market structure decision with quantifiable consequences, and those consequences should be modeled before the schedule is locked in, not observed after.

Linear vesting does not make sell pressure disappear. It makes it predictable, bounded, and distributed across time. For a protocol trying to build a stable, long-run liquid market for its token, predictable and bounded is substantially better than concentrated and uncertain.

The on-chain record is permanent. Investors, market makers, and future contributors will read your vesting structure before they engage with your protocol. A well-designed, on-chain-enforced schedule communicates something that no whitepaper section can: that the commitment is not a statement of intent but a mathematical constraint.

That constraint is the point.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
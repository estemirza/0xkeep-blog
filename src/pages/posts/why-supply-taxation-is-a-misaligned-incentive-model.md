---
layout: ../../layouts/PostLayout.astro
title: Why Supply Taxation Is a Misaligned Incentive Model
date: 2026-02-10
tags:
  - Research
  - Developers
description: A technical and economic analysis of percentage-based locker fees — why taxing a developer's token supply creates perverse incentives, and what a structurally sound alternative looks like.
image: https://image2url.com/r2/default/images/1772352218024-53ce964c-4cd4-4ffa-a1fa-96af0ab6ff80.jpg
---
Most liquidity lockers charge a percentage of the tokens being locked. The mechanism is presented as simple and fair: the service provider takes a small cut, the developer locks the rest. In practice, this model introduces a set of structural misalignments that penalize legitimate projects, reward bad actors, and create an adversarial relationship between infrastructure providers and the developers who depend on them.

This is not a pricing complaint. It is an incentive analysis.

---

## How Supply Taxation Works

When a developer deploys a token and attempts to lock liquidity or vest team allocations, a percentage-based locker extracts a portion of the token supply as a fee. Typical rates range from 1% to 3% of the locked amount.

The locker now holds a position in the token. It becomes, structurally speaking, a stakeholder.

That fact has consequences.

---

## The Core Misalignment: Your Infrastructure Provider Holds Your Supply

When a service provider takes a percentage of your token supply as payment, their economic interest becomes entangled with your token's price performance. This is not alignment — it is dependency with asymmetric risk.

Consider the mechanics. A locker charging 2% on a 10,000,000 token lock receives 200,000 tokens. Those tokens have no guaranteed liquidity, no enforced vesting, and no lockup — the locker received them as a fee, which means they are, by definition, immediately liquid or disposable at the provider's discretion.

The developer has now created an undisclosed seller. The locker can liquidate its fee position at any time, at any price, exerting downward pressure on the token they were paid to secure. The developer locked their liquidity to signal commitment to investors. The infrastructure provider they used to do so is selling into their market.

This is not a hypothetical edge case. It is the default behavior of the percentage fee model.

---

## The Scaling Problem: Cost Is Proportional to Ambition

A flat fee model charges the same amount regardless of the value being locked. A percentage fee model charges more as the locked value increases.

This creates a perverse outcome: the projects that benefit most from credible, long-term liquidity locks — projects with real capital and serious investors — pay the highest absolute cost to use the infrastructure.

The math is direct. A project locking $50,000 worth of LP tokens at a 2% fee pays $1,000 in supply taxation. A project locking $5,000,000 pays $100,000. The service rendered is identical. The contract call is the same. The security properties are the same. The cost differential exists purely because the value was larger.

Flat fee infrastructure inverts this. The cost is fixed and known in advance — 0.03 ETH regardless of the locked amount. A project locking $5,000,000 in liquidity pays the same as a project locking $5,000. The infrastructure scales with usage, not with the developer's success.

---

## The Incentive to Minimize Rather Than Maximize

When locking is expensive proportional to supply, developers face an incentive to lock less.

A founder who intended to lock 80% of LP supply runs the cost calculation, discovers that doing so at a percentage rate costs significantly more than locking 30%, and makes a compromise. The lock is smaller. The signal to investors is weaker. The actual security guarantee is reduced — not because the founder was malicious, but because the pricing model created a direct disincentive to locking more.

This is structurally backwards. Liquidity locking infrastructure should incentivize maximum commitment. It should make locking 100% of LP tokens as economically trivial as locking 10%. Any pricing model that creates pressure toward smaller locks is misaligned with the purpose of the infrastructure itself.

---

## The Undisclosed Supply Dilution Problem

Token supply is not an abstraction. Every token in existence is a claim on a share of the project's value. When a locker takes 2% of a token supply as a fee, that 2% came from somewhere — either from the developer's allocation, reducing their position, or from the total supply, diluting every other holder.

In either case, the extraction happens at the moment of locking. Investors who reviewed the token distribution before the lock was created may be looking at a supply table that no longer reflects reality. The locker's fee position is a new seller in the market, and depending on the project's disclosure practices, investors may have no visibility into its existence.

A flat ETH fee eliminates this entirely. The infrastructure is paid in the chain's base currency — a neutral asset with no relationship to the token being locked. There is no supply dilution. There is no new undisclosed seller. The token distribution that investors reviewed is the token distribution that exists.

---

## Admin Keys as a Compounding Risk

Percentage-based lockers frequently combine supply taxation with retained admin access. Because they hold a stake in the locked tokens, they maintain upgrade paths, pause mechanisms, or emergency withdrawal functions that nominally exist for dispute resolution or error correction.

In practice, these functions are a persistent attack surface. An admin key is a single point of failure. A compromised key — whether through a hack, an internal bad actor, or a social engineering attack — can be used to modify lock parameters, extend or shorten durations, or in the worst case, trigger an emergency release that drains the locked position.

The argument for retaining admin keys is that they protect against user error. The counterargument is deterministic: a contract that cannot be modified cannot be exploited through modification. Immutability is not a limitation. It is the security property.

An infrastructure provider that charges percentage fees and retains admin keys has created a model where their revenue is tied to your token's price, they hold an undisclosed seller position in your supply, and they maintain the technical capability to intervene in your lock at any time.

Each of these properties is individually problematic. Combined, they constitute a structural conflict of interest.

---

## What Aligned Infrastructure Looks Like

The alternative is not complex. It requires only two properties:

**First, a flat fee denominated in a neutral asset.** ETH, USDC, or the chain's base currency — something with no relationship to the token being locked. The infrastructure provider is paid at the moment of service. Their economic interest in the transaction ends there. They hold no position in your supply, have no incentive to liquidate into your market, and have no reason to care about your token's price trajectory.

**Second, an immutable contract with no admin keys.** No pause function. No emergency withdrawal. No upgrade path. No owner address with elevated permissions. The lock terms, once written, are permanent. The vesting schedule, once deployed, executes deterministically. No key can change them — not the developer's, not the infrastructure provider's, not anyone's.

These two properties together define infrastructure that serves the developer and investor rather than extracting from them.

---

## The Economic Comparison

The contrast between models becomes concrete at scale.

A project with a $2,000,000 liquidity pool locking 100% of LP supply at a 2% rate pays $40,000 in supply taxation — tokens extracted from the project's distribution, converted into an undisclosed seller position held by the locker.

The same project using flat-fee infrastructure at 0.03 ETH pays approximately $75 at current ETH prices. The lock is identical in duration and security properties. The difference is $39,925 that remains in the project's treasury or supply distribution, allocated according to the founder's roadmap rather than a pricing formula.

At a 1% rate on that same pool, the fee is $20,000. At 3%, it is $60,000. None of these numbers reflect any additional security or functionality. They reflect a pricing model calibrated to the size of the developer's ambition rather than the cost of the service.

---

## Conclusion

Supply taxation is not a neutral pricing mechanism. It creates an infrastructure provider with a token position, an incentive to minimize locking, an undisclosed dilution event at the moment of the lock, and in most implementations, a retained technical capability to intervene in the locked contract.

These are not incidental properties of percentage-based fees. They are structural consequences of the model itself.

Founders who want to demonstrate genuine commitment to investors need infrastructure that does not create new liabilities in the process. The fee should be fixed, denominated in a neutral asset, and final. The contract should be immutable. The terms should be readable on-chain by anyone, at any time, without trusting a provider's documentation or support desk.

Infrastructure that cannot be modified cannot be exploited. Fees that do not create supply positions cannot create undisclosed sellers.

The architecture should serve the protocol — not extract from it.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
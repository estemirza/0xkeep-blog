---
layout: ../../layouts/PostLayout.astro
title: Why 0xKeep Charges a Flat Fee — And What That Says About Our Incentives
date: 2026-03-31
tags:
  - Research
  - Projects
description: A first-person examination of 0xKeep's flat fee model — the architectural reasoning behind it, the incentive structure it creates, and why the fee design is inseparable from the trust model the protocol is built to provide.
image: https://image2url.com/r2/default/images/1772352218024-53ce964c-4cd4-4ffa-a1fa-96af0ab6ff80.jpg
---
Every fee model is an incentive structure. The way a protocol charges for its services determines what it is rewarded for, what it is penalized for, and whose interests it is structurally aligned with. Fee design is not a pricing decision made in isolation. It is an architectural decision with downstream consequences for every relationship the protocol has with its users.

0xKeep charges a flat fee: 0.03 ETH per liquidity lock, 0.02 ETH per vesting schedule. That is the complete fee structure. No percentage of the locked amount. No token taken. No supply extracted. The same fee applies whether the lock covers $5,000 or $5,000,000.

This article explains why — not as a marketing argument, but as a structural analysis of what the flat fee model produces and what it would mean to do it differently.

---

## What We Are Paid For

The service 0xKeep provides is the deployment and enforcement of a cryptographic commitment. A founder deposits LP tokens or a contributor's allocation into the `ZeroXKeepLocker` contract. The contract holds those assets and releases them exclusively to the designated beneficiary at the designated time, under conditions that cannot be modified by any party after deployment — including us.

The computational work involved in this service is constant. Creating a lock record, storing the parameters, enforcing the release condition at withdrawal — these operations cost the same gas regardless of whether the locked amount is 1,000 tokens or 1,000,000,000. The contract does not work harder for larger positions. The security properties do not improve with scale. The commitment is the same commitment.

Charging a percentage of the locked amount would mean charging more for the same service when the locked value is larger. The only justification for that pricing model is that larger positions represent more extractable value — which means the fee is not calibrated to the cost of the service. It is calibrated to the opportunity to extract from it.

We charge a flat fee because we are paid for deploying a contract call, not for the value that passes through it.

---

## What a Percentage Fee Would Do to Our Incentives

If 0xKeep charged 1% of locked value, our revenue would be directly proportional to the total value locked across the protocol. Every increase in TVL would increase our income. Every project that grows its liquidity pool would increase our income. Our financial interest would be tied to the token price performance of every project we serve.

That alignment sounds appealing until you trace its consequences.

A protocol with a financial stake in token price performance has an incentive — structural, not necessarily intentional — to serve projects that will appreciate rather than projects that need the infrastructure most. It has an incentive to retain positions rather than facilitate their release. It has an incentive to support high-TVL projects over early-stage ones with small pools. And it holds, in aggregate, a portfolio of token positions representing fee extractions from every project it has ever locked.

That portfolio is a set of undisclosed seller positions in every token we have ever handled. Each one was created the moment a project locked their liquidity. Each one is a claim the protocol can exercise against the market at any time, in a quantity proportional to the pool size at the time of the lock.

The flat fee eliminates this entirely. Our revenue is a function of the number of locks and vestings created, not their value. We do not hold a position in any token we lock. We have no undisclosed sell pressure against any project we serve. Our financial interest is in the number of protocols that choose to use 0xKeep — not in their subsequent price performance.

The incentive to provide good infrastructure, rather than to extract from the assets that pass through it, is structurally enforced by the fee model. Not by our values. By the architecture.

---

## What the Flat Fee Is Denominated In

The fee is paid in ETH — the native currency of the chains where 0xKeep is deployed. It is not paid in 0xKeep tokens. It is not paid in a governance token. It is not paid by burning a platform-native asset to access a discounted rate.

This is deliberate.

A fee denominated in a platform-native token creates a dependency. The developer who needs to lock liquidity must first acquire the platform's token to pay for the service. This creates buy pressure for the token, which benefits the token holders — who may include the development team — regardless of whether the developer intended to hold that token. The fee is structured to generate demand for an asset the platform controls.

ETH is a neutral asset. No one at 0xKeep benefits from ETH appreciation in a way that is distinct from any other ETH holder. The fee payment creates no compulsory demand for any asset we influence. The developer pays in a currency they already hold to use a chain that already requires it. The transaction is complete. We have no ongoing financial relationship with the project beyond that payment.

The UNCX discount mechanism — where locking at a reduced fee rate requires burning UNCX tokens — is the explicit version of the native-token dependency. To access the best price, you must acquire and destroy an asset that benefits UNCX holders by reducing its supply. The service is cheaper but only for developers who are willing to participate in the platform's tokenomics. The fee is not truly flat because the lowest available rate has a precondition that channels value to the platform's existing stakeholders.

We have no token. There is no discount mechanic. There is no precondition. The fee is 0.03 ETH and 0.02 ETH. Those numbers are set in the constructor as immutable values. They cannot be changed after deployment — not by governance, not by a team decision, not by any mechanism. The developer who reads the fee parameters in the contract today will pay the same fees in two years.

---

## Fee Immutability as a Trust Property

The fees in `ZeroXKeepLocker` are not controlled by an admin function. They are not stored in a mutable state variable. They are declared as `immutable` and set in the constructor:

solidity

```solidity
uint256 public immutable LOCK_FEE;
uint256 public immutable VESTING_FEE;
address payable public immutable feeReceiver;
```

Once deployed, these values are permanent. There is no `setFee()` function. There is no governance mechanism that can vote to increase fees. There is no multisig that can adjust the parameters. The fee a developer pays when they create a lock today is the fee that will apply to every lock created against this contract for its entire operational lifetime.

This matters for a specific reason: fee mutability is an underappreciated attack surface in DeFi infrastructure.

A protocol that can increase its fees after users have integrated it — after developers have built tooling around it, after investors have come to rely on it — has leverage over those users. The switching cost of migrating to a different locker is real: new contract addresses, new documentation, new integrations, new verification links for investors. A fee increase imposed after users are locked in exploits that switching cost.

Immutable fees eliminate that leverage. The protocol cannot extract additional value from its user base by raising prices after adoption. The fee that attracted the first user is the fee that applies to the millionth. The economic relationship is fixed at deployment and verifiable by anyone who reads the contract.

---

## What Zero Treasury Accumulation Means

The `_payFee()` function in `ZeroXKeepLocker` transfers the exact fee amount to `feeReceiver` immediately upon receipt. Any excess ETH sent by the user is refunded in the same transaction. The contract's ETH balance after any interaction is zero.

This is not incidental. It is a design choice with security consequences.

A contract that accumulates ETH in its own balance is a target. The accumulated balance represents extractable value — through reentrancy, through an admin withdrawal function, through a future exploit not yet discovered. Every ETH held in the contract is ETH that can be lost if the contract is compromised.

By routing fees immediately to an external address and refunding excess immediately, `ZeroXKeepLocker` holds no ETH between transactions. There is no accumulated treasury to drain. The ETH-based reentrancy attack surface — the attack class that has produced the most cumulative losses in DeFi history — has nothing to act against.

This also means 0xKeep does not operate a treasury within the protocol contract itself. We are paid per transaction. We do not hold protocol reserves in the locker contract. Our revenue model is pass-through: fees arrive and immediately leave. The protocol is not a bank. It does not accumulate and manage a float.

---

## The Relationship Between Fee Design and Product Design

The flat fee is not merely a pricing decision. It is the fee model that is consistent with the rest of the protocol's architecture.

An upgradeable protocol needs fee mutability because it needs the ability to change things. An admin-controlled protocol needs fee control because admin control implies the ability to adjust parameters. A protocol with a governance token needs fee mechanisms that generate demand for that token.

0xKeep has none of these properties. The contract is immutable. There is no admin. There is no governance token. The fee design follows from the architecture, not the other way around.

If the contract cannot be upgraded, the fee must be set correctly at deployment — and immutable fees enforce that correctness permanently. If there is no admin, there is no one to adjust fees in response to market conditions — and immutable fees mean the developer can verify the fee structure without trusting any ongoing organizational decision. If there is no governance token, the fee cannot be structured to benefit token holders — and an ETH-denominated flat fee is the only fee structure consistent with that absence.

Each property of the fee model is the logical consequence of a prior architectural decision. The flat fee and the immutable fee and the ETH denomination and the zero treasury accumulation are all expressions of the same underlying design principle: the protocol should not extract value from the assets it is trusted to protect, and its revenue model should not create incentives that conflict with that purpose.

---

## What the Fee Says About the Incentive Structure

The fee model answers a question that developers and investors should be asking of every infrastructure provider they use: what is this protocol rewarded for?

A percentage-fee locker is rewarded for locking more valuable assets. It benefits when token prices rise. It benefits from the success of the projects it serves. It holds supply positions in every project it has locked. Its financial health is entangled with the financial health of its entire user base.

0xKeep is rewarded for the number of locks and vestings created. We benefit when more founders and contributors use the protocol. We do not benefit from any individual project's token price performance. We hold no positions in any locked asset. Our financial health is a function of usage volume, not asset value.

This distinction is the difference between an infrastructure provider that profits from your success and an infrastructure provider that profits from your transaction. The former has an incentive to be present in your cap table. The latter has an incentive to be useful to as many developers as possible, consistently, at a known and stable cost.

We prefer to be the latter.

The flat fee is not generosity. It is alignment. We designed the revenue model to not create conflicts with the service model. The incentive structure that results — where our income is not correlated with any individual project's token price, where we hold no supply positions, where we cannot raise fees after adoption — is not an accident. It is the architecture.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
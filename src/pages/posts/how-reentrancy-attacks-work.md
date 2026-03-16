---
layout: ../../layouts/PostLayout.astro
title: How Reentrancy Attacks Work — And Why 0xKeep's Architecture Prevents Them
date: 2026-03-17
tags:
  - Security
  - Research
description: A technical dissection of reentrancy as an exploit class — the execution mechanics, the historical damage, and why 0xKeep's Checks-Effects-Interactions pattern and immutable architecture produce a deterministic defense.
image: https://image2url.com/r2/default/images/1772352408852-2e590f95-2f9b-42bf-9888-d84ff8cf58ba.jpg
---
Reentrancy is the oldest exploit class in Ethereum's history. The first major DeFi incident — the 2016 DAO hack that drained 3.6 million ETH and produced a contentious hard fork — was a reentrancy attack. It has recurred in every subsequent year, in protocols that were audited, in protocols that were live for months before the exploit, and in protocols whose developers were aware of the vulnerability class and believed their code was not susceptible to it.

Understanding why requires more than knowing the definition. It requires understanding the execution model that makes reentrancy possible, the specific contract patterns that introduce it, the architectural decisions that eliminate it, and why immutability is the only property that makes those decisions permanent.

---

## The Execution Model: How External Calls Work

To understand reentrancy, begin with how the Ethereum Virtual Machine handles external contract calls.

When Contract A calls a function on Contract B, execution does not return to Contract A until Contract B's function completes entirely. During Contract B's execution, Contract A's state is in a partially updated condition — some operations may have completed, others may not yet have executed. Contract A's code is paused at the point of the external call, waiting.

If Contract B is controlled by an attacker, the attacker's contract can — during its own execution, while Contract A is paused — call back into Contract A. This is the reentrant call. Contract A is now executing again before its first execution has completed. If Contract A has not yet updated its internal state to reflect the first call's effects, the second call sees the same pre-update state. The attacker has entered the function twice, but the state reflects only one entry.

The sequence:

```
1. User calls Contract A: withdraw(100 ETH)
2. Contract A checks: user.balance >= 100 ETH ✓
3. Contract A sends 100 ETH to user's contract
4. User's contract receives ETH → triggers fallback → calls Contract A: withdraw(100 ETH) again
5. Contract A checks: user.balance >= 100 ETH ✓  (balance not yet updated)
6. Contract A sends another 100 ETH
7. This repeats until the contract is drained
8. Eventually, Contract A updates user.balance = 0
   (too late — the ETH is already gone)
```

The vulnerability exists because the balance update — step 8 — happens after the external call — step 3. The state and the reality are out of sync during the window in which the external call executes. The attacker's contract exploits that window recursively.

---

## The DAO Hack: Reentrancy at Scale

The 2016 DAO was a decentralized investment vehicle that held approximately 3.6 million ETH — then worth around $60 million, now worth several billion — when a reentrancy vulnerability in its `splitDAO` function was exploited.

The vulnerable pattern:

solidity

```solidity
function withdrawBalance() public {
    uint amountToWithdraw = userBalance[msg.sender];
    // External call made BEFORE balance update
    (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
    require(success);
    // Balance updated AFTER the call — too late
    userBalance[msg.sender] = 0;
}
```

The attacker deployed a contract with a fallback function that called `withdrawBalance()` recursively. Each reentrant call found `userBalance[msg.sender]` unchanged — because the update at the bottom of the function had not yet executed — and approved another withdrawal. The loop continued until the attacker had drained the target amount.

The Ethereum community's response — a hard fork to return the funds — remains one of the most contested decisions in blockchain history. It demonstrated that the Ethereum network could, under sufficient social consensus, reverse transactions. It also demonstrated what the consequences of reentrancy at scale looked like: $60 million extracted, a network split into Ethereum and Ethereum Classic, and years of reputational damage to the ecosystem.

The vulnerability itself was not novel. It was known before the DAO launched. The DAO's code had been reviewed. The specific pattern — external call before state update — was documented in early Solidity security literature. The DAO was exploited not because reentrancy was unknown, but because the pattern that produces it was present in the deployed code and the review did not catch it.

---

## Reentrancy After the DAO: The Pattern Persists

The DAO hack produced extensive documentation of reentrancy as a vulnerability class. It became the first entry in every Solidity security guide. Audit firms added it to their standard checklist. Developers studied it. OpenZeppelin published `ReentrancyGuard`, a utility contract that prevents reentrant calls with a simple mutex lock.

The pattern persisted anyway.

- **Lendf.Me (2020):** $25 million drained through a reentrancy interaction between the lending protocol and ERC-777 token callbacks — a variant that doesn't involve a simple ETH send but exploits the ERC-777 token standard's transfer hooks.
- **Cream Finance (2021):** Multiple exploits across the year, several involving reentrancy variants in flash loan integration code, totaling over $130 million in losses.
- **Reentrancy cross-function variants (recurring):** Protocols that correctly protect individual functions with `ReentrancyGuard` but share mutable state across functions that can be called in sequence during a single transaction — allowing an attacker to exploit the state inconsistency between two "protected" functions.

The persistence of reentrancy despite universal awareness of the pattern reflects two properties of smart contract development that do not disappear with education:

**State complexity introduces unforeseen interaction paths.** A simple withdrawal function is easy to audit for reentrancy. A complex DeFi protocol with multiple interacting contracts, flash loan capabilities, ERC-20 callback hooks, and cross-function state dependencies creates an exponentially larger surface area. The specific path an attacker will use may not be visible to an auditor reviewing each function in isolation.

**Pressure to ship compresses review depth.** Reentrancy requires sustained attention during code review — tracing execution paths through external calls, across function boundaries, into token callbacks. In practice, this attention is often insufficient, particularly for code modified close to deployment.

---

## The Checks-Effects-Interactions Pattern

The canonical defense against reentrancy is the Checks-Effects-Interactions (CEI) pattern. It is a code organization discipline that ensures the sequence of operations within any function prevents state inconsistencies during external call windows.

The three stages:

**Checks:** All validation logic executes first. Require statements, condition checks, balance verifications. If any check fails, the function reverts before any state has changed and before any external call has been made.

**Effects:** All state updates execute before any external call. The contract's internal accounting reflects the post-transaction state before control leaves the contract.

**Interactions:** External calls execute last, after all state has been updated.

The corrected withdrawal function:

solidity

```solidity
function withdrawBalance() public {
    // CHECKS
    uint amountToWithdraw = userBalance[msg.sender];
    require(amountToWithdraw > 0, "Nothing to withdraw");

    // EFFECTS — state updated BEFORE external call
    userBalance[msg.sender] = 0;

    // INTERACTIONS — external call made AFTER state update
    (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
    require(success);
}
```

When the attacker's fallback function calls `withdrawBalance()` again, `userBalance[msg.sender]` is already zero. The `require(amountToWithdraw > 0)` check fails. The reentrant call reverts. The loop cannot continue.

The CEI pattern is not a library. It is not a modifier. It is a discipline — a sequencing requirement applied at the time of writing each function. It requires the developer to think explicitly about the order of operations and to ensure that every external call occurs after every state update that the function is responsible for.

This makes it robust when applied correctly and invisible when not. There is no compiler warning for a CEI violation. There is no static analysis tool that catches every possible reentrancy path in a complex protocol. The pattern must be understood and applied deliberately.

---

## How 0xKeep's Architecture Addresses Reentrancy

The `ZeroXKeepLocker` contract applies the Checks-Effects-Interactions pattern throughout its codebase. The `withdrawLock` and `claimVesting` functions implement it explicitly: require statements on lock owner identity and unlock timestamp execute first, internal state is updated before any token transfer, and `SafeERC20.safeTransfer()` executes as the final operation — after all state changes are complete.

But the CEI pattern, while necessary, is not the complete security property. The complete property requires that the pattern not only be applied in the current code but that it remain applied in all future code — which requires that there be no future code.

This is where immutability becomes the architectural completion of the reentrancy defense.

A CEI-compliant contract that can be upgraded is a contract whose reentrancy protection is valid until the next upgrade. If a developer pushes an upgrade that introduces a new withdrawal function, a new token interaction, or a modified release pathway, that new code may or may not apply the CEI pattern correctly. The protection from the previous version does not carry forward automatically. Each upgrade is a new deployment event, with a new audit requirement, and a new opportunity for the pattern to be violated.

An immutable contract that applies the CEI pattern deploys it once. The protection cannot be removed because the code cannot be changed. The release function that applies CEI at block 1 applies CEI at block 10,000,000. There is no upgrade pathway through which a non-CEI-compliant version could be introduced.

The combination of CEI pattern and immutability produces a property that neither alone provides: **permanent, verifiable reentrancy protection** for the lifetime of the contract.

---

## The ERC-20 Token Transfer Case

0xKeep locks and vests ERC-20 tokens rather than native ETH. This is relevant to the reentrancy analysis because ERC-20 token transfers do not trigger fallback functions in the same way ETH sends do — eliminating the simplest reentrancy vector.

A standard ERC-20 `transfer()` call does not send ETH. It does not invoke the recipient's receive or fallback function. The transfer executes entirely within the ERC-20 contract's code, and control returns to the calling contract when the transfer is complete.

However, ERC-777 tokens — a more advanced token standard that includes transfer hooks — can call arbitrary code in the recipient's contract during a transfer. An ERC-777 token transfer to a malicious contract triggers that contract's `tokensReceived()` hook, which can then call back into the releasing contract — a cross-standard reentrancy path of exactly the type that produced the Lendf.Me exploit.

0xKeep's architecture addresses this through the CEI pattern's application to token transfers: the internal accounting state is updated before the transfer is executed, regardless of whether the transferred token implements ERC-20 or ERC-777 semantics. If a reentrant call through an ERC-777 hook attempts to re-enter the release function, the already-updated claimed amount prevents a second release.

The protection covers both token standards because it is applied at the state update level, not at the token standard detection level. No assumption is made about the token's callback behavior. The state is correct before the transfer regardless of what the transfer triggers.

---

## Reentrancy and the Pass-Through Revenue Model

0xKeep's contract architecture has a property that eliminates an entire category of reentrancy risk at the design level: **the contract holds zero ETH in treasury.**

Protocols that accumulate fees, hold reserves, or maintain treasury balances within the contract create concentrated targets. A reentrancy exploit against a contract holding $10,000,000 in ETH can drain up to $10,000,000 in a single transaction sequence. The larger the contract's balance, the larger the potential loss from a reentrancy exploit.

0xKeep's fee model routes ETH fees directly to a designated address at the moment of receipt — the contract processes the fee and forwards it immediately rather than accumulating it. The contract's ETH balance is zero after each interaction.

A reentrancy attack against a contract with zero ETH balance has nothing to extract through ETH-based reentrancy paths. The attack vector exists at the code level, but the asset available for extraction through that vector is absent.

This is not a substitute for CEI compliance — the locked ERC-20 tokens are still held by the contract and are a reentrancy target through token transfer hooks. But it eliminates the ETH-based reentrancy attack entirely, reducing the total attack surface that reentrancy protection must cover.

---

## Verification: Reading the Pattern On-Chain

The Checks-Effects-Interactions pattern is verifiable in the deployed contract source code. The verification process follows the same structure as the pattern itself.

Navigate to the 0xKeep contract address on the relevant block explorer and open the verified source code. Locate the release function — the function that transfers locked tokens to the beneficiary. Trace the execution sequence:

1. **Checks:** Identify the require statements. Confirm they execute before any state update. Verify they check beneficiary identity (`msg.sender == beneficiary`), timestamp validity (`block.timestamp >= unlockTime`), and claimed amount (`amount > alreadyClaimed`).
2. **Effects:** Identify the state update. Confirm it executes after all checks and before any external call. The claimed amount or release flag should be updated at this point.
3. **Interactions:** Identify the token transfer call. Confirm it is the last operation in the function. No state updates should follow it.

If the sequence is Checks → Effects → Interactions throughout the function, the CEI pattern is correctly applied. If any state update follows an external call, the function contains a potential reentrancy vulnerability.

This verification is not a substitute for a professional audit. It is the specific check that confirms the pattern is present in the deployed code — and because the contract is immutable, confirmed presence in the deployed code is confirmed presence for the contract's lifetime.

---

## Conclusion

Reentrancy is not a solved problem in DeFi. It is a known problem with a known solution — the Checks-Effects-Interactions pattern — that requires correct application in every function that makes external calls, across every upgrade, in every version of a contract that interacts with external tokens or contracts.

The architectural answer is to apply the pattern correctly and then make the code permanent. A contract that applies CEI and cannot be upgraded has applied CEI for its entire operational lifetime. The protection cannot be removed because the code cannot be changed. The vulnerability class that has produced over $150 million in documented losses cannot be introduced through an upgrade pathway because no upgrade pathway exists.

The DAO hack was in 2016. The same exploit class drained protocols in 2017, 2018, 2019, 2020, 2021, and beyond. The pattern that produces it is known. The pattern that prevents it is known. The architecture that makes the prevention permanent is known.

The question is not whether reentrancy protection exists. It is whether that protection is architecturally locked into place — or whether it is a property of the current code version, subject to revision.

Write the pattern correctly. Deploy it immutably. The exploit class that has persisted for a decade cannot enter through a door that does not exist.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
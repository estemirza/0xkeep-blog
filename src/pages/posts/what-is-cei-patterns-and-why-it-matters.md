---
layout: ../../layouts/PostLayout.astro
title: What Is the Checks-Effects-Interactions Pattern and Why It Matters
date: 2026-03-24
tags:
  - Security
  - Developers
description: A precise technical guide to the Checks-Effects-Interactions pattern — what it is, how it works at the EVM level, where it fails when misapplied, and why it is the foundational defense against reentrancy in smart contract development.
image: https://image2url.com/r2/default/images/1772352007482-216c43e7-e858-481f-ad57-88532c08dd35.jpg
---
The Checks-Effects-Interactions pattern is the most important discipline in Solidity development. It is also among the most inconsistently applied. Its absence is the root cause of the largest recurring exploit class in Ethereum's history — reentrancy — and its presence, correctly implemented, closes that exploit class entirely for the functions it governs.

This article defines the pattern precisely, traces why it works at the execution level, identifies how it fails when partially applied, and establishes what "correctly implemented" actually means in practice.

---

## The Problem It Solves

Smart contracts do not execute in isolation. They call other contracts. Those other contracts may call back.

This is not an edge case. It is the default behavior of any contract that sends ETH or calls an external token's `transfer()` function. The external call transfers execution control to another contract — one whose code may be entirely outside the original developer's control, and one whose behavior may include calling back into the contract that called it.

When a reentrant call occurs, the calling contract is in a partially executed state. Some of its operations have completed. Others have not. If the state that has not yet been updated is the state that determines access rights — a balance, a claimed flag, a release record — then the reentrant call sees the same pre-update state as the original call. It passes the same checks. It executes the same logic. It extracts the same value.

This is the reentrancy exploit. The Checks-Effects-Interactions pattern is the structural prevention.

---

## The Three Stages: Precise Definitions

### Checks

All validation logic executes first, before any state is written and before any external call is made.

Checks are the contract's guard layer. They verify that the caller is authorized, that the conditions for the requested operation are satisfied, and that the operation is within defined parameters. If any check fails, execution reverts immediately. No state has changed. No external call has been made. The contract is in exactly the same state it was in before the function was called.

In Solidity, checks are implemented as `require` statements:

solidity

```solidity
require(msg.sender == lock.owner, "Not lock owner");
require(block.timestamp >= lock.unlockTime, "Lock not expired");
require(!lock.withdrawn, "Already withdrawn");
```

The key property is that checks are read-only. They read state. They do not write it. Their execution has no side effects.

### Effects

All state updates execute after the checks pass and before any external call is made.

Effects are the contract's accounting layer. They update every internal state variable that reflects the operation being performed — balance decrements, flags set, counters incremented, records updated. After the effects stage, the contract's internal state accurately reflects the post-operation reality, even though the external operation — the token transfer, the ETH send — has not yet occurred.

In Solidity, effects are state assignments:

solidity

```solidity
lock.withdrawn = true;
lock.withdrawnAt = block.timestamp;
userWithdrawals[msg.sender] += lock.amount;
```

The critical property is timing: effects execute before interactions. The internal ledger is updated before the external world is notified. If a reentrant call occurs during the subsequent interaction stage, it will find the contract's state already reflecting the completed operation — the flag set, the balance decremented, the record marked. The checks it encounters will fail.

### Interactions

All external calls execute last, after all checks have passed and all state has been updated.

Interactions are the contract's communication layer. They transfer tokens, send ETH, call functions on other contracts, emit events. They produce real-world effects — value moves, state changes propagate outside the contract's own storage.

In Solidity, interactions are external calls:

solidity

```solidity
IERC20(lock.token).safeTransfer(lock.owner, lock.amount);
```

Because interactions execute after effects, the contract's state is already finalized at the point where execution temporarily leaves the contract. A reentrant call during the `safeTransfer` execution finds `lock.withdrawn == true`. The check `require(!lock.withdrawn)` fails. The reentrant call reverts. The exploit cannot proceed.

---

## The Complete Pattern in Code

A `withdrawLock` function correctly implementing the CEI pattern:

solidity

```solidity
function withdrawLock(uint256 _lockId) external nonReentrant {
    LockRecord storage lock = locks[_lockId];

    // CHECKS
    require(msg.sender == lock.owner, "Not lock owner");
    require(block.timestamp >= lock.unlockTime, "Lock not expired");
    require(!lock.withdrawn, "Already withdrawn");

    // EFFECTS
    lock.withdrawn = true;
    lock.withdrawnAt = block.timestamp;

    // INTERACTIONS
    IERC20(lock.token).safeTransfer(lock.owner, lock.amount);

    emit LockWithdrawn(_lockId, lock.owner, lock.amount);
}
```

The same function without CEI — vulnerable to reentrancy:

solidity

```solidity
function withdrawLock(uint256 _lockId) external {
    LockRecord storage lock = locks[_lockId];

    // Checks
    require(msg.sender == lock.owner, "Not lock owner");
    require(block.timestamp >= lock.unlockTime, "Lock not expired");
    require(!lock.withdrawn, "Already withdrawn");

    // INTERACTION BEFORE EFFECT — vulnerable
    IERC20(lock.token).safeTransfer(lock.owner, lock.amount);

    // Effect executes too late
    lock.withdrawn = true;
}
```

In the vulnerable version, `lock.withdrawn` is still `false` when `safeTransfer` executes. If the token contract calls back into `withdrawLock` during the transfer — through an ERC-777 `tokensReceived` hook, through a callback in a non-standard ERC-20 implementation, or through any other re-entry mechanism — it finds `lock.withdrawn == false`, passes the check, and executes another transfer. The loop continues until the lock is drained or gas is exhausted.

In the CEI-compliant version, `lock.withdrawn = true` executes before the transfer. The reentrant call finds the flag set, the check fails, and execution reverts.

---

## Where the Pattern Fails: Misapplication Cases

Knowing the pattern is not the same as applying it correctly. Several common misapplication patterns preserve the appearance of CEI discipline while introducing real reentrancy exposure.

### State Updates After Multiple Interactions

A function that makes several external calls, updating state between each, may apply CEI correctly for the first call and incorrectly for subsequent calls:

solidity

```solidity
function claimRewards() external {
    uint256 reward = pendingRewards[msg.sender];
    require(reward > 0, "No rewards");

    pendingRewards[msg.sender] = 0;         // Effect ✓
    rewardToken.transfer(msg.sender, reward); // Interaction ✓

    uint256 bonus = pendingBonus[msg.sender];
    if (bonus > 0) {
        // Effect AFTER first interaction — state window exists
        // if the rewardToken transfer triggers a re-entry here
        pendingBonus[msg.sender] = 0;
        bonusToken.transfer(msg.sender, bonus);
    }
}
```

The pattern is correctly applied to `pendingRewards` but incorrectly applied to `pendingBonus`. If the `rewardToken.transfer` triggers a reentrant call before `pendingBonus[msg.sender] = 0` executes, the bonus can be claimed multiple times.

The correct structure moves all effects before all interactions:

solidity

```solidity
function claimRewards() external {
    uint256 reward = pendingRewards[msg.sender];
    uint256 bonus = pendingBonus[msg.sender];
    require(reward > 0 || bonus > 0, "Nothing to claim");

    // ALL EFFECTS FIRST
    pendingRewards[msg.sender] = 0;
    pendingBonus[msg.sender] = 0;

    // ALL INTERACTIONS AFTER
    if (reward > 0) rewardToken.transfer(msg.sender, reward);
    if (bonus > 0) bonusToken.transfer(msg.sender, bonus);
}
```

### Cross-Function Reentrancy

CEI applied correctly within a single function does not protect against cross-function reentrancy — an attack that re-enters a different function than the one currently executing.

If two functions share mutable state, and one function makes an external call before the other function's state is updated, an attacker can reenter the second function during the first function's interaction stage and exploit the inconsistency:

solidity

```solidity
// Function A: correctly updates its own state before interacting
function withdraw(uint256 amount) external {
    require(balances[msg.sender] >= amount);
    balances[msg.sender] -= amount;          // Effect ✓
    token.transfer(msg.sender, amount);      // Interaction ✓
}

// Function B: reads the same balances mapping
function borrowAgainstBalance(uint256 amount) external {
    require(balances[msg.sender] >= amount);
    // Issue: if re-entered during withdraw's token.transfer,
    // balances[msg.sender] is already decremented but
    // borrowing capacity hasn't been updated yet
    outstandingLoans[msg.sender] += amount;
    token.transfer(msg.sender, amount);
}
```

An attacker withdrawing through Function A can, during the `token.transfer` callback, call Function B. The `balances` mapping is already updated by Function A's effect. But if Function B has its own state that was not updated — loan limits, collateral records, position sizes — the cross-function reentrant call can exploit that inconsistency.

The protection against cross-function reentrancy is `ReentrancyGuard` — a mutex lock that prevents any function marked `nonReentrant` from being called while another `nonReentrant` function is executing. When properly applied to all state-sensitive functions that share mutable state, it closes the cross-function path.

### Read-Only Reentrancy

A more subtle variant: a function that does not write state but reads state during an external call can be exploited if the state it reads is transiently inconsistent.

This occurs most commonly in protocols that use token or pool prices derived from contract state during a callback window — a window in which the contract's state reflects a partially completed operation. The read-only function returns a value that is technically accurate to the current state but economically incorrect because that state is mid-update.

Read-only reentrancy is a more advanced topic relevant primarily to complex DeFi protocols with oracle or price feed integrations. For lock and vesting contracts with simple release logic, the exposure is negligible. The relevant defense is consistent application of CEI and `nonReentrant` guards across all state-mutating functions.

---

## ReentrancyGuard: The Complementary Defense

The CEI pattern and OpenZeppelin's `ReentrancyGuard` are complementary, not redundant. They address different aspects of the reentrancy threat.

CEI prevents reentrancy by eliminating the state inconsistency that an exploitable reentrant call requires. A correctly CEI-structured function has no window during which a reentrant call could find exploitable state, because all state is updated before any external call is made.

`ReentrancyGuard` prevents reentrancy by making it structurally impossible for any `nonReentrant`-marked function to be called while another is executing. It is a mutex: a lock acquired at the start of the function's execution and released at the end. Any reentrant call to a `nonReentrant` function while the mutex is held will revert immediately, before any checks, effects, or interactions execute.

The two defenses in combination produce defense in depth:

- CEI ensures that even if `ReentrancyGuard` were somehow bypassed, the state is correct before any interaction executes.
- `ReentrancyGuard` ensures that even if a CEI violation were missed in a complex function, the reentrant call cannot execute.

Neither is sufficient alone at scale. A complex protocol that relies only on CEI without `ReentrancyGuard` is exposed to cross-function reentrancy paths that CEI alone cannot close. A protocol that relies only on `ReentrancyGuard` without CEI discipline is exposed to any future modification that introduces a non-guarded function or bypasses the mutex.

Applied together and consistently, they produce a reentrancy defense that is robust against all known variants of the attack class.

---

## Why Immutability Completes the Defense

The CEI pattern and `ReentrancyGuard` protect the code as written. They do not protect against future code that violates them.

An upgradeable contract that correctly implements CEI and `ReentrancyGuard` in its current version has reentrancy protection in its current version. The next upgrade may add a function. That function may be CEI-compliant or it may not be. The developer may apply `nonReentrant` or forget to. The audit for that upgrade may catch the omission or miss it.

Each upgrade event is a new opportunity for the reentrancy defense to be incomplete. The protection is not a property of the architecture — it is a property of the current code, subject to revision.

An immutable contract that correctly implements CEI and `ReentrancyGuard` has those protections permanently. The code cannot be changed. The functions that exist at deployment are the functions that will exist at any future block. A new function that lacks `nonReentrant` cannot be introduced because no new function can be introduced. The CEI compliance of `withdrawLock` and `claimVesting` is not a property of the current version. It is a property of the only version that will ever exist.

This is the architectural completion of the reentrancy defense: pattern discipline applied once, made permanent by deployment without an upgrade mechanism.

---

## Practical Verification

For developers reviewing contracts and for investors verifying security claims, the CEI pattern is readable directly in the source code. The verification process is mechanical.

For each function that makes an external call:

1. Locate all `require` statements. Confirm they appear before any state assignment.
2. Locate all state assignments (`variable = value`, `mapping[key] = value`, `array.push()`). Confirm they appear before any external call.
3. Locate all external calls (`token.transfer()`, `token.safeTransfer()`, `address.call()`, `contract.function()`). Confirm they appear after all state assignments.
4. Check for the `nonReentrant` modifier on the function signature. Confirm it is present.
5. If the function shares state with other functions, confirm those functions are also marked `nonReentrant`.

A function that passes all five checks is correctly defended against the known reentrancy attack classes. A function that fails any check has a potential vulnerability whose exploitability depends on the specific interaction context.

This review does not require deep Solidity expertise. It requires reading the function body in order and verifying the sequence. The pattern is visible. Its absence is equally visible.

---

## Conclusion

The Checks-Effects-Interactions pattern is not a stylistic preference. It is the structural prevention of the exploit class that has produced more documented losses in Ethereum's history than any other single vulnerability type.

Its implementation is precise: all validation before any state write, all state writes before any external call. Any deviation from this sequence — regardless of how minor, regardless of how unlikely the external call is to trigger a callback — creates a window. Windows are attack surfaces. Attack surfaces are exploited.

The pattern is necessary but not alone sufficient. `ReentrancyGuard` closes the cross-function paths that CEI cannot close alone. Immutability makes both defenses permanent, eliminating the future upgrade event as the vector through which a non-compliant function could be introduced.

Three properties. One exploit class. Closed permanently.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
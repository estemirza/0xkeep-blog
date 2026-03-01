---
layout: ../../layouts/PostLayout.astro
title: "How to Lock Liquidity on Arbitrum: A Step-by-Step Guide"
date: 2026-01-22
tags:
  - Guides
  - Developers
description: A step-by-step walkthrough for deploying a verified liquidity lock on Arbitrum using the 0xKeep protocol. No percentage fees. No admin keys. Immutable by design.
image: https://image2url.com/r2/default/images/1772352090906-84694f6a-34f5-4bba-a773-b711250409e8.jpg
---
## Prerequisites

Before proceeding, confirm the following:

- A Web3 wallet (MetaMask, Rabby, or equivalent) connected to the **Arbitrum network**
- A minimum of **0.03 ETH on Arbitrum** to cover the flat protocol fee
- The **contract address** of the LP token or treasury token you intend to lock
- The **wallet address** of the designated lock beneficiary (can be your own)

No token approvals are required prior to starting. The 0xKeep interface handles authorization inline during the lock flow.

---

## Step 1: Connect Your Wallet

Navigate to [app.0x-keep.xyz](https://app.0x-keep.xyz) and select **Connect Wallet** in the top-right corner of the interface.

Once connected, verify the **Network Pill** in the header displays `Arbitrum`. If it does not, switch networks via your wallet provider. The interface will not permit a transaction on an incorrect network.

```
Network verification: Confirm the Network Pill reads "Arbitrum" before proceeding.
Submitting on the wrong network will result in a failed transaction.
```

---

## Step 2: Select "Standard Liquidity Lock"

From the main dashboard, select the **Lock** tab. You will be presented with two product options:

- **Standard Liquidity Lock** — for LP tokens (Uniswap v2/v3, SushiSwap) or project treasury tokens. Full lock until a specified date. _Fee: 0.03 ETH._
- **Linear Vesting** — for team, advisor, or investor allocations with optional cliff periods. _Fee: 0.02 ETH._

For this walkthrough, select **Standard Liquidity Lock**.

---

## Step 3: Enter the Token Contract Address

Paste the contract address of the token you intend to lock into the **Token Address** field. Before proceeding, make sure:

1. The contract is deployed on Arbitrum (not Ethereum mainnet or another L2)
2. The address is checksummed correctly
3. The token contract is a standard ERC-20

---

## Step 4: Configure the Lock Parameters

You will be prompted to fill in three fields:

**Amount** Enter the quantity of tokens to lock. You may lock your full balance or a partial amount. The lock is binary — no withdrawals are permitted before the unlock date under any circumstance.

**Unlock Date** Set the date and time at which the tokens become withdrawable. The duration can be extended after deployment, but it can never be shortened. Choose a date that reflects your project's roadmap commitments with precision.

```
Lock invariant: Once submitted, the unlock date cannot be moved earlier.
Verify both fields before signing.
```

---

## Step 5: Approve the Token Transfer

Click **Approve**. Your wallet will prompt you to sign an ERC-20 `approve()` transaction, authorizing the 0xKeep V11 contract to transfer the specified token amount on your behalf.

This is a standard token approval. Gas on Arbitrum is minimal — typically under $0.01 at normal network conditions.

Wait for the approval transaction to confirm on-chain before proceeding.

---

## Step 6: Submit the Lock Transaction

Once approval is confirmed, the **Lock** button activates. Click it.

Your wallet will present a transaction summary:

- **To:** 0xKeep V11 Contract (Arbitrum)
- **Value:** 0.03 ETH (flat protocol fee)
- **Data:** Encoded lock parameters (token address, amount, unlock timestamp, beneficiary)

Review the parameters, then sign and broadcast the transaction.

Confirmation is typically achieved within 2–5 seconds on Arbitrum under normal network conditions.

---

## Step 7: Verify Your Lock

Upon confirmation, the interface will display your **Lock Record**, including:

| Field              | Detail                                          |
| ------------------ | ----------------------------------------------- |
| **Lock ID**        | Unique on-chain identifier (e.g., `#0xK-A-402`) |
| **Token**          | Resolved name and contract address              |
| **Amount Locked**  | Verified token quantity                         |
| **Unlock Date**    | Exact timestamp                                 |
| **Beneficiary**    | Designated withdrawal address                   |
| **Verified Badge** | Confirmed on-chain status                       |

This record is permanently queryable on-chain. Copy your Lock ID for reference.

You can also transfer the ownership to other designated wallet address. In certain cases, it is also possible to extend the lock duration. Remember, you can only extend, not shorten lock duration. You can access all this features in "Owner Control" section.

```
Owner Control: Only you can transfer ownership of the lock to other wallet. You also have full control to extend lock duration. No admin.
```

---

## Step 8: Embed the Verification Widget (Recommended)

0xKeep provides an HTML embed widget that displays your lock status directly on your project's website. This gives investors real-time, trustless proof of your liquidity lock without requiring them to navigate to a third-party platform.

To implement it, navigate to your Lock Record and select **Get Embed Code**. Copy the generated `<iframe>` snippet and paste it into your project's landing page or documentation site:

html

```html
<iframe
  src="https://app.0x-keep.xyz/embed/lock/[YOUR-LOCK-ID]"
  width="100%"
  height="200"
  frameborder="0">
</iframe>
```

The widget automatically reflects the current lock status, remaining duration, and verified badge in real time.

---

## What Happens Next

The 0xKeep V11 contract is immutable. After your transaction confirms, the following is mathematically guaranteed:

- The locked tokens cannot be moved by any party — including 0xKeep — until the unlock timestamp is reached
- The unlock date cannot be shortened
- No administrative function exists to pause, override, or modify the lock

When the unlock date arrives, the designated beneficiary wallet may call the `withdraw()` function to retrieve the tokens. No further action is required from the project team.

---

## Troubleshooting

**Transaction reverted on the Approve step** Verify your wallet holds sufficient ETH on Arbitrum for gas. Confirm the token contract address is deployed on Arbitrum, not another network.

**Lock button remains inactive after Approve** Wait for the approval transaction to reach finality. On Arbitrum, this is typically 1–2 blocks. Refresh the interface if the state does not update automatically.

**Network latency or RPC errors** The Arbitrum network RPC may be experiencing elevated load. The smart contract remains operational. Attempt the transaction again via a different RPC endpoint, or configure a custom RPC in your wallet provider (e.g., via Alchemy or QuickNode).

**Lock ID not appearing post-confirmation** Query the 0xKeep contract directly via [Arbiscan](https://arbiscan.io) using your wallet address to retrieve your Lock ID. All lock data is stored on-chain and permanently accessible.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
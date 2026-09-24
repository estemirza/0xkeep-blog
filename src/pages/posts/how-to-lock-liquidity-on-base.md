---
layout: ../../layouts/PostLayout.astro
title: "How to Lock Liquidity on Base: Step-by-Step Guide"
date: 2026-09-25
tags:
  - Guides
description: Lock Uniswap v2 or Aerodrome classic LP tokens on Base with 0xKeep. Two transactions, no protocol fee, and a public certificate you can share with holders.
image: https://image2url.com/r2/default/images/1772352067796-8e5718c7-ad96-413b-a1cf-15aad75d1e64.jpg
---
To lock liquidity on Base, you send your LP tokens to a time-lock contract that holds them until a date you choose. With 0xKeep this takes two wallet transactions (authorize, then lock), costs 0 ETH in protocol fees on Base, and ends with a public certificate page that anyone can check.

This guide walks through the exact screens in the app at [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). It covers ERC-20 LP tokens only.

## What you can and can't lock

0xKeep locks standard ERC-20 tokens. On Base that means:

- Uniswap v2 LP tokens. Uniswap lists a v2 factory on Base in its [v2 deployments reference](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/v2-deployments), and every v2 pair is itself an ERC-20 token.
- Aerodrome classic pools, the ones prefixed `vAMM-` (volatile) or `sAMM-` (stable). These mint a fungible LP token per pool ([Metalamp overview of Aerodrome pool types](https://metalamp.io/magazine/article/aerodrome-protocol-how-a-metadex-on-base-blends-uniswap-curve-and-convex)).
- Team or treasury tokens, if you want a plain time lock on a token allocation.

It does not lock NFT liquidity positions. That rules out Uniswap v3 and v4 positions and Aerodrome Slipstream (`CL`) pools, which are concentrated-liquidity positions forked from Uniswap v3. If your liquidity sits in one of those, 0xKeep can't hold it.

Rebasing or elastic-supply tokens are also out. The create page shows a caution box about this, because a balance that changes on its own can leave tokens stuck in the contract. Fee-on-transfer (tax) tokens do work: the contract measures what it actually received and records that amount, not the number you typed.

If you're unsure what an LP token is or why locking it matters, read [What Are LP Tokens and Why Locking Them Signals Commitment](/posts/what-are-lp-tokens-and-why-locking-them-signals-commitment/) first.

## Before you start

You need:

- A wallet (MetaMask, Rabby, Coinbase Wallet or similar) holding the LP tokens on Base.
- A little ETH on Base for gas. The 0xKeep fee on Base is 0 ETH for both locks and vesting. That fee was set when the contract was deployed and the contract has no function to change it.
- The LP token's contract address.

To find the address for a Uniswap v2 position, look up the pair contract for your two tokens: the pair address is the LP token address. For an Aerodrome classic pool, the pool address is the LP token. In both cases you can open your wallet address on [Basescan](https://basescan.org), check the token holdings list, and copy the address of the LP token from there.

One more decision to make up front: the wallet that creates the lock owns it. Only that wallet can extend the lock, transfer it, or withdraw at the end. If you want the lock held by a multisig or a dedicated project wallet, create it from that wallet, or plan to transfer ownership right after.

## Step 1: Connect your wallet

Open [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). If no wallet is connected, the page shows a "Connect Wallet" card instead of the form. Use the **Connect Wallet** button in the top bar and pick your wallet.

If your wallet is on a network 0xKeep doesn't support, you'll see an "Unsupported Network" screen with three buttons: BASE, ARBITRUM and OPTIMISM. Click **BASE** and approve the network switch in your wallet.

## Step 2: Choose Standard Lock

The page title reads "Initialize Protocol", with two tabs underneath:

- Standard Lock keeps tokens fully locked until one date. Nothing can be withdrawn before it.
- Linear Vesting releases tokens gradually over a number of days, with an optional cliff.

For liquidity, pick **Standard Lock**. Vesting is meant for team, advisor and investor allocations. [The Difference Between a Lock and a Vest](/posts/the-difference-between-a-lock-and-a-vest/) covers when to use which.

## Step 3: Confirm the network

Section "1. Network" shows the supported networks as buttons. The one your wallet is connected to is highlighted. Make sure **BASE** is the active one. Clicking a different button asks your wallet to switch.

## Step 4: Enter the token and amount

In section "2. Token Amount":

1. Paste the LP token address into **Token Address**. If the text isn't a valid address, the field turns red and shows "Invalid ERC-20 Address".
2. Type how many tokens to lock into **Amount**. You can lock all of your LP tokens or part of them.

Once the address is valid, the app reads the token's symbol and shows it as "Asset" in the Lock Summary on the right. For Uniswap v2 pairs the symbol is usually `UNI-V2`, and for Aerodrome classic pools it starts with `vAMM-` or `sAMM-`. If the symbol isn't what you expected, stop and re-check the address.

If your wallet holds fewer tokens than you entered, the form shows "Not enough [symbol] in this wallet" and keeps both buttons disabled.

## Step 5: Set the unlock date

Section "3. Duration" has a single date-and-time picker for a Standard Lock. The date must be in the future ("Unlock date must be in the future" appears otherwise), and the contract rejects anything more than 100 years out.

Pick carefully. You can push the unlock date later after the lock exists, but nothing in the contract can move it earlier. Not you, and not the 0xKeep team.

## Step 6: Check the Lock Summary

The right-hand panel repeats what you entered:

| Row | What it shows |
|---|---|
| Asset | Token symbol read from the contract |
| Quantity | The amount you typed |
| Unlock Date | Your chosen date |
| Service Fee | 0 ETH on Base |

The app reads the fee from the contract itself, so on Base it should display 0 ETH. If it shows anything else, check that the active network is Base.

## Step 7: Authorize, then initialize

There are two numbered buttons below the summary.

**1. Authorize** sends a standard ERC-20 `approve` transaction. It lets the 0xKeep contract pull exactly the amount you entered, nothing more. Confirm it in your wallet and wait. When it lands, the button changes to "1. Authorized" with a check mark. If you had already approved enough, it shows "1. Authorized" straight away and you can skip ahead.

**2. Initialize Lock** becomes active after authorization. Clicking it calls `lockToken` with the token address, amount and unlock time. On Base the transaction value is 0 ETH. Confirm in your wallet; the button shows "Signing..." and then "Securing..." while the transaction confirms.

If the wallet rejects or the transaction reverts, the reason appears in red under the buttons.

## Step 8: Open your certificate

After confirmation you land on a "Protocol Secured" screen showing your lock ID. IDs follow a fixed pattern: `0xK`, then `B` for Base and `L` for lock, then the on-chain index. A lock on Base looks like `0xK-BL-12`.

From here you can:

- Click **View Certificate** to open the public Lock Certificate page.
- Click **View Transaction** to see the transaction on Basescan.
- Click **Go to My Vaults** to see all your locks and vesting schedules.

The Lock Certificate shows the status (LOCKED, UNLOCKED or WITHDRAWN), the locked amount, the unlock date, the owner address (labeled "Beneficiary") and the token contract. It also lists what the lock proves and, just as plainly, what it doesn't prove: it says nothing about whether the token has value, and it doesn't stop a team from selling from other unlocked wallets.

## Step 9: Share the proof

Three buttons on the certificate help you show holders the lock:

- Copy Link copies the certificate URL.
- Share on X opens a prefilled post with the lock ID, amount and certificate link.
- Embed copies an `<iframe>` snippet that shows live lock status on your own site. Setup is covered in [How to Use the Embed Widget on Your Landing Page](/posts/how-to-use-embed-widget-on-your-landing-page/).

Developers and bots can also read the lock as JSON, without an API key, at `https://app.0x-keep.xyz/api/lock/<lock ID>`.

## Managing the lock later

The certificate has an "Owner Control" panel. It's blurred and marked "Restricted" for everyone except the connected owner wallet.

- Transfer Ownership hands the lock to another address. This can't be undone, so double-check the address.
- Extend Duration sets a later unlock date. The field rejects any date that isn't later than the current one.
- Withdraw activates once the unlock date has passed. It calls `withdrawLock` and returns the tokens to the owner wallet. After that the status shows WITHDRAWN.

The contract has no admin, owner, pause or upgrade function, so none of these actions can be taken by anyone other than the lock owner.

## Troubleshooting

The Initialize Lock button stays grey. Usually the approval hasn't confirmed yet, the unlock date is in the past, or the wallet doesn't hold enough tokens. The form shows a red message for the last two.

The Asset shows "TOKEN" instead of a symbol. The app couldn't read the token contract on the active network. Most often the address belongs to another chain, or the wallet isn't on Base.

The approval went through but the lock reverted. Check that you still hold the full amount, and that the token isn't rebasing.

## A note on trust

0xKeep's contract has not been audited by an independent third party. An internal review found no critical, high, medium or low issues, and the 91 automated tests are public in the [contract repository](https://github.com/estemirza/0xkeep-contract). The source is verified on Sourcify at `0x048d1326B3b0531A5d043984F4e495285B07af4B` on Base. You can read what the contract can and can't do on the [security page](https://0x-keep.xyz/security.html) before you lock anything.

## Sources

- [Uniswap v2 Deployments, Uniswap Developers](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/v2-deployments) (accessed 2026-09-25)
- [Aerodrome Protocol: How a MetaDEX on Base Blends Uniswap, Curve, and Convex, Metalamp](https://metalamp.io/magazine/article/aerodrome-protocol-how-a-metadex-on-base-blends-uniswap-curve-and-convex) (accessed 2026-09-25)
- [Aerodrome on X, on vAMM/sAMM pools alongside Slipstream](https://x.com/AerodromeFi/status/1783187060905685262)

---
layout: ../../layouts/PostLayout.astro
title: "How to Lock Liquidity on Arbitrum: Step-by-Step Guide"
date: 2026-09-28
tags:
  - Guides
description: Lock Uniswap v2 or Camelot v2 LP tokens on Arbitrum with 0xKeep. Two transactions, a flat 0.03 ETH fee, and a public certificate holders can check.
image: https://image2url.com/r2/default/images/1772352090906-84694f6a-34f5-4bba-a773-b711250409e8.jpg
---
To lock liquidity on Arbitrum, you send your LP tokens to a time-lock contract that holds them until a date you choose. With 0xKeep this takes two wallet transactions (authorize, then lock), costs a flat 0.03 ETH protocol fee on Arbitrum One, and ends with a public certificate page that anyone can check.

This guide follows the actual screens at [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). It covers ERC-20 LP tokens only.

## What you can and can't lock

0xKeep locks standard ERC-20 tokens. On Arbitrum that includes:

- Uniswap v2 LP tokens. Uniswap lists a v2 factory on Arbitrum in its [v2 deployments reference](https://developers.uniswap.org/docs/protocols/v2/deployments), and every v2 pair is itself an ERC-20 token.
- Camelot V2 pools. Camelot describes its [V2 AMM](https://docs.camelot.exchange/protocol/amm-v2) as based on the Uniswap v2 constant-product formula, and depositors receive a fungible LP token for the pool.
- Other Uniswap v2-style pairs, as long as the LP token is a plain ERC-20.
- Team or treasury tokens, if you want a simple time lock on an allocation.

It does not lock NFT liquidity positions. That rules out Uniswap v3 and v4 positions, and Camelot's V3 pools, which run on Algebra, a tick-based concentrated-liquidity design that Camelot's [glossary](https://docs.camelot.exchange/references/glossary) compares to Uniswap v3. If your liquidity sits in one of those, 0xKeep can't hold it.

Rebasing or elastic-supply tokens are also out. The create page shows a caution box about this, because a balance that changes on its own can leave tokens stuck in the contract. Fee-on-transfer (tax) tokens do work: the contract records the amount it actually received, not the number you typed.

If LP tokens are new to you, start with [What Are LP Tokens and Why Locking Them Signals Commitment](/posts/what-are-lp-tokens-and-why-locking-them-signals-commitment/).

## Before you start

You need:

- A wallet (MetaMask, Rabby or similar) holding the LP tokens on Arbitrum One.
- 0.03 ETH on Arbitrum for the lock fee, plus a little more for gas. A vesting schedule costs 0.02 ETH instead. Both fees were set when the contract was deployed, and the contract has no function to change them.
- The LP token's contract address.

For a Uniswap v2 or Camelot V2 position, the pair contract is the LP token, so the pair address is the one you need. The quickest way to find it is to open your wallet address on [Arbiscan](https://arbiscan.io), look at the token holdings list, and copy the LP token's address from there.

Decide one more thing up front: the wallet that creates the lock owns it. Only that wallet can extend the lock, transfer it, or withdraw at the end. If a multisig or a dedicated project wallet should hold the lock, create it from that wallet, or transfer ownership right after.

## Step 1: Connect your wallet

Open [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). Without a connected wallet the page shows a "Connect Wallet" card instead of the form. Use the **Connect Wallet** button in the top bar and pick your wallet.

If your wallet is on a network 0xKeep doesn't support, an "Unsupported Network" screen appears with three buttons: BASE, ARBITRUM and OPTIMISM. Click **ARBITRUM** and approve the switch in your wallet.

## Step 2: Choose Standard Lock

The page title reads "Initialize Protocol", with two tabs below it:

- Standard Lock keeps tokens fully locked until one date. Nothing can be withdrawn before then.
- Linear Vesting releases tokens gradually over a number of days, with an optional cliff.

For liquidity, pick **Standard Lock**. Vesting is for team, advisor and investor allocations, and [The Difference Between a Lock and a Vest](/posts/the-difference-between-a-lock-and-a-vest/) explains when each one fits.

## Step 3: Confirm the network

Section "1. Network" lists the supported networks as buttons, with the one your wallet is on highlighted. Make sure **ARBITRUM** is the active one. Clicking another button asks your wallet to switch.

The same token can exist on several chains, sometimes at the same address and sometimes as a bridged copy. The lock happens on whichever network is active, so confirm it before you paste anything.

## Step 4: Enter the token and amount

In section "2. Token Amount":

1. Paste the LP token address into **Token Address**. If it isn't a valid address, the field turns red and shows "Invalid ERC-20 Address".
2. Type how many tokens to lock into **Amount**. You can lock your whole LP balance or part of it.

With a valid address, the app reads the token's symbol and shows it as "Asset" in the Lock Summary on the right. Uniswap v2 pairs usually report `UNI-V2`. Whatever the DEX, the symbol should look like an LP token for your pair. If it shows the symbol of one of the underlying tokens instead, you pasted the token address rather than the pair address.

If the wallet holds fewer tokens than you entered, the form shows "Not enough [symbol] in this wallet" and both buttons stay disabled.

## Step 5: Set the unlock date

Section "3. Duration" has one date-and-time picker for a Standard Lock. The date must be in the future ("Unlock date must be in the future" appears otherwise), and the contract rejects anything more than 100 years out.

Choose carefully. You can move the unlock date later after the lock exists, but nothing in the contract can move it earlier, for you or for the 0xKeep team.

## Step 6: Check the Lock Summary

The right-hand panel repeats your inputs:

| Row | What it shows |
|---|---|
| Asset | Token symbol read from the contract |
| Quantity | The amount you typed |
| Unlock Date | Your chosen date |
| Service Fee | 0.03 ETH on Arbitrum |

The app reads the fee from the contract on the active network. If Service Fee shows 0 ETH, you're on Base, not Arbitrum. Go back to Step 3.

## Step 7: Authorize, then initialize

Two numbered buttons sit under the summary.

**1. Authorize** sends a standard ERC-20 `approve` transaction that lets the 0xKeep contract pull exactly the amount you entered. Confirm it in your wallet and wait for it to land. The button then changes to "1. Authorized" with a check mark. If you had already approved enough, it shows "1. Authorized" right away.

**2. Initialize Lock** becomes clickable after that. It calls `lockToken` with the token address, amount and unlock time, and sends 0.03 ETH as the transaction value. Your wallet should show that 0.03 ETH before you sign. While the transaction confirms, the button reads "Signing..." and then "Securing...".

If the wallet rejects the request or the transaction reverts, the reason appears in red under the buttons.

## Step 8: Open your certificate

After confirmation you land on a "Protocol Secured" screen with your lock ID. IDs follow a fixed pattern: `0xK`, then `A` for Arbitrum and `L` for lock, then the on-chain index. A lock on Arbitrum looks like `0xK-AL-12`.

From this screen you can:

- Click **View Certificate** to open the public Lock Certificate page.
- Click **View Transaction** to see the transaction on Arbiscan.
- Click **Go to My Vaults** to list all your locks and vesting schedules.

The Lock Certificate shows the status (LOCKED, UNLOCKED or WITHDRAWN), the amount, the unlock date, the owner address (labeled "Beneficiary") and the token contract. It also states what the lock proves and what it doesn't. A lock says nothing about whether the token has value, and it doesn't stop a team from selling tokens held in other, unlocked wallets.

## Step 9: Share the proof

The certificate has three sharing buttons:

- Copy Link copies the certificate URL.
- Share on X opens a prefilled post with the lock ID, amount and certificate link.
- Embed copies an `<iframe>` snippet that shows live lock status on your own site. [How to Use the Embed Widget on Your Landing Page](/posts/how-to-use-embed-widget-on-your-landing-page/) covers setup.

Bots and developers can read the same lock as JSON, with no API key, at `https://app.0x-keep.xyz/api/lock/<lock ID>`.

## Managing the lock later

The certificate page has an "Owner Control" panel. For anyone other than the connected owner wallet it is blurred and marked "Restricted".

- Transfer Ownership hands the lock to another address. This is permanent, so check the address twice.
- Extend Duration sets a later unlock date. Earlier dates are rejected.
- Withdraw becomes available once the unlock date has passed. It calls `withdrawLock` and sends the tokens back to the owner wallet, after which the status reads WITHDRAWN.

The contract has no admin, owner, pause or upgrade function. Nobody other than the lock owner can take any of these actions.

## Troubleshooting

The Initialize Lock button stays grey. Usually the approval hasn't confirmed yet, the unlock date is in the past, or the wallet holds too few tokens. The form shows a red message for the last two.

The Asset shows "TOKEN" instead of a symbol. The app couldn't read the token contract on the active network. The address most likely belongs to another chain, or the wallet isn't on Arbitrum.

The lock reverted with a fee error. The wallet needs at least 0.03 ETH on Arbitrum on top of gas. ETH on Ethereum mainnet or on another L2 doesn't count.

The approval went through but the lock reverted anyway. Check that you still hold the full amount and that the token isn't rebasing.

## A note on trust

0xKeep's contract has not been audited by an independent third party. An internal review found no critical, high, medium or low issues, and the 91 automated tests are public in the [contract repository](https://github.com/estemirza/0xkeep-contract). The source is verified on Sourcify at `0xDC9bFb15C28486590Cbf58F3FEA9ADbEB9B0334c` on Arbitrum One. The [security page](https://0x-keep.xyz/security.html) lists what the contract can and can't do, and it's worth reading before you lock anything.

## Sources

- [Uniswap v2 Deployments, Uniswap Developers](https://developers.uniswap.org/docs/protocols/v2/deployments) (accessed 2026-09-28)
- [AMM V2, Camelot Documentation](https://docs.camelot.exchange/protocol/amm-v2) (accessed 2026-09-28)
- [Glossary (Algebra V1.9, concentrated liquidity), Camelot Documentation](https://docs.camelot.exchange/references/glossary) (accessed 2026-09-28)

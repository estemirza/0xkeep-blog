---
layout: ../../layouts/PostLayout.astro
title: "How to Lock Liquidity on Optimism: Step-by-Step Guide"
seoTitle: "How to Lock Liquidity on Optimism (Step by Step) | 0xKeep"
date: 2026-10-01
tags:
  - Guides
description: "Lock Velodrome basic-pool or Uniswap v2 LP tokens on Optimism with 0xKeep: two transactions, a flat 0.03 ETH fee, and a public lock certificate."
image: https://image2url.com/r2/default/images/1772351964771-3914b7d6-a695-499f-8f55-15a87bf24cee.jpg
---
Locking liquidity on Optimism means moving your LP tokens into a time-lock contract that won't release them before a date you pick. On 0xKeep that is two wallet transactions (authorize, then lock) and a flat 0.03 ETH protocol fee on OP Mainnet, and the result is a public certificate page that holders can check for themselves.

The steps below follow the real screens at [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). They apply to ERC-20 LP tokens only.

## Which Optimism LP tokens you can lock

0xKeep holds standard ERC-20 tokens. On Optimism, the two common cases are:

- Velodrome basic pools. Velodrome's developer docs describe its volatile and stable pools as "mostly compatible with the Uniswap V2 interface", and a deposit into one returns ERC-20 LP tokens ([Velodrome SDK docs](https://github.com/velodrome-finance/docs/blob/main/content/sdk.mdx)). Volatile pools usually carry a `vAMM-` prefix in the token name and stable pools `sAMM-`.
- Uniswap v2 pairs. Uniswap lists a v2 factory on Optimism in its [v2 deployments reference](https://developers.uniswap.org/docs/protocols/v2/deployments), and each v2 pair contract is an ERC-20 LP token.

Other v2-style pairs work too, as long as the LP token is a plain ERC-20. So do team or treasury tokens, if all you want is a time lock on an allocation.

What 0xKeep can't hold: NFT liquidity positions. Velodrome's concentrated pools (Slipstream) mint an ERC-721 token for every deposit, according to the same docs, and Uniswap v3 and v4 positions are NFTs as well. If your liquidity lives in one of those, you need a locker built for NFTs.

Rebasing and elastic-supply tokens are also excluded. The create page shows a caution box about them, since a balance that changes by itself can leave tokens stuck in the contract. Fee-on-transfer (tax) tokens are fine: the contract records what it actually received, not the number you typed.

New to LP tokens? [What Are LP Tokens and Why Locking Them Signals Commitment](/posts/what-are-lp-tokens-and-why-locking-them-signals-commitment/) covers the basics.

## Unstake from the gauge first

This step is specific to Velodrome. Velodrome lets you stake basic-pool LP tokens in the pool's gauge to earn emissions. While they're staked, the gauge contract holds them, not your wallet, so there is nothing for 0xKeep to lock.

Unstake (withdraw from the gauge) in the Velodrome app before you start. Your wallet should then show the LP token balance. Keep in mind that locked LP can't sit in a gauge at the same time, so you give up gauge emissions on the locked portion for as long as the lock runs.

## Before you start

Have these ready:

- A wallet (MetaMask, Rabby or similar) holding the LP tokens on OP Mainnet.
- 0.03 ETH on Optimism for the lock fee, plus a little for gas. A vesting schedule costs 0.02 ETH. Both fees were fixed when the contract was deployed, and no function exists to change them.
- The LP token's contract address.

For Velodrome basic pools and Uniswap v2, the pool (pair) contract is the LP token. The simplest way to find its address is to open your own wallet on [Optimistic Etherscan](https://optimistic.etherscan.io), open the token holdings list, and copy the LP token from there.

Pick the owning wallet before you begin. Whoever creates the lock owns it, and only that wallet can extend it, transfer it or withdraw at the end. If a multisig or a dedicated project wallet should hold the lock, create it from that wallet, or transfer ownership straight after.

## Step 1: Connect your wallet

Go to [app.0x-keep.xyz/create](https://app.0x-keep.xyz/create). With no wallet connected, the page shows a "Connect Wallet" card in place of the form. Click **Connect Wallet** in the top bar and choose your wallet.

If the wallet is on a chain 0xKeep doesn't support, you'll see an "Unsupported Network" screen with three buttons: BASE, ARBITRUM and OPTIMISM. Click **OPTIMISM** and confirm the switch in your wallet.

## Step 2: Pick Standard Lock

Under the "Initialize Protocol" heading there are two tabs:

- Standard Lock holds tokens until a single date, with no partial withdrawals before it.
- Linear Vesting releases tokens bit by bit over a set number of days, with an optional cliff.

Liquidity goes in a **Standard Lock**. Vesting is meant for team, advisor and investor allocations; [The Difference Between a Lock and a Vest](/posts/the-difference-between-a-lock-and-a-vest/) goes through when to use which.

## Step 3: Check the network

Section "1. Network" shows the supported chains as buttons and highlights the one your wallet is on. **OPTIMISM** should be the active one. Clicking a different button asks your wallet to switch.

The lock is created on whichever network is active, so check this before you paste an address.

## Step 4: Enter the LP token and amount

In section "2. Token Amount":

1. Paste the LP token address into **Token Address**. A malformed address turns the field red with the message "Invalid ERC-20 Address".
2. Enter the number of tokens in **Amount**. That can be your full LP balance or part of it.

Once the address is valid, the app reads the token symbol and shows it as "Asset" in the Lock Summary on the right. For a Uniswap v2 pair that is usually `UNI-V2`. For a Velodrome basic pool it should look like an LP token for your pair. If the Asset shows the symbol of one of the two underlying tokens, you pasted a token address instead of the pool address.

When the wallet holds less than the amount entered, the form reads "Not enough [symbol] in this wallet" and both action buttons stay disabled. If that happens with Velodrome LP, the tokens are probably still staked in the gauge.

## Step 5: Set the unlock date

For a Standard Lock, section "3. Duration" has a single date-and-time picker. The date has to be in the future (otherwise you'll see "Unlock date must be in the future"), and the contract rejects anything more than 100 years ahead.

Pick the date with care. The unlock date can be pushed later once the lock exists, but nothing in the contract can pull it earlier, for you or for the 0xKeep team.

## Step 6: Read the Lock Summary

The panel on the right repeats what you entered:

| Row | What it shows |
|---|---|
| Asset | Token symbol read from the contract |
| Quantity | The amount you entered |
| Unlock Date | The date you chose |
| Service Fee | 0.03 ETH on Optimism |

The fee is read from the contract on the active network. A Service Fee of 0 ETH means you're on Base, not Optimism, so go back to Step 3.

## Step 7: Authorize, then initialize

Below the summary are two numbered buttons.

**1. Authorize** sends a standard ERC-20 `approve` that lets the 0xKeep contract pull exactly the amount you entered. Confirm it in your wallet and wait for it to confirm. The button then reads "1. Authorized" with a check mark.

**2. Initialize Lock** unlocks after that. It calls `lockToken` with the token address, amount and unlock time, and sends 0.03 ETH as the transaction value. Check that your wallet shows 0.03 ETH before signing. During confirmation the button reads "Signing..." and then "Securing...".

If you reject the request or the transaction reverts, the reason shows in red under the buttons.

## Step 8: Open the certificate

Once confirmed, a "Protocol Secured" screen shows your lock ID. The format is fixed: `0xK`, then `O` for Optimism and `L` for lock, then the on-chain index. An Optimism lock looks like `0xK-OL-7`.

From there:

- **View Certificate** opens the public Lock Certificate page.
- **View Transaction** opens the transaction on Optimistic Etherscan.
- **Go to My Vaults** lists every lock and vesting schedule your wallet owns.

The certificate shows the status (LOCKED, UNLOCKED or WITHDRAWN), amount, unlock date, owner address (labeled "Beneficiary") and token contract. It also spells out what the lock does and doesn't prove. A lock says nothing about whether a token has value, and it doesn't stop a team from selling tokens held in other, unlocked wallets.

## Step 9: Share the proof

The certificate has three sharing buttons:

- Copy Link copies the certificate URL.
- Share on X opens a prefilled post with the lock ID, amount and certificate link.
- Embed copies an `<iframe>` snippet that shows live lock status on your site. Setup is covered in [How to Use the Embed Widget on Your Landing Page](/posts/how-to-use-embed-widget-on-your-landing-page/).

The same data is available as JSON, with no API key, at `https://app.0x-keep.xyz/api/lock/<lock ID>`.

## Managing the lock afterwards

The certificate page has an "Owner Control" panel. For any wallet other than the owner it is blurred and marked "Restricted".

- Transfer Ownership moves the lock to another address. There is no undo, so check the address twice.
- Extend Duration sets a later unlock date. Earlier dates are rejected.
- Withdraw becomes available after the unlock date. It calls `withdrawLock` and returns the tokens to the owner wallet, and the status changes to WITHDRAWN.

The contract has no admin, pause or upgrade function, so only the lock owner can do any of this.

## A note on the Aero migration

Crypto Briefing [reports](https://cryptobriefing.com/aero-launches-seven-chains-arbitrum/) that Velodrome and Aerodrome are merging into a single protocol called Aero, scheduled to launch on October 21, 2026, with OP Mainnet among its seven chains. We haven't seen details on what happens to existing basic pools. If you're planning a long lock on Velodrome LP, read Velodrome's own announcements about the migration first. A locked LP token can't be moved to a new pool until the lock ends.

## Troubleshooting

The Initialize Lock button stays grey. Usually the approval hasn't confirmed, the unlock date is in the past, or the wallet holds too few tokens. The last two show a red message on the form.

The Asset shows "TOKEN" instead of a symbol. The app couldn't read the token on the active network. Most likely the address belongs to another chain, or the wallet isn't on Optimism.

The lock reverted with a fee error. The wallet needs at least 0.03 ETH on OP Mainnet on top of gas. ETH on Ethereum mainnet or another L2 doesn't count.

The approval went through, then the lock reverted. Check that you still hold the full amount (and that it isn't staked in a gauge), and that the token isn't rebasing.

## A note on trust

0xKeep's contract has not been audited by an independent third party. An internal review found no critical, high, medium or low issues, and the 91 automated tests are public in the [contract repository](https://github.com/estemirza/0xkeep-contract). The source is verified on Sourcify at `0x1Ecf87D69c4a5c8D10ffb7D73e8ABB415043f866` on OP Mainnet. Read the [security page](https://0x-keep.xyz/security.html) for what the contract can and can't do before you lock anything.

## Sources

- [Velodrome SDK documentation (basic pools, concentrated pools, gauges), velodrome-finance/docs on GitHub](https://github.com/velodrome-finance/docs/blob/main/content/sdk.mdx) (accessed 2026-10-01)
- [Uniswap v2 Deployments, Uniswap Developers](https://developers.uniswap.org/docs/protocols/v2/deployments) (accessed 2026-10-01)
- [Aero launches October 21, 2026, with seven chains including Arbitrum and Robinhood Chain, Crypto Briefing](https://cryptobriefing.com/aero-launches-seven-chains-arbitrum/) (Sep 25, 2026)

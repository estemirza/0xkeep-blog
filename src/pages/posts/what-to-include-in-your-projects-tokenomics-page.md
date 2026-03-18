---
layout: ../../layouts/PostLayout.astro
title: What to Include in Your Project's Tokenomics Page to Satisfy On-Chain Due Diligence
date: 2026-03-19
tags:
  - Guides
  - Developers
description: A precise framework for what a credible tokenomics page must contain — not for marketing optics, but to satisfy the verification requirements of investors and analysts who read contracts, not copy.
image: https://image2url.com/r2/default/images/1772352392047-e21f9c87-acd3-479c-84a6-430d8c977e90.jpg
---
Most tokenomics pages are written for optics. They contain a pie chart, a table of allocation categories, a vesting schedule described in prose, and a paragraph about the token's utility. They are designed to look complete. They are not designed to be verified.

The gap between a tokenomics page that looks complete and one that is actually verifiable is the gap between a project that is asking investors to trust its word and a project that is asking investors to read its contracts. These are different requests with different risk profiles, and sophisticated investors distinguish between them.

This article defines what a tokenomics page must contain to satisfy on-chain due diligence — not what it should include for marketing purposes, but what it must include for an investor who opens a block explorer alongside your documentation to confirm every claim independently.

---

## The Standard That Matters

The relevant audience for a credible tokenomics page is not the retail investor who reads the pie chart and moves on. It is the analyst, the fund, the community researcher, and the experienced individual investor who will attempt to verify your claims before committing capital.

This audience asks a specific set of questions:

- Does the supply distribution match what the token contract actually shows?
- Are the vesting schedules enforced on-chain or described in a document?
- Are LP tokens locked in a contract with no admin override?
- Can I verify the unlock dates from a block explorer without contacting the team?
- Does any address hold tokens in a quantity inconsistent with the stated distribution?

A tokenomics page that cannot answer all of these questions from its own content — with contract addresses, on-chain verification links, and precise parameter disclosures — has not satisfied due diligence. It has produced marketing material that resembles due diligence.

The distinction is operational. Investors who cannot verify a claim from your tokenomics page will either skip verification entirely — accepting the risk — or skip the investment entirely. Neither outcome serves the project.

---

## Section 1: Token Contract Address and Supply Verification

Every tokenomics page must begin with a verifiable anchor: the token contract address, linked directly to its block explorer entry, on every chain where the token is deployed.

**Required disclosures:**

- Token contract address (with block explorer link) for each deployed chain
- Total supply as defined in the contract (`totalSupply()`)
- Whether the supply is fixed or mintable
- If mintable: the address or mechanism that controls minting, and whether that capability has been renounced

This is the foundation against which every subsequent claim is verified. If the stated total supply does not match `totalSupply()` on the block explorer, every allocation percentage derived from it is wrong. If the supply is mintable and that fact is not disclosed, the entire distribution table is contingent on a future decision the team controls.

**What to show:**

```
Token Contract (Base):   0x[address] → [basescan link]
Token Contract (Arbitrum): 0x[address] → [arbiscan link]
Total Supply:            1,000,000,000 TOKEN
Supply Type:             Fixed — mint function renounced at deployment
```

Provide the `totalSupply()` figure as it appears on-chain, in token units. Do not round. If there is a discrepancy between the documented figure and the on-chain figure due to decimal handling or display conventions, explain it explicitly.

---

## Section 2: Distribution Table with Wallet Address Disclosure

The allocation table — team, investors, treasury, liquidity, ecosystem, community — is the core of any tokenomics page. For it to satisfy due diligence, each line must be traceable to an on-chain address.

**Required disclosures per allocation category:**

- Allocation percentage and token quantity (in absolute units, not just percentage)
- The wallet address holding or receiving that allocation
- Whether the allocation is currently liquid, locked, or vesting
- If locked or vesting: the contract address enforcing the constraint

A table that lists "Team: 15%" without a corresponding wallet address is unverifiable. An investor cannot confirm that 15% of supply is actually in a wallet attributable to the team rather than already in circulation. They cannot confirm that the wallet is subject to any lock or vest. They cannot confirm that additional wallets controlled by team members do not hold additional supply outside the disclosed allocation.

**What to show:**

|Allocation|%|Tokens|Wallet|Status|Contract|
|---|---|---|---|---|---|
|Team|15%|150,000,000|0x[addr]|Vesting|0x[vest contract]|
|Seed Investors|10%|100,000,000|0x[addr]|Vesting|0x[vest contract]|
|Treasury|20%|200,000,000|0x[addr]|Locked|0x[lock contract]|
|Liquidity Pool|30%|300,000,000|[Pool address]|Locked|0x[lock contract]|
|Ecosystem|25%|250,000,000|0x[addr]|Unlocked|—|

Every address in this table should be linked to its block explorer entry. An investor should be able to click any address and confirm the token balance matches the stated allocation.

---

## Section 3: Liquidity Lock Disclosure

LP token lock parameters are the highest-priority verification item for investors entering a position through the open market. They are also among the most frequently misrepresented or underspecified items in tokenomics documentation.

**Required disclosures:**

- LP token contract address (the Uniswap/equivalent pair address)
- Total LP tokens in existence (`totalSupply()` of the LP token contract)
- LP tokens locked (absolute quantity and percentage of total LP supply)
- Lock contract address (linked to block explorer)
- Unlock timestamp (in UTC, derived from the on-chain value — not stated from memory)
- Whether the lock contract has admin override functions (and confirmation that it does not, with contract link to verify)

**What to show:**

```
Liquidity Pool:    TOKEN/ETH on Uniswap V2 (Base)
Pool Address:      0x[pair address] → [basescan link]
LP Token Supply:   [exact figure from totalSupply()]
LP Tokens Locked:  [exact figure] ([percentage]% of total LP supply)
Lock Contract:     0x[lock contract] → [basescan link]
Unlock Date:       YYYY-MM-DD HH:MM UTC (Unix: [timestamp])
Admin Override:    None — immutable contract, zero admin keys
                   Verify: [direct link to contract source]
```

The unlock date must be derived from the on-chain timestamp, not stated from memory or documentation. Provide the Unix timestamp alongside the human-readable date so investors can verify the conversion independently.

The admin override disclosure is not optional. Its absence is the signal that the question has not been considered. Its presence — confirmed with a direct link to the contract source — is the signal that the team has built the commitment to be verified.

---

## Section 4: Vesting Schedule Disclosure

Vesting schedules documented in prose are not vesting schedules. They are descriptions of intended behavior. The on-chain contract is the vesting schedule.

**Required disclosures per vested allocation:**

- Beneficiary address (or category if multiple beneficiaries share a structure)
- Vesting contract address (linked to block explorer)
- Total allocation under this contract
- Cliff duration and cliff end date (UTC, derived from on-chain timestamp)
- Total vesting duration and vesting end date (UTC, derived from on-chain timestamp)
- Daily or monthly unlock rate post-cliff
- Whether ownership is transferable and whether that capability has been used

**What to show:**

```
Team Vesting (Founder A):
  Beneficiary:      0x[address]
  Contract:         0x[vesting contract] → [basescan link]
  Total Allocation: 75,000,000 TOKEN
  Cliff:            180 days → ends YYYY-MM-DD (Unix: [timestamp])
  Vesting End:      YYYY-MM-DD (Unix: [timestamp])
  Daily Unlock:     ~[X] TOKEN/day post-cliff
  Transferable:     Yes — current owner: 0x[beneficiary address]
```

Repeat this block for every distinct vesting contract. If multiple beneficiaries share identical parameters deployed from the same template, group them clearly and link each individual contract.

The cliff and vesting end dates must be derived from the `cliff()` and `end()` state variables in the vesting contract — not from the deployment date plus a stated duration. These are different values whenever the deployment date does not match the stated schedule start, which is common in practice.

---

## Section 5: Treasury and Reserve Disclosure

Treasury allocations are frequently the least precisely documented category in tokenomics pages. "20% for ecosystem development" describes an intention, not a constraint. An investor cannot verify that the treasury will be used as stated because there is no on-chain mechanism enforcing the use case.

What can be disclosed and verified is the constraint on access — whether the treasury is locked, when it unlocks, and whether the wallet controlling it has any other token holdings inconsistent with the stated allocation.

**Required disclosures:**

- Treasury wallet address (linked to block explorer)
- Current token balance (should match stated allocation)
- Whether treasury tokens are locked, and if so: lock contract address and unlock date
- Whether the treasury wallet has any other significant token holdings or transaction history inconsistent with a treasury function
- Multisig configuration if applicable: threshold, signer count, and whether signers are disclosed

**What to show:**

```
Treasury:
  Wallet:         0x[address] → [basescan link]
  Current Balance: [exact figure] TOKEN
  Lock Status:    Locked until YYYY-MM-DD
  Lock Contract:  0x[lock contract] → [basescan link]
  Control:        2-of-3 multisig — signers: [disclosed or stated as undisclosed]
```

A treasury wallet that has executed outbound token transfers should have those transactions explained. An investor who opens the wallet on a block explorer and sees undocumented outflows has a due diligence problem. Explaining those transactions proactively — in the tokenomics page, with transaction hashes — is the correct approach.

---

## Section 6: Circulating Supply at Launch

Circulating supply is among the most manipulated figures in DeFi tokenomics. It is frequently defined to exclude allocations whose unlock timeline is inconvenient for the implied market cap calculation, and it changes rapidly in the days following launch as early allocations vest or unlock.

A credible tokenomics page defines circulating supply precisely at the time of publication, with the methodology used to calculate it, and discloses the scheduled supply expansion events that will change it.

**Required disclosures:**

- Circulating supply at launch (in absolute tokens)
- Methodology: which allocation categories are included and which are excluded, and why
- Supply expansion schedule: dates and quantities of each scheduled unlock or cliff expiry that will increase circulating supply in the next 12 months
- Fully diluted valuation basis (total supply, not circulating supply)

**What to show:**

```
At Launch:
  Circulating Supply:   [figure] TOKEN ([percentage]% of total)
  Excluded from circ.:  Team (vesting), Investors (vesting), Treasury (locked)

Supply Expansion Schedule (next 12 months):
  YYYY-MM-DD:  +[X] TOKEN — Seed investor cliff expiry
  YYYY-MM-DD:  +[X] TOKEN/month — Team linear vest begins
  YYYY-MM-DD:  +[X] TOKEN — Treasury lock expiry
```

This schedule is derivable entirely from the on-chain timestamps in the lock and vesting contracts. It should not require the team to calculate it — it should be a direct read of the contract parameters. If the team cannot produce this schedule from their own contracts, that is a due diligence signal in itself.

---

## Section 7: Verification Instructions

The most underutilized element of a tokenomics page is a direct verification guide — a set of explicit instructions that walk an investor through the steps required to confirm every material claim independently.

This section serves a dual purpose. It demonstrates that the team has verified their own claims against the contracts. And it lowers the friction cost of independent verification, increasing the probability that investors will actually perform it.

**What to include:**

For each verifiable claim, provide:

1. The contract address
2. The specific function or state variable to read
3. The expected output
4. A direct block explorer link to the "Read Contract" interface

**Example format:**

```
To verify the LP lock unlock date:
  Contract:  0x[lock contract]
  Function:  unlockTime()
  Expected:  [Unix timestamp] = YYYY-MM-DD HH:MM UTC
  Link:      [direct Read Contract link]

To verify team cliff expiry:
  Contract:  0x[vesting contract]
  Function:  cliff()
  Expected:  [Unix timestamp] = YYYY-MM-DD HH:MM UTC
  Link:      [direct Read Contract link]

To verify zero admin access on lock contract:
  Contract:  0x[lock contract]
  Action:    Review source code for owner(), onlyOwner modifier, pause(), emergencyWithdraw()
  Expected:  None present
  Link:      [direct source code link]
```

A tokenomics page that includes this section is stating, in operational terms: everything written here can be checked. That is a different category of claim from a tokenomics page that omits it.

---

## What to Avoid

Several common tokenomics page elements actively degrade the quality of the on-chain due diligence signal.

**Vague vesting language.** "Team tokens are locked for 12 months with a 2-year linear vest" is a description, not a disclosure. It does not specify the contract address, the cliff timestamp, the vesting end timestamp, or whether the schedule is actually enforced on-chain. Replace prose descriptions with contract addresses and function outputs.

**Percentage-only allocations.** "15% team" without an absolute token quantity and a wallet address is unverifiable. An investor cannot confirm that 15% of the on-chain supply is in any particular wallet without knowing the wallet address.

**Self-reported circulating supply without methodology.** A circulating supply figure without the calculation methodology is an assertion. The methodology converts it into a verifiable claim.

**"Locked" without a contract address.** The word "locked" appearing without a corresponding contract address is a statement of intent, not a verifiable constraint. Locked in what? By what mechanism? Until when? Controlled by whom? Each of these questions has an on-chain answer that should be provided.

**Out-of-date tokenomics pages.** A tokenomics page published at launch that has not been updated to reflect vesting cliff expiries, lock extensions, treasury deployments, or supply changes is misleading by omission. It describes a past state as though it were the current state. Version the document or include a last-updated date, and update it when material parameters change.

---

## The Due Diligence Standard as a Commitment Signal

A tokenomics page built to satisfy on-chain due diligence is not just documentation. It is a signal about how the project was built.

A team that publishes contract addresses, on-chain timestamps, wallet addresses, and verification instructions for every material claim has demonstrated that they designed their token distribution to be verifiable — which requires that they actually deployed on-chain locks and vesting contracts rather than described them in prose. The documentation follows from the architecture.

A team that publishes a pie chart and a vesting table without contract addresses has demonstrated the inverse: either they have not deployed on-chain enforcement mechanisms, or they have deployed them and chosen not to disclose them. Neither is a credible position.

Investors who understand on-chain verification read tokenomics pages for the contract addresses, not the narrative. The narrative cannot be verified. The contracts can.

Build the architecture first. The tokenomics page that satisfies due diligence is the one that accurately describes what the contracts already enforce.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
---
layout: ../../layouts/PostLayout.astro
title: A Government Published a Seed Phrase. $4.8M Was Gone in Hours.
date: 2026-03-05
tags:
  - News
  - Security
  - Cases
description: On February 26, South Korea's National Tax Service published an unredacted photo of a seized Ledger wallet and its handwritten recovery mnemonic. An attacker drained 4 million PRTG tokens within hours. The incident is not a crypto failure — it is a custody failure. And it has direct implications for how any institution handles digital asset keys.
image: https://image2url.com/r2/default/images/1772352027755-80ac9a0c-ac33-47ba-b803-c707e8ae01f3.jpg
---
On February 26, 2026, South Korea's National Tax Service (NTS) published a press release documenting a successful enforcement campaign against 124 high-value tax delinquents. Among the seized assets: cash, hardware wallets, and digital tokens. To illustrate the scale of the operation, the agency included photographs of the confiscated items.

One photograph showed a Ledger cold wallet. Adjacent to it: a handwritten sheet of paper displaying the wallet's full mnemonic recovery phrase, unredacted, in a publicly accessible government press release.

Within hours, an attacker had deposited a small amount of Ethereum into the exposed wallet to cover gas fees, then executed three transactions — transferring all 4 million PRTG tokens out of the compromised address. Total loss: approximately $4.8 million, or 6.4 billion Korean won.

The NTS has since requested police assistance to recover the stolen crypto and announced plans for an external security review and a full overhaul of its procedures from seizure through the sale of virtual assets. It also issued an apology, stating it had acted "carelessly" by providing a photo without recognizing it contained sensitive details.

---

## The Mechanics of the Loss

A mnemonic phrase — typically 12 to 24 words — is the cryptographic root of a hardware wallet. It is not a password. It is not an access credential that can be rotated or revoked. It is the deterministic seed from which every private key in the wallet is derived. Anyone who possesses it possesses the wallet, unconditionally, regardless of whether they have the physical device, the PIN, or any other layer of protection.

Once a mnemonic phrase becomes public, control of the wallet is effectively lost. Blockchain transactions are irreversible, and recovery options are limited.

The attacker required no specialized tooling. They needed only to read the published photograph, import the mnemonic into any compatible wallet application, fund the address with a small amount of ETH for gas, and execute the transfers. The entire operation was, technically, trivial. The vulnerability was not in the blockchain, not in the Ledger device, and not in the token contract. It was in the photograph.

---

## This Is Not a Crypto Problem

Commentary following the incident has focused on cryptocurrency's irreversibility as the root cause of the loss. That framing is inaccurate.

The equivalent failure with physical currency would be photographing cash in an unlocked safe, publishing the photograph with the combination visible in the background, and then expressing surprise when the safe was emptied. The irreversibility of the transaction that followed is a property of blockchain settlement — but the vulnerability that enabled it was an operational security failure at the custody layer, entirely independent of the underlying asset class.

The episode highlights a familiar security rule: a mnemonic printed or photographed in plain view instantly destroys the security of cold storage. The case also exposes gaps in institutional procedures for handling evidence that contains private keys, with immediate questions about chain-of-custody, internal training, and oversight.

The NTS incident is one data point in a broader pattern. In a separate case, police discovered in February 2026 that 22 Bitcoin seized in a 2021 hacking investigation had disappeared from a cold wallet stored in a Gangnam police vault. Investigators later determined that the coins had been moved using a mnemonic phrase that police had never controlled. Two major custody failures from South Korean authorities surfacing in the same month suggests a systemic gap in institutional key management protocols — not isolated human error.

---

## The Institutional Custody Gap

As regulators, tax authorities, and law enforcement agencies increasingly seize and hold digital assets, they are inheriting a class of operational security requirements that traditional evidence-handling procedures are not designed for.

Physical evidence — cash, documents, vehicles — can be secured with existing chain-of-custody frameworks. A hardware wallet looks like physical evidence. It is not. The security of a hardware wallet is entirely dependent on the confidentiality of its seed phrase, and that confidentiality must be maintained regardless of what happens to the device. Unlike a password, the seed phrase cannot be changed after the fact. Unlike a bank account, the balance cannot be frozen once the phrase is known. Unlike seized cash, the asset cannot be recovered once it moves on-chain.

The incident is the country's second major loss of seized crypto, following a 2021 case involving 22 BTC held by police. The pattern suggests that procedure reform, not individual accountability, is the required response.

---

## The Relevance to Protocol Design

The NTS incident is primarily a custody and operational security failure. Its relevance to smart contract protocol design is indirect but real.

Every protocol that relies on administrative key management — upgrade keys, oracle admin roles, governance execution wallets — is exposed to the same category of risk. The key does not need to be photographed in a press release to be compromised. It needs only to exist and to be held by a human organization operating under operational pressure, imperfect procedures, and the full range of social engineering and credential compromise vectors that any institution faces.

The Moonwell oracle incident earlier in February demonstrated what happens when a governance execution key is used to deploy misconfigured code. The NTS incident demonstrates what happens when a key is inadvertently published. The mechanism of exposure differs. The consequence — irreversible loss of assets under management — is structurally identical.

The architectural answer, in both contexts, is the same: minimize the number of keys that exist, minimize the scope of what those keys can do, and where possible, eliminate them entirely. A protocol with no admin key cannot suffer an admin key compromise. A contract with no upgrade mechanism cannot be broken by a misconfigured upgrade.

This is not a novel security principle. It is the principle of least privilege, applied to blockchain infrastructure.

---

## What Institutional Crypto Custody Requires

The NTS incident will likely accelerate formal guidance on government digital asset custody. Several requirements are straightforward:

Hardware wallet seed phrases must never appear in photographs, documents, or any material associated with a public disclosure — at any stage of the evidence handling process. Seed phrases must be treated with at least the same security classification as cryptographic private keys, which means physical isolation, restricted access, and documented chain-of-custody for the paper or device on which they are recorded.

Seized digital assets should be transferred to institutionally controlled wallets immediately upon seizure — with the original device's seed phrase treated as sensitive evidence, not as the ongoing custody mechanism. The asset should be moved; the phrase should be secured separately and never used operationally again.

None of this is technically complex. All of it requires institutional awareness that hardware wallets are not analogous to physical evidence, and that their security model is fundamentally different from anything law enforcement or tax authorities have managed before.

Cho Jae-woo, director of Hansung University's Blockchain Research Institute, stated that "the tax authorities have displayed a basic lack of understanding of how cryptocurrencies work." That assessment is accurate. It is also correctable — and the $4.8 million cost of the NTS's public education on the subject provides sufficient motivation to begin.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
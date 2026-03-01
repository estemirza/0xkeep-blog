---
layout: ../../layouts/PostLayout.astro
title: Security Is Not a Cost Center. The 2025 State-Sponsored Theft Data Makes the Investment Case.
date: 2026-01-16
tags:
  - News
  - Research
  - Security
description: North Korean state-sponsored actors stole $2.02 billion from Web3 in 2025 using AI-enhanced phishing and supply chain attacks. Analysts now frame security-first infrastructure as foundational to long-term investment value. A breakdown of why 0.03 ETH is risk mitigation, not overhead.
image: https://image2url.com/r2/default/images/1772352171016-9c0f30de-2359-4457-8c33-835c45bd1e51.jpg
---
## The Investment Risk Reframe

For most of DeFi's operational history, security infrastructure has been evaluated as a cost. The audit fee. The penetration test. The bug bounty program. The monitoring service. These are line items — expenses that reduce margin without directly contributing to revenue. The decision to spend on security has historically been framed as a tradeoff: how much protection can be purchased for how much operational budget.

The 2025 threat data makes that framing obsolete.

North Korean state-sponsored actors — primarily the Lazarus Group and affiliated operations — stole $2.02 billion from Web3 in 2025 through AI-enhanced phishing campaigns and supply chain breaches. That figure represents a state-level, systematically resourced attack operation targeting crypto infrastructure with the patience, technical capability, and strategic intent of a national intelligence program. The threat environment that produced $2.02 billion in state-sponsored theft in a single year is not one against which conventional security cost-benefit analysis applies.

When the attacker is a nation-state with AI-augmented capabilities and a multi-year operational timeline, the question is not how much security is worth purchasing. It is whether the infrastructure being used was architected to require trust in the first place — and whether that trust can be exploited by an actor with the resources to exploit it.

---

## What AI-Enhanced Phishing and Supply Chain Attacks Target

The 2025 state-sponsored theft profile is characterized by two primary attack vectors that are worth understanding precisely, because they define the threat model that security-first infrastructure is designed to address.

**AI-enhanced phishing** uses large language models and generative AI to produce social engineering attacks at a quality and scale that was not previously achievable. Spear-phishing messages that previously required hours of manual research per target can now be generated in seconds with the contextual accuracy of a personally researched approach. Deepfake video calls impersonating colleagues, legal counsel, or counterparties have been used to authorize wire transfers and key signings. The human layer — the people who control admin keys, sign multi-sig transactions, and approve smart contract deployments — is being targeted with attacks that are qualitatively more convincing than the phishing infrastructure of previous years.

The attack surface here is the human. More specifically, it is the gap between the human and the assets they control. The larger that gap — the more assets accessible through a single human authorization decision — the higher the return on a successful phishing operation targeting that human.

**Supply chain breaches** target the development and deployment infrastructure of Web3 projects: the developer environments, the CI/CD pipelines, the dependency packages, the wallet software used to sign deployment transactions. A supply chain compromise that inserts malicious code into a widely-used development library can affect every project that imports that library — a force-multiplication approach that scales the attack return with the library's adoption rather than the attacker's direct effort.

Both vectors share a structural observation: they target the trust that protocols place in humans and human-controlled systems at the point where those humans have privileged access to protocol functions. The attack is not against the cryptography. It is against the organizational layer that the cryptography trusts.

---

## The Structural Exposure Map

The $2.02 billion in 2025 state-sponsored theft flowed through protocols with a specific architectural property in common: they had human-controlled access surfaces large enough to make the attack economically rational.

State-sponsored actors do not expend AI-enhanced phishing operations and supply chain breach infrastructure against $50,000 targets. The operational cost of the attack class requires correspondingly large expected returns to be rational. The targets that experienced $2.02 billion in aggregate losses were the ones with admin keys governing large asset pools, multi-sig structures controlling significant treasury positions, or governance mechanisms capable of redirecting hundreds of millions in protocol value.

Map the 2025 state-sponsored loss figure against the architectural properties of the affected protocols and the pattern is the same one that appears in every attack class analysis: the losses concentrate in protocols with high-value human-controlled access surfaces. The attack capability was deployed where the return justified it.

This is the investment risk framing that analysts are now applying to Web3 infrastructure selection: protocols with large human-controlled access surfaces are not only security risks — they are systemic investment risks, because the probability of material loss from state-level attack operations is non-trivially correlated with the value accessible through the attack vectors those operations employ.

---

## The 0.03 ETH Decision in Risk-Adjusted Terms

The conventional evaluation of a liquidity lock fee is simple arithmetic: 0.03 ETH to secure a liquidity position. At current valuations, that is a small absolute number. The relevant question is not whether the absolute number is large or small. It is what the 0.03 ETH purchases in terms of risk-adjusted value preservation.

A project that launches without locking liquidity retains full discretionary control over its LP tokens. That control is an asset — the flexibility to adjust, withdraw, or redeploy the liquidity as operational conditions change. It is also a liability: that same control is accessible to anyone who can compromise the wallet holding the LP tokens, socially engineer the person controlling that wallet, or introduce malicious code into the development environment used to manage it.

In a threat environment where state-sponsored actors spent 2025 deploying AI-enhanced phishing and supply chain breaches against exactly this category of target — developer wallets with high-value authorized access — the liability component of that control is not theoretical. It is the operational profile of the threat environment the project is launching into.

The 0.03 ETH transfers the LP tokens to an immutable contract. After that transfer, the LP tokens are inaccessible to any wallet, including the deployer's. A phishing attack that compromises the deployer's private key after the lock is in place finds no LP token balance to drain. A supply chain breach that introduces malicious code into the project's deployment environment after the lock is executed has no authorized access path to the locked assets. The attack vectors that produced $2.02 billion in state-sponsored theft in 2025 cannot reach an asset that has been placed beyond any wallet's control.

This is not an argument that 0.03 ETH purchases comprehensive security. It is an argument that 0.03 ETH purchases the elimination of the attack surface through which the most sophisticated, best-resourced, and highest-return threat actors in the 2025 ecosystem operated. The fee is not overhead. It is the cost of removing the target.

---

## Security-First Infrastructure as Investment Thesis

Analysts arguing that security-first infrastructure is now foundational to long-term investment value preservation in Web3 are making a claim with a specific technical basis: that the expected loss from insecure infrastructure, priced correctly against the threat environment, exceeds the cost of secure infrastructure by a significant margin.

The arithmetic is not complicated. A project with $1 million in liquidity, no lock, and an admin key controlling that liquidity, operating in a threat environment where state-sponsored actors stole $2.02 billion through admin-key-targeting attack vectors in the previous year, is carrying an unpriced risk. The probability of that specific project being targeted is low. The expected loss from that probability is not zero — and in an environment where the attack is AI-automated, the targeting cost per project is declining while the attack volume is increasing.

The investor evaluating that project is exposed to a loss scenario — a complete liquidity drain through admin key compromise — that is not reflected in any conventional financial metric but is directly addressable through on-chain lock infrastructure at a fixed, flat cost.

Security-first infrastructure selection is the application of this arithmetic to portfolio construction: preferring projects whose architecture eliminates the attack surfaces that state-level threat actors exploited in 2025, because those projects are not carrying the unpriced expected loss that their insecure counterparts are.

The investment thesis does not require believing that every project without a liquidity lock will be compromised. It requires believing that the expected value of eliminating the attack surface — across a portfolio of projects, over a multi-year horizon, against a threat environment that stole $2.02 billion in 2025 and is not declining — is greater than the cost of the infrastructure that eliminates it.

That is not a difficult belief to hold when the cost is 0.03 ETH.

---

## The Long-Term Infrastructure Argument

The analysts framing security as foundational to investment value preservation are describing a market that is maturing past the point where security can be evaluated as an optional feature of DeFi infrastructure. The 2025 data — $3.4 billion in total theft, $2.02 billion from state-sponsored operations alone — is the empirical basis for that framing.

Markets price risk when the risk is visible and measurable. The 2025 crypto theft data has made the risk of insecure DeFi infrastructure visible and measurable. The expected return from deploying capital into a protocol with exploitable admin key surfaces, against a threat environment with documented state-level capability to exploit those surfaces, is lower than the nominal expected return before risk adjustment.

Security-first infrastructure is the risk adjustment. Not a marketing attribute. Not a compliance checkbox. A structural property of the protocol's architecture that determines its position in the risk-adjusted return calculation that mature capital allocators apply to Web3 investment decisions.

The infrastructure that achieves this — immutable contracts, zero admin keys, flat fee pass-through architecture — is not priced as a premium product. It is priced at 0.03 ETH. The premium is the absence of the risk. The cost is the fee. The arithmetic resolves clearly.

---

## Conclusion

State-sponsored actors stole $2.02 billion from Web3 in 2025. They did it with AI-enhanced phishing and supply chain breaches targeting human-controlled access surfaces over large asset pools. The infrastructure decisions that created those surfaces are the same infrastructure decisions that projects are making at deployment today.

The analyst framing — security-first infrastructure as foundational to long-term investment value preservation — is a risk-adjusted reading of the 2025 loss data. It is the correct reading. The expected loss from insecure infrastructure, priced against the documented capability and operational tempo of the threat environment, is not a tail risk. It is a line item.

Security is not a cost center. It is the difference between the nominal return on a DeFi investment and the risk-adjusted one. The 0.03 ETH that removes the attack surface is not overhead. It is the most direct available purchase of the risk-adjusted return.

The threat environment of 2025 is the operating context of 2026. The infrastructure decision is the same one it was before the Chainalysis report, before the SlowMist catalogue, before the QuillAudits threat taxonomy. The data has simply made the cost of not making it legible.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
---
layout: ../../layouts/PostLayout.astro
title: How to Use the Embed Widget to Signal Trust on Your Landing Page
date: 2026-03-12
tags:
  - Guides
  - Developers
description: Learn how to integrate the 0xKeep embed widget into your project's landing page to provide investors with frictionless, cryptographic proof of secured assets.
image: https://image2url.com/r2/default/images/1772351964771-3914b7d6-a695-499f-8f55-15a87bf24cee.jpg
---
In the decentralized ecosystem, verbal commitments regarding liquidity and token vesting are structural vulnerabilities. Investors and protocol users no longer accept promises; they require deterministic, cryptographic proof. 

Historically, developers have relied on sharing block explorer links to demonstrate that their liquidity pool (LP) tokens or team allocations are locked. However, raw transaction hashes introduce user friction and require technical literacy to verify. 

To bridge this gap between on-chain reality and user experience, 0xKeep provides the Embed Widget—a public utility designed to display immutable proof of secured assets directly on your project's landing page.

---

### What is the 0xKeep Embed Widget?

The Embed Widget is a lightweight, responsive HTML `<iframe>` snippet. It acts as a direct visualizer for the 0xKeep V11 smart contracts across Base, Arbitrum, and Optimism. 

Without requiring a backend database or relying on third-party indexers, the widget reads the on-chain data associated with your specific Lock ID or Vesting ID. It outputs a clean, branded card utilizing our "Obsidian Glass" design system, displaying critical metrics such as:
*   Total amount secured.
*   Precise unlock timestamps.
*   Linear vesting progress (if applicable).
*   The target network consensus layer.

---

### The Mechanics of Trust Signaling

By placing the 0xKeep widget prominently on your project's website, you achieve two primary architectural goals:

1. **Frictionless Verification:** Users visiting your site do not need to navigate away, connect their wallets to a third-party dashboard, or parse raw hexadecimal data. The proof is rendered instantly in a human-readable format.
2. **Immutable Assurance:** The widget features a "Verified by 0xKeep Protocol" badge. Because 0xKeep operates on a strict "Write Once, Run Forever" philosophy—meaning zero admin keys, zero upgradeability, and zero custodial access—this badge serves as an absolute guarantee that the asset parameters displayed cannot be altered or bypassed by the development team.

---

### Implementation Guide

Integrating the widget into your frontend requires no specialized Web3 development experience. 

**Step 1: Secure the Assets**
Connect to the 0xKeep application and initialize a Standard Lock or Linear Vesting schedule. The protocol requires a flat fee (0.03 ETH for locks, 0.02 ETH for vesting) to process the transaction. 

**Step 2: Access the Certificate**
Upon successful transaction confirmation, navigate to your Dashboard and select the specific asset row. This will open the Liquidity or Vesting Certificate page.

**Step 3: Generate the Snippet**
Below the asset metadata and network indicator on the certificate card, locate the horizontal marketing toolbar. Click the **Embed** button. The system will automatically copy a responsive `<iframe>` code block to your clipboard.

**Step 4: Deploy**
Paste the HTML snippet into your website's codebase. The widget is designed with a fluid width (`100%`) and a constrained maximum width, allowing it to adapt seamlessly to sidebars, footers, or dedicated transparency sections. 

---

### Conclusion

In an industry defined by verifiable code, transparency is your highest-value asset. The 0xKeep Embed Widget allows developers to project that transparency outward. By embedding cryptographic proof directly into your user interface, you eliminate doubt and establish your protocol on a foundation of mathematical certainty.

---

> 0xKeep operates on an immutable, zero-admin-key architecture. No wallet — including those controlled by the 0xKeep team — can pause, modify, or interact with deployed contracts. Time is the only admin.

Deploy on Base, Arbitrum, or Optimism at [**0x-keep.xyz**](https://0x-keep.xyz) Follow protocol updates: [**@0xKeep_official**](https://x.com/0xkeep_official)
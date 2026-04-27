[README.md](https://github.com/user-attachments/files/27110688/README.md)
# Whelm

A master baker in your pocket. Whelm is an AI-powered sourdough companion for iOS that guides you from your first jar of flour and water to pulling your first loaf — one day at a time.

---

## What it does

Whelm walks you through the full sourdough journey in two chapters.

**Chapter 1 — The Starter (Days 1 to 14)**
You name your starter on Day 1. Every day you check in — noting the rise, the bubbles, the smell. Whelm reads your observations and responds like a master baker would. Not generic tips. Advice calibrated to your starter, your kitchen temperature, and your flour. By Day 14 your starter is ready and the bread section unlocks.

**Chapter 2 — The Bread**
A bake planner that works backwards from when you want to eat. A step-by-step bake day guide with live timers. A score and bake screen that walks you through the final moments.

---

## Design

Whelm is built around a single visual identity — a living orb that represents your starter. It breathes slowly on Day 1, dim and dormant. By Day 14 it glows.

- Dark warm background `#1a1612`
- Amber accent `#c4964e`
- SF Pro throughout
- No nav bars, no tab bars, no clutter

---

## Stack

- Swift / SwiftUI
- SwiftData for persistence
- Claude API (Anthropic) for AI guidance
- iOS 17+

---

## Screens

- Onboarding — name your starter or jump in mid-journey
- Home — the living orb, day counter, daily AI read
- Daily check-in — tap what you observe, get a response
- Feeding log — your starter's full history with activity timeline
- Bake planner — pick a meal time, get a full schedule
- Bake day — live timer, step-by-step guidance
- Score and bake — the final moment
- Settings — kitchen temperature, flour type, units, reminders

---

## Setup

1. Clone the repo
2. Open `Whelm/Whelm.xcodeproj` in Xcode
3. Add your Anthropic API key to `Info.plist` under `ANTHROPIC_API_KEY`
4. Run on simulator or device

You'll need an Anthropic API key from [console.anthropic.com](https://console.anthropic.com).

---

## The name

You don't want to overwhelm your starter or underwhelm it. It just needs whelm. Not too much attention, not too little. The right amount, at the right time.

---

## Status

Active development. Not yet on the App Store.

---

## Author

Built by [@Lwestley](https://github.com/Lwestley)

# /ctos — ConnectOS Skill for Claude Code

Give any Claude Code agent authenticated access to your SaaS tools (Shopify, Slack, HubSpot, Google Calendar, Stripe, Meta Ads, and more).

## Install

```bash
curl -sL https://raw.githubusercontent.com/ArshyaAI/ctos-skill/main/skills.sh | bash
```

This installs:

1. The `ctos` CLI (`npm install -g @oysa/connectos`)
2. The `/ctos` skill for Claude Code (`~/.claude/skills/ctos/`)

## Setup

After installing, configure your ConnectOS server:

```bash
ctos init --url https://your-connectos.railway.app --name "My Project" --bootstrap-secret <secret>
```

Then connect your SaaS tools:

```bash
ctos connect shopify     # Opens browser for OAuth
ctos connect slack
ctos connect google-calendar
```

## Usage

In any Claude Code session, type:

```
/ctos                          → check setup + show connections
/ctos briefing shopify         → pull Shopify revenue data
/ctos briefing daily           → composite morning briefing
/ctos connections              → list connected tools + health
```

Or just ask naturally — the skill auto-triggers on keywords like "Shopify data", "briefing", "check connections".

## What is ConnectOS?

ConnectOS is the integration and trust layer for AI agents. It handles OAuth, token refresh, connection health monitoring, capability scoping, and approval workflows — so your agents get authenticated SaaS access without managing tokens.

Learn more: [@oysa/connectos on npm](https://www.npmjs.com/package/@oysa/connectos)

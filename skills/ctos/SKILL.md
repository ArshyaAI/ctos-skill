---
name: ctos
description: |
  Authenticated SaaS access for AI agents via ConnectOS. Use /ctos to pull real
  data from Shopify, Slack, HubSpot, Google Calendar, Stripe, Meta Ads, and more.
  This skill should be used when the user says "/ctos", "get Shopify data",
  "pull briefing", "check connections", "connect to SaaS", "proxy API call",
  or needs real business data from connected SaaS tools.
---

# /ctos — Authenticated SaaS Access for AI Agents

**Usage:** `/ctos` or `/ctos <subcommand>`

Pull real data from connected SaaS tools (Shopify, Slack, HubSpot, etc.)
via the `ctos` CLI. No token management — ConnectOS handles OAuth automatically.

## Step 1: Check Setup

```bash
which ctos >/dev/null 2>&1 && echo "INSTALLED" || echo "NOT_INSTALLED"
[ -f ~/.ctosrc ] && echo "CONFIGURED" || echo "NOT_CONFIGURED"
```

- `NOT_INSTALLED` → run `npm install -g @oysa/connectos`
- `NOT_CONFIGURED` → ask the user which setup they need:
  - **New tenant:** `ctos init --name <project> --bootstrap-secret <secret>`
    (URL defaults to production. Only the bootstrap secret is needed.)
  - **Existing tenant:** `ctos init --api-key <key> --tenant <tenant_id>`
    (No bootstrap secret needed — just the API key and tenant ID.)
  - Ask: "Do you have an existing API key and tenant ID, or do you need to register a new tenant?"
- Both OK → proceed to Step 2

## Step 2: Check What's Available

```bash
ctos connections --pretty
```

This shows all connected SaaS tools and their health. Use this to know what data
is available before trying to pull anything.

## Core Commands

### Check what's connected

```bash
ctos connections --pretty    # List all connections with health status
ctos context --pretty        # Full agent context (connections + capabilities)
```

### Read data (briefings)

```bash
ctos briefing daily --pretty           # Composite morning briefing (all sources)
ctos briefing shopify --pretty         # Shopify revenue, orders, products
ctos briefing slack --pretty           # Slack channel activity
ctos briefing google-calendar --pretty # Calendar events
ctos briefing sources --pretty         # List available briefing sources
```

Available providers: shopify, hubspot, slack, google-calendar, stripe,
outlook-calendar, linear, meta-ads, instagram, ga4, daily, sources.

### Proxy authenticated API calls

```bash
ctos proxy <capability> <method> <path> --connection <id> [--body <json>]
```

Example — read Shopify orders:

```bash
ctos proxy read_orders GET /admin/api/2024-01/orders.json --connection <id> --pretty
```

The proxy injects the OAuth token automatically. No token management needed.

### Connect a new provider

```bash
ctos connect shopify    # Opens browser for OAuth flow
ctos scopes shopify     # Show recommended OAuth scopes first
```

### Connection lifecycle

```bash
ctos reconnect <provider>   # Re-authorize a broken connection
ctos disconnect <provider>  # Remove a connection
ctos health --pretty        # Server readiness check
```

### Approvals (for risky operations)

```bash
ctos approve --list                          # List pending approvals
ctos approve --resolve <id> approve          # Approve a request
ctos request-approval <capability> --provider <name>  # Request approval
```

## When to Use What

| Goal                             | Command                                     |
| -------------------------------- | ------------------------------------------- |
| "What data do I have access to?" | `ctos context --pretty`                     |
| "Get me today's Shopify revenue" | `ctos briefing shopify --pretty`            |
| "Read my calendar for today"     | `ctos briefing google-calendar --pretty`    |
| "Make an API call to Shopify"    | `ctos proxy read_orders GET /admin/api/...` |
| "Is everything healthy?"         | `ctos connections --pretty`                 |
| "Connect a new tool"             | `ctos connect <provider>`                   |
| "A connection is broken"         | `ctos reconnect <provider>`                 |

## Error Handling

- **401 on any command**: API key is invalid — check `~/.ctosrc` or re-run `ctos init`
- **404 on briefing**: Provider not connected — run `ctos connect <provider>`
- **503 on briefing**: Nango not configured server-side — check server env vars
- **needs_reauth in connections**: Token expired — run `ctos reconnect <provider>`

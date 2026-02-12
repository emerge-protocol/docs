# Emerge API Documentation

## Project overview
Documentation for Emerge API - a privacy-first API for accessing consented user data. The project includes Link API (consent collection) and Query API (data retrieval).

## Technical stack
- Format: MDX files with YAML frontmatter
- Build system: Mintlify (cloud-hosted, auto-deploys from GitHub)
- Config: docs.json (navigation, theme, branding)
- Theme: maple with Emerge brand colors (primary: #e36c35, light: #ff4f1a, dark: #2e1205)
- Branding: Mintlify footer branding hidden (`branding.hide: true` in docs.json + CSS selector in style.css)
- Custom styles: style.css - Logo sized to 32px height, Mintlify "Powered by" footer hidden via CSS
- OpenAPI specs: openapi/link.json and openapi/query.json (v0.0.11 spec changes as of 2026-02-12: webhook v2 payload, consent/export status updates, categories endpoint examples)
- AI integration: MCP (Model Context Protocol) enabled
- Local dev: `mint dev` (requires global CLI: `npm i -g mint`)
- Preview URL: http://localhost:3000
- Logo: emerge-logo.svg (360x96px, text-based with system-ui fonts, 70px bold, used for both light and dark modes)
- Favicon: favicon.ico (MS Windows icon resource with 16x16 and 32x32 PNG icons)
- Navbar: Primary CTA button links to The Control Room (dashboard.emergedata.ai), support email link (account@emergedata.ai) in secondary navigation and global footer
- Global anchors: The Control Room (arrow-up-right-from-square icon, external link indicator), Support (envelope icon)

## Content structure

### Main sections (tabs in docs.json)
- **Guides** (`/`) - Getting started, quickstart, SDKs, changelog
- **Link** (`/link/`) - Consent flow integration (authentication, signed URLs, callbacks, webhooks)
- **Query** (`/query/`) - Data retrieval (sync/async patterns, pagination, categories, schema)
- **Ship with MCP** (`/ai/`) - MCP setup, contextual menu, examples, tool-specific guides
- **The Control Room** (`/control-room/overview`) - Dashboard configuration and operational workflows
- **Data Wallet©** (`/data-wallet/overview`) - End-user revocation and transparency workflows

### Key files
- `index.mdx` - Homepage with product overview and navigation
- `quickstart.mdx` - Lightning-fast integration guide with upfront AI tool setup section (MCP integration for Cursor, Claude Code, VS Code) at the beginning before prerequisites
- `AGENTS.md` - AI-specific documentation guidelines (code examples, API patterns, terminology)
- `CLAUDE.md` - This file - project memory for AI agents
- `changelog.mdx` - Version history (current: v0.0.11 as of 2026-02-12)
- `docs.json` - Navigation structure, Mintlify configuration, theme colors (maple theme with Emerge branding), support email: account@emergedata.ai
- `openapi/link.json` - OpenAPI 3.1 spec for Link API reference, contact email: account@emergedata.ai (auto-synced from atlas; do not edit manually)
- `openapi/query.json` - OpenAPI 3.1 spec for Query API reference, contact email: account@emergedata.ai (auto-synced from atlas; do not edit manually)
- `README.md` - Documentation development guide

## Writing standards

### Voice and style
- Second-person ("you")
- Developer-focused, concise prose
- Privacy-first messaging
- Explain "why" when not obvious

### Code examples
- Provide both TypeScript AND Python for all API examples
- Use realistic parameter values (not foo/bar/example)
- Include proper error handling
- Show complete, runnable snippets
- Use async/await patterns for API calls
- All code blocks must have language tags
- Show only required fields in quickstart examples (optional fields can be documented separately)

### API documentation patterns
Every endpoint must document:
- Required authentication method
- All parameters with types and descriptions
- Response format with example
- Possible error codes
- Rate limiting (if applicable)

### Common integration patterns

**Creating consent links:**
- HMAC signing with sorted parameters using signing_secret
- State parameter for CSRF protection
- Timestamp in ISO 8601 format (new Date().toISOString() or datetime.now(timezone.utc).isoformat()) for link expiration (30 days)
- Link URL endpoint: `/link/start?` (not `/link?`)
- Optional flow_config parameter for custom branding (replaced deprecated flow_version)

**Handling callbacks:**
- State verification against stored values
- Status values: success, reauthorized, failure
- Error code handling (data_invalid, user_failed, uid_conflict, access_denied, invalid_scope, admin_policy_enforced)
- Callback parameters: status, state, uid, error_code (no flow_version)

**Querying data:**
- Sync vs async tradeoffs (30s timeout vs job-based polling)
- Sync: Single uid, pagination with cursor, delta queries with ingested_begin/ingested_end
- Async: Batch up to 25 users, date range with begin/end, results as Parquet file via S3 presigned URL

**Webhooks:**
- Event types: `consent.given`, `consent.revoked`, `consent.expiring`, `consent.reauthorized`
- HMAC-SHA256 signature verification (`X-Signature` header)
- Payload includes top-level `uid`, `client_id`, and provider-specific `sources[]`

## Content strategy
- Document just enough for user success
- Prioritize accuracy and usability
- Make content evergreen when possible
- Avoid duplication unless strategic
- Check existing patterns for consistency
- Start with smallest reasonable changes

## Frontmatter requirements
Every MDX file must include:
```yaml
---
title: Clear, descriptive page title
description: Concise summary for SEO/navigation
---
```

## File organization
- `/link/*.mdx` - Link API guides (overview, authentication, create-link, callbacks, webhooks)
- `/query/*.mdx` - Query guides (overview, pagination, event-categories, data-schema)
- `/ai/*.mdx` - Ship with MCP docs (overview, mcp-docs-setup, mcp-query-setup, mcp-query-tools, contextual-menu, examples)
- `/ai-tools/*.mdx` - AI tool-specific setup guides (claude-code, cursor, windsurf) [Note: Directory exists in git but not filesystem - may be template content]
- `/sdks/*.mdx` - SDK implementations (TypeScript, Python) - Copy-paste reference implementations
- `/api-reference/` - Legacy API reference pages (deprecated - use OpenAPI auto-generated pages)
- `/openapi/link.json` - OpenAPI 3.1 spec with Link API endpoints
- `/openapi/query.json` - OpenAPI 3.1 spec with Query API endpoints
- `/essentials/` - Template content (code, images, markdown, navigation, etc.)
- `/snippets/` - Reusable content snippets
- `/images/` - Documentation images and diagrams
- `/logo/` - Brand assets (emerge-logo.svg - 360x96px text-based logo)
- `favicon.ico` - Site favicon (16x16 and 32x32 icons)
- `style.css` - Custom styles (32px logo height, hide Mintlify footer)

## Build and development

### Local preview
```bash
# Install docs CLI globally
npm i -g mint

# Run dev server (from docs root, where docs.json is located)
mint dev

# View at http://localhost:3000
```

### Common commands
```bash
# Update CLI to latest version
mint update

# Validate docs.json and OpenAPI spec
mint validate
```

### Deployment
- Auto-deploys via GitHub integration
- Push to main branch → automatic production deployment
- No manual build step required

## Git workflow
- NEVER use --no-verify when committing
- Ask about uncommitted changes before starting
- Create new branch when no clear branch exists
- Commit frequently throughout development
- NEVER skip or disable pre-commit hooks

## Do not
- Skip frontmatter on any MDX file
- Use absolute URLs for internal links
- Include untested code examples
- Make assumptions - always ask for clarification
- Provide only one language example (need both TS and Python)
- Skip error handling in code examples

## Available data types

| Data Type | Sync Endpoint | Async Endpoint | Description |
|-----------|---------------|----------------|-------------|
| Search History | `/v1/sync/get_search` | `/v1/search` | Google search queries with timestamps |
| Browsing History | `/v1/sync/get_browsing` | `/v1/browsing` | Chrome page visits with titles |
| YouTube History | `/v1/sync/get_youtube` | `/v1/youtube` | Watched videos with channels |
| Ad Interactions | `/v1/sync/get_ads` | `/v1/ads` | Ad clicks and views |
| Receipts | `/v1/sync/get_receipts` | `/v1/receipts` | Purchase receipts with items and brands |

### Link API endpoints
- `POST /configs` - Create/update consent flow configuration (required: config_name, company_name, logo_url, privacy_policy_url, is_default; optional: webhook_url, flow_config)
- `GET /consent/status/{uid}` - Returns `sub`, `client_id`, and provider-level `consents[]`
- `GET /export/status/{uid}` - Returns provider-level readiness in `sources[]`
- Link URL: `/link/start?` with parameters: client_id, redirect_uri, state, timestamp (ISO 8601), signature, optional: uid, flow_config

### Query API endpoints
- Sync endpoints: 30s timeout, immediate JSON response, single uid parameter
- Async endpoints: Job-based polling via `/v1/job/{task_id}`, users array (max 25), begin/end date range, Parquet file result
- Job management: `GET /v1/jobs` lists all jobs

## Terminology
- "Emerge Link" - The consent flow product
- "The Control Room" - Dashboard at dashboard.emergedata.ai
- "consent" - User permission for data access
- "export" - Data transfer from provider to Emerge
- "query" - Retrieving user data via API
- "signing_secret" - HMAC signing credential (not "client_secret")
- "flow_config" - Named configuration for custom branding (replaced deprecated "flow_version")
- "uid" or "partner_uid" - Partner's user identifier
- "task_id" or "job_id" - Async query job identifier
- "config_name" - Named configuration for consent flow (supports multiple configs per client)
- "data_ready" - Boolean indicating if exported data is available for querying
- "consents" - Array of provider-specific consent records with scopes and validity
- "begin/end" - Date range parameters for async queries (replaced ingested_after/before)
- "event_id" - Integer type in Query API responses (not string)

## API domains
- Link API: https://link.emergedata.ai
- Query API: https://query.emergedata.ai
- Dashboard: https://dashboard.emergedata.ai
- MCP Server: https://docs.emergedata.ai/mcp (AI tool integration - updated from emerge.mintlify.dev)
- Docs site: https://docs.emergedata.ai (production URL)

## AI-native features

### MCP (Model Context Protocol)
- Mintlify auto-generates MCP server at `/mcp` endpoint
- AI tools can search and query documentation semantically
- Configuration examples in `/ai/mcp-docs-setup.mdx` for Claude, Cursor, VS Code, Claude Code
- Quickstart guide includes AI tool setup section with MCP instructions for Cursor (.cursor/mcp.json), Claude Code (claude mcp add), and VS Code (.vscode/mcp.json)

### Contextual menu
- Enabled via `docs.json` "contextual" section
- Options: copy, view, chatgpt, claude, perplexity, mcp, cursor, vscode
- Right-click any code block or text selection for AI-powered actions
- Examples documented in `/ai/contextual-menu.mdx`

### Interactive API playground
- OpenAPI playground mode set to "interactive"
- Allows testing API endpoints directly from documentation
- Configured via `api.playground.display` in docs.json

## Working relationship
- Push back on ideas with citations and reasoning
- ALWAYS ask for clarification vs assumptions
- NEVER lie, guess, or fabricate information

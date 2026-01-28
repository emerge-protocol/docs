# Emerge API Documentation

## Project overview
Documentation for Emerge API - a privacy-first API for accessing consented user data. The project includes Link API (consent collection) and Query API (data retrieval).

## Technical stack
- Format: MDX files with YAML frontmatter
- Build system: Cloud-hosted docs platform (auto-deploys from GitHub)
- Config: docs.json (navigation, theme, branding)
- OpenAPI spec: openapi/emerge.json (v1.0.0)
- AI integration: MCP (Model Context Protocol) enabled
- Local dev: `mint dev` (requires global CLI: `npm i -g mint`)
- Preview URL: http://localhost:3000

## Content structure

### Main sections (tabs in docs.json)
- **Guides** (`/`) - Getting started, quickstart, SDKs, changelog
- **Link API** (`/link/`) - Consent flow integration (authentication, signed URLs, callbacks, webhooks)
- **Query API** (`/query/`) - Data retrieval (sync/async patterns, pagination)
- **AI Integration** (`/ai/`) - MCP setup, contextual menu, examples, tool-specific guides

### Key files
- `index.mdx` - Homepage with product overview and navigation
- `quickstart.mdx` - 30-minute integration guide
- `AGENTS.md` - AI-specific documentation guidelines (code examples, API patterns, terminology)
- `CLAUDE.md` - This file - project memory for AI agents
- `changelog.mdx` - Version history (current: v1.0.0)
- `docs.json` - Navigation structure, configuration, theme colors
- `openapi/emerge.json` - OpenAPI 3.1 spec for API reference
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

### API documentation patterns
Every endpoint must document:
- Required authentication method
- All parameters with types and descriptions
- Response format with example
- Possible error codes
- Rate limiting (if applicable)

### Common integration patterns

**Creating consent links:**
- HMAC signing with sorted parameters
- State parameter for CSRF protection
- Timestamp for link expiration (30 days)
- flow_version parameter (default: 'lm')

**Handling callbacks:**
- State verification against stored values
- Status values: success, reauthorized, failure
- Error code handling

**Querying data:**
- Sync vs async tradeoffs (30s timeout vs job-based polling)
- Sync: Single uid, pagination with cursor, delta queries with ingested_begin/ingested_end
- Async: Batch up to 25 users, date range with begin/end, results as Parquet file via S3 presigned URL

**Webhooks:**
- Event types: `consent.given`, `consent.revoked`, `consent.expiring`, `consent.completed`, `export.completed`, `export.failed`, `token.needs_reauth`
- HMAC-SHA256 signature verification (X-Emerge-Signature header)
- Payload includes event, timestamp, data object with uid, client_id, provider

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
- `/query/*.mdx` - Query API guides (overview, pagination)
- `/ai/*.mdx` - AI integration docs (overview, mcp-setup, contextual-menu, examples)
- `/ai-tools/*.mdx` - AI tool-specific setup guides (claude-code, cursor, windsurf) [Note: Directory exists in git but not filesystem - may be template content]
- `/sdks/*.mdx` - SDK implementations (TypeScript, Python) - Copy-paste reference implementations
- `/api-reference/` - Legacy API reference pages (deprecated - use OpenAPI auto-generated pages)
- `/openapi/emerge.json` - OpenAPI 3.1 spec with Link and Query API endpoints
- `/essentials/` - Template content (code, images, markdown, navigation, etc.)
- `/snippets/` - Reusable content snippets
- `/images/` - Documentation images and diagrams
- `/logo/` - Brand assets (emerge-logo.svg)

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

### Link API endpoints
- `POST /configs` - Create/update consent flow configuration (supports config_name, webhook_url, flow_version, is_default)
- `GET /consent/status/{uid}` - Returns array of consents with provider, scopes, valid_until, status, issued_at
- `GET /export/status/{uid}` - Returns data_ready boolean, data_landed_at, export_status, export_completed_at

### Query API endpoints
- Sync endpoints: 30s timeout, immediate JSON response, single uid parameter
- Async endpoints: Job-based polling via `/v1/job/{task_id}`, users array (max 25), begin/end date range, Parquet file result
- Job management: `GET /v1/jobs` lists all jobs

## Terminology
- "Emerge Link" - The consent flow product
- "Control Room" - Dashboard at dashboard.emergedata.ai
- "consent" - User permission for data access
- "export" - Data transfer from provider to Emerge
- "query" - Retrieving user data via API
- "flow_version" - Consent flow variant (lm = Gmail flow)
- "uid" or "partner_uid" - Partner's user identifier
- "task_id" or "job_id" - Async query job identifier
- "config_name" - Named configuration for consent flow (supports multiple configs per client)
- "data_ready" - Boolean indicating if exported data is available for querying
- "consents" - Array of provider-specific consent records with scopes and validity
- "begin/end" - Date range parameters for async queries (replaced ingested_after/before)

## API domains
- Link API: https://link.emergedata.ai
- Query API: https://query.emergedata.ai
- Dashboard: https://dashboard.emergedata.ai
- MCP Server: https://emerge.mintlify.dev/mcp (AI tool integration)
- Docs site: https://emerge.mintlify.dev (or custom domain if configured)

## AI-native features

### MCP (Model Context Protocol)
- MCP server auto-generated at `/mcp` endpoint
- AI tools can search and query documentation semantically
- Configuration examples in `/ai/mcp-setup.mdx` for Claude, Cursor, VS Code, Claude Code

### Contextual menu
- Enabled via `docs.json` "contextual" section
- Options: copy, view, chatgpt, claude, perplexity, mcp, cursor, vscode
- Right-click any code block or text selection for AI-powered actions
- Examples documented in `/ai/contextual-menu.mdx`

## Working relationship
- Push back on ideas with citations and reasoning
- ALWAYS ask for clarification vs assumptions
- NEVER lie, guess, or fabricate information
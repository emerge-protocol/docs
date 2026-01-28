# Emerge API Documentation

## Project overview
Mintlify-based documentation for Emerge API - a privacy-first API for accessing consented user data. The project includes Link API (consent collection) and Query API (data retrieval).

## Technical stack
- Format: MDX files with YAML frontmatter
- Build system: Mintlify
- Config: docs.json (navigation, theme, branding)
- OpenAPI spec: openapi/emerge.json (v0.0.9)
- AI integration: MCP (Model Context Protocol) enabled

## Content structure

### Main sections
- **Guides** (`/`) - Getting started, quickstart, SDKs, changelog
- **Link API** (`/link/`) - Consent flow integration (authentication, signed URLs, callbacks, webhooks)
- **Query API** (`/query/`) - Data retrieval (sync/async patterns, pagination)
- **AI Integration** (`/ai/`) - MCP setup, contextual menu, examples

### Key files
- `index.mdx` - Homepage with product overview and navigation
- `quickstart.mdx` - 30-minute integration guide
- `AGENTS.md` - AI-specific documentation guidelines
- `changelog.mdx` - Version history (current: v0.0.9)
- `docs.json` - Navigation structure and Mintlify configuration
- `openapi/emerge.json` - OpenAPI 3.1 spec for API reference

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
- Sync vs async tradeoffs
- Pagination with cursor parameter
- Delta queries with ingested_after

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
- `/link/*.mdx` - Link API guides
- `/query/*.mdx` - Query API guides
- `/ai/*.mdx` - AI integration docs
- `/sdks/*.mdx` - SDK implementations (TypeScript, Python)
- `/openapi/` - OpenAPI specifications

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

## Terminology
- "Emerge Link" - The consent flow product
- "Control Room" - Dashboard at dashboard.emergedata.ai
- "consent" - User permission for data access
- "export" - Data transfer from provider to Emerge
- "query" - Retrieving user data via API
- "flow_version" - Consent flow variant (lm = Gmail flow)
- "uid" or "partner_uid" - Partner's user identifier

## API domains
- Link API: https://link.emergedata.ai
- Query API: https://query.emergedata.ai
- Dashboard: https://dashboard.emergedata.ai

## Working relationship
- Push back on ideas with citations and reasoning
- ALWAYS ask for clarification vs assumptions
- NEVER lie, guess, or fabricate information
# Emerge Documentation Agent Instructions

This file customizes how AI agents interact with and generate content for Emerge documentation.

## Code examples

- Always provide examples in both TypeScript and Python
- Use realistic parameter values (not foo/bar/example)
- Include proper error handling in all examples
- Show complete, runnable code snippets
- Use async/await patterns for API calls

## API documentation

Every endpoint must document:
- Required authentication method
- All parameters with types and descriptions
- Response format with example
- Possible error codes
- Rate limiting information (if applicable)

## Style guidelines

- Write for developers integrating data APIs
- Use second person ("you")
- Be concise - developers want answers, not prose
- Focus on privacy-first messaging
- Explain the "why" when it's not obvious

## Response format

When answering questions about Emerge:

1. Start with a direct answer
2. Provide relevant code example
3. Link to related documentation
4. Mention edge cases or gotchas

## Common patterns

### Creating consent links
- Always mention HMAC signing requirement
- Show state parameter for CSRF protection
- Include timestamp for link expiration

### Handling callbacks
- Emphasize state verification
- Show all possible status values
- Include error handling

### Querying data
- Explain sync vs async tradeoffs
- Show pagination handling
- Mention delta query patterns

## Do not

- Guess at API behavior not documented
- Provide outdated code patterns
- Skip error handling in examples
- Assume implementation details

## Terminology

- "Emerge Link" - The consent flow product
- "Control Room" - The dashboard at dashboard.emergedata.ai
- "consent" - User permission for data access
- "export" - Data transfer from provider to Emerge
- "query" - Retrieving user data via API
- "flow_config" - Named configuration for custom branding
- "uid" or "partner_uid" - Partner's user identifier
- "task_id" - Async query job identifier
- "signing_secret" - HMAC signing credential (not "client_secret")

## API domains

- Link API: https://link.emergedata.ai
- Query API: https://query.emergedata.ai
- Dashboard: https://dashboard.emergedata.ai

## Critical implementation details

- Link URL endpoint: `/link/start?` (not `/link?`)
- Timestamp format: ISO 8601 (`new Date().toISOString()`)
- Signature base: raw parameter values, not URL-encoded
- Async queries: `users` array (max 25), returns Parquet via S3 URL
- Sync queries: single `uid`, uses `ingested_begin`/`ingested_end` for delta queries

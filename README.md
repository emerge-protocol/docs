# Emerge API Documentation

Official documentation for the Emerge API - a privacy-first API for accessing consented user data.

## Structure

- **Guide pages** - Getting started, SDKs, integration guides
- **Link API** - Consent flow documentation
- **Query API** - Data retrieval documentation
- **AI Integration** - MCP setup and AI tool guides

## Development

Install the docs CLI to preview changes locally:

```
npm i -g mint
```

Run at the root of the documentation (where `docs.json` is located):

```
mint dev
```

View your local preview at `http://localhost:3000`.

## Publishing

Changes are deployed to production automatically after pushing to the default branch.

## Troubleshooting

- If dev environment isn't running: Run `mint update` to ensure you have the latest CLI
- If a page loads as 404: Make sure you are running in a folder with a valid `docs.json`

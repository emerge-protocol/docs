# Emerge API Documentation

Official documentation for the Emerge API - a privacy-first API for accessing consented user data.

## Structure

- **Guides** - Getting started, SDKs, integration guides
- **Link** - Consent flow documentation
- **Query** - Data retrieval documentation
- **Ship with MCP** - MCP setup and AI tool guides
- **The Control Room** - Dashboard and configuration workflows
- **Data Wallet** - End-user revocation and transparency controls

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

See https://docs.emergedata.ai

## Troubleshooting

- If dev environment isn't running: Run `mint update` to ensure you have the latest CLI
- If a page loads as 404: Make sure you are running in a folder with a valid `docs.json`

# Dart Site MCP Server

A local MCP server designed to help `dart.dev` writers and maintainers automate
common tasks using Antigravity.

## 1. Add this MCP server to Antigravity

To use this server, you need to configure Antigravity to run it. Add the
following configuration to your MCP settings file
(typically `~/Library/Application Support/Antigravity/config.json` or similar,
depending on your setup).

**Configuration Snippet:**

```json
{
  "mcpServers": {
    "dart-site": {
      "command": "dart",
      "args": [
        "run",
        "/absolute/path/to/site-www/tool/mcp_server/bin/server.dart"
      ]
    }
  }
}
```

> [!IMPORTANT]
> Replace `/absolute/path/to/site-www/` with the actual full path to your
> local `site-www` repository. If you do not know your absolute path,
> ask Antigravity to provide it for you.

Once configured, restart Antigravity to load the new server.

## Update Changelog

**Syntax**

```terminal
Update changelog x.x.x
```

**Example**

```terminal
Update changelog 3.11.0
```

**Description**

This tool adds entries from the Dart SDK `CHANGELOG.md` to the Dart doc site's
data file (`src/data/changelog.yml`).

1.  Fetches the latest changelog from the Dart SDK repository.
2.  Parses entries for the requested version (e.g., 3.11.0).
3.  Adds them to `src/data/changelog.yml` with appropriate tags
    (`new`, `fixed`, `deprecated`) and links.
4.  Filters out vague or non-user-facing entries.

Antigravity will recognize the request, retrieve the official workflow guide,
and guide you through the process (syncing, verifying, and refining).

## Development

If you are a developer extending this server:

-   **Source Code**: located in `tool/mcp_server/`
-   **Run locally**: `dart run tool/mcp_server/bin/server.dart`
-   **Verify**: `dart tool/mcp_server/tool/verify_changelog_tool.dart <VERSION>`

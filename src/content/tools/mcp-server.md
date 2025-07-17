# Dart MCP Server

The Dart MCP Server exposes Dart (and Flutter)
development tool actions to compatible AI-assistant
clients.

## Overview

The Dart MCP server can work with any MCP client that
supports standard I/O (stdio) as the transport medium.
To access all the features of the Dart MCP server, an
MCP client must support [Tools][] and [Resources][].
For the best development experience with the Dart MCP
server, an MCP client should also support [Roots][].

If you are using a client that claims it supports roots
but does not actually set them, pass
`--force-roots-fallback` which will instead enable tools
for managing the roots.

:::note
This package is still experimental and is likely to
evolve quickly.

All of the following set up instructions require
Dart 3.9.0-163.0.dev or later.
:::

[Tools]: https://modelcontextprotocol.io/docs/concepts/tools
[Resources]: https://modelcontextprotocol.io/docs/concepts/resources
[Roots]: https://modelcontextprotocol.io/docs/concepts/roots

## Set up your MCP client

The server is run with the `dart mcp-server` command, which will
have to be configured in your preferred client.

This section provides instructions for setting up the
Dart MCP server with popular tools like Gemini CLI,
Gemini Code Assist, Cursor, and GitHub Copilot.

### Gemini CLI

To configure the [Gemini CLI][] to use
the Dart MCP server, edit the `.gemini/settings.json`
file in your local project (configuration will only apply
to this project) or edit the global
`~/.gemini/settings.json` file in your home directory
(configuration will apply for all projects).

```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": [
        "mcp-server",
      ]
    }
  }
}
```

For more information, see the official Gemini CLI
documentation for [setting up MCP servers][].

[Gemini CLI]: https://github.com/google-gemini/gemini-cli
[setting up MCP servers]: https://github.com/google-gemini/gemini-cli/blob/main/docs/tools/mcp-server.md#how-to-set-up-your-mcp-server

### Gemini Code Assist in VS Code

:::note
This requires the "Insiders" channel.
Follow [instructions][] to enable this build.
:::

[Gemini Code Assist][]'s [Agent mode][] integrates the
Gemini CLI to provide a powerful AI agent
directly in your IDE. To configure Gemini Code Assist to
use the Dart MCP server, follow the instructions to
[configure the Gemini][] CLI above.

You can verify the MCP server has been configured
properly by typing `/mcp` in the chat window in Agent
mode.

For more information see the official Gemini Code Assist
documentation for [using agent mode][].

[instructions]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer#before-you-begin
[Gemini Code Assist]: https://codeassist.google/
[Agent mode]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer
[configure the Gemini]: #gemini-cli
[using agent mode]: https://developers.google.com/gemini-code-assist/docs/use-agentic-chat-pair-programmer#before-you-begin

### Cursor

The easiest way to configure the Dart MCP server with
Cursor is by clicking the **Add to Cursor** button:

[![Add to Cursor](https://cursor.com/deeplink/mcp-install-dark.svg)](https://cursor.com/install-mcp?name=dart&config=eyJ0eXBlIjoic3RkaW8iLCJjb21tYW5kIjoiZGFydCBtY3Atc2VydmVyIC0tZXhwZXJpbWVudGFsLW1jcC1zZXJ2ZXIgLS1mb3JjZS1yb290cy1mYWxsYmFjayJ9)

Alternatively, you can configure the server manually:

1.  Go to **Cursor > Settings > Cursor Settings > Tools
    & Integrations**.
1.  Click **Add Custom MCP** or **New MCP Server**
    depending on whether you already have other MCP
    servers configured.
1.  Edit the `.cursor/mcp.json` file in your local
    project (configuration will only apply to this
    project) or edit the global `~/.cursor/mcp.json`
    file in your home directory (configuration will apply
    for all projects) to configure the Dart MCP server:

```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": [
        "mcp-server",
        "--force-roots-fallback" // Workaround for a Cursor issue with Roots support
      ]
    }
  }
}
```

For more information, see the official Cursor
documentation for [installing MCP servers][].

[installing MCP servers]: https://docs.cursor.com/context/model-context-protocol#installing-mcp-servers

### GitHub Copilot in VS Code

:::note
This requires Dart-Code VS Code extension v3.114 or
later.
:::

To globally configure the Dart MCP server with Copilot or
any other AI agent that supports the [VS Code MCP API][],
add the following to your VS Code user settings as follows:

1. In VS Code, click **View > Command Palette Preferences:
   Open User Settings (JSON)**.

1. Add the following setting:

    ```json
    "dart.mcpServer": true
    ```

If you'd like this setting to apply only to a specific
workspace, add the entry to your workspace settings as
follows:

1. In VS Code, click **View > Command Palette > Preferences:
   Open Workplace Settings (JSON)**.

1. Add the following setting:

    ```json
    "dart.mcpServer": true
    ```

By adding this setting, the Dart VS Code extension
registers the Dart MCP Server configuration with VS Code
so that you don't have to manually configure the server.
Copilot will then automatically configure the Dart MCP
server on your behalf.

For more information, see the official VS Code
documentation for [enabling MCP support][].

[VS Code MCP API]: https://code.visualstudio.com/api/extension-guides/mcp
[enabling MCP support]: https://code.visualstudio.com/docs/copilot/chat/mcp-servers#_enable-mcp-support-in-vs-code

## Available Tools

For an update to date list of the available tools and any
other functionality, see the [README.md][MCP Readme] file.

Note that MCP tools are not intended to be invoked by normal
code, only by LLMs based on their description. This means we
do not consider it a breaking change to add, remove, or
modify the behavior of tools at any time.

[MCP Readme]: https://github.com/dart-lang/ai/blob/main/pkgs/dart_mcp_server/README.md#tools

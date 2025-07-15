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

## Tools for Dart

| Tool Name | Title | Description |
| --- | --- | --- |
| `connect_dart_tooling_daemon` | Connect to DTD | Connects to the Dart Tooling Daemon. You should get the uri either from available tools or the user, do not just make up a random URI to pass. When asking the user for the uri, you should suggest the "Copy DTD Uri to clipboard" action. When reconnecting after losing a connection, always request a new uri first. |
| `get_runtime_errors` | Get runtime errors | Retrieves the most recent runtime errors that have occurred in the active Dart application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `get_active_location` | Get Active Editor Location | Retrieves the current active location (e.g., cursor position) in the connected editor. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `pub_dev_search` | pub.dev search | Searches pub.dev for packages relevant to a given search query. The response will describe each result with its download count, package description, topics, license, and publisher. |
| `remove_roots` | Remove roots | Removes one or more project roots previously added via the add_roots tool. |
| `add_roots` | Add roots | Adds one or more project roots. Tools are only allowed to run under these roots, so you must call this function before passing any roots to any other tools. |
| `dart_fix` | Dart fix | Runs `dart fix --apply` for the given project roots. |
| `dart_format` | Dart format | Runs `dart format .` for the given project roots. |
| `run_tests` | Run tests | Run Dart tests with an agent centric UX. ALWAYS use instead of `dart test` shell commands. |
| `create_project` | Create project | Creates a new Dart project. |
| `pub` | pub | Runs a pub command for the given project roots, like `dart pub get`. |
| `analyze_files` | Analyze projects | Analyzes the entire project for errors. |
| `resolve_workspace_symbol` | Project search | Look up a symbol or symbols in all workspaces by name. Can be used to validate that a symbol exists or discover small spelling mistakes, since the search is fuzzy. |
| `signature_help` | Signature help | Get signature help for an API being used at a given cursor position in a file. |
| `hover` | Hover information | Get hover information at a given cursor position in a file. This can include documentation, type information, etc for the text at that position. |

## Tools for Flutter

| Tool Name | Title | Description |
| --- | --- | --- |
| `get_runtime_errors` | Get runtime errors | Retrieves the most recent runtime errors that have occurred in the active Flutter application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `hot_reload` | Hot reload | Performs a hot reload of the active Flutter application. This is to apply the latest code changes to the running application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `get_widget_tree` | Get widget tree | Retrieves the widget tree from the active Flutter application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `get_selected_widget` | Get selected widget | Retrieves the selected widget from the active Flutter application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `set_widget_selection_mode` | Set Widget Selection Mode | Enables or disables widget selection mode in the active Flutter application. Requires "connect_dart_tooling_daemon" to be successfully called first. |
| `run_tests` | Run tests | Run Flutter tests with an agent centric UX. ALWAYS use instead of `flutter test` shell commands. |
| `create_project` | Create project | Creates a new Flutter project. |
| `pub` | pub | Runs a pub command for the given project roots, like `flutter pub add`. |

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:dart_mcp/server.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:dart_site_mcp_server/tools/changelog.dart';

final class SiteMcpServer extends MCPServer with ToolsSupport, PromptsSupport {
  SiteMcpServer(super.channel)
    : super.fromStreamChannel(
        implementation: Implementation(
          name: 'dart-site-mcp-server',
          version: '1.0.0',
        ),
      );

  @override
  Future<InitializeResult> initialize(InitializeRequest request) async {
    // Register tools
    final changelogTool = SyncSdkChangelogTool();
    registerTool(changelogTool.toolDef, changelogTool.call);

    // Register prompts
    addPrompt(
      Prompt(
        name: 'update_sdk_changelog',
        description:
            'Workflow instructions for updating the Dart SDK changelog. Use this whenever asked to update, sync, or modify the changelog for a new version.',
      ),
      (request) async {
        final libUri = await Isolate.resolvePackageUri(
          Uri.parse('package:dart_site_mcp_server/'),
        );
        if (libUri == null) {
          throw StateError('Could not resolve package:dart_site_mcp_server/');
        }
        final uri = libUri.resolve('../update_sdk_changelog.md');
        final content = await File.fromUri(uri).readAsString();
        return GetPromptResult(
          description: 'Steps to update SDK changelog',
          messages: [
            PromptMessage(
              role: Role.user,
              content: TextContent(text: content),
            ),
          ],
        );
      },
    );

    // Calling super.initialize is required to set up capabilities
    final result = await super.initialize(request);

    return result;
  }
}

void main(List<String> args) async {
  stderr.writeln(
    'Dart Site MCP Server running on stdio... Waiting for JSON-RPC messages.',
  );
  final channel = stdioChannel(input: stdin, output: stdout);
  final server = SiteMcpServer(channel);

  await server.done;
}

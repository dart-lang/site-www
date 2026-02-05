/// Basic verification script to check if the MCP server starts and lists tools.
/// Verifies the presence of the `sync_sdk_changelog` tool.
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final process = await Process.start('dart', [
    'tool/mcp_server/bin/server.dart',
  ]);

  process.stderr.transform(utf8.decoder).listen((data) {
    print('STDERR: $data');
  });

  // 1. Initialize
  final initRequest = {
    'jsonrpc': '2.0',
    'id': 1,
    'method': 'initialize',
    'params': {
      'protocolVersion': '2024-11-05',
      'capabilities': {},
      'clientInfo': {'name': 'test-client', 'version': '1.0.0'},
    },
  };
  process.stdin.writeln(jsonEncode(initRequest));

  // 2. Wait for initialized response
  // We just listen to stdout and print it
  process.stdout.transform(utf8.decoder).transform(LineSplitter()).listen((
    line,
  ) {
    if (line.trim().isEmpty) return;
    print('STDOUT: $line');

    try {
      final json = jsonDecode(line);
      // If we got init result, send initialized notification
      if (json['id'] == 1) {
        print('Initialization successful. Sending initialized notification...');
        process.stdin.writeln(
          jsonEncode({'jsonrpc': '2.0', 'method': 'notifications/initialized'}),
        );

        // 3. List tools
        print('Listing tools...');
        process.stdin.writeln(
          jsonEncode({'jsonrpc': '2.0', 'id': 2, 'method': 'tools/list'}),
        );
      }

      // If we got tool list, call callTool
      if (json['id'] == 2) {
        print(
          'Tool list received. Tools found: ${(json['result']['tools'] as List).length}',
        );
        // Verify sync_sdk_changelog exists
        final tools = json['result']['tools'] as List;
        final hasChangelog = tools.any(
          (t) => t['name'] == 'sync_sdk_changelog',
        );
        if (hasChangelog) {
          print('SUCCESS: sync_sdk_changelog tool found.');
          // We won't actually call it to avoid modifying the file in this
          // dry run unless requested.
          // But parsing SDK changelog is safe? It writes to file though.
          // User wants verification.
          // Let's call it with a dummy version if we want to test parsing?
          // Or just trust it exists.
          // For now, let's stop here to prove it runs.
          process.kill();
        } else {
          print('FAILURE: sync_sdk_changelog tool NOT found.');
          process.kill();
        }
      }
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  });
}

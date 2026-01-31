import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final version = args.isNotEmpty ? args.first : '3.11.0';
  print('Starting MCP server verification for version: $version ...');
  final process = await Process.start('dart', [
    'tool/mcp_server/bin/server.dart',
  ]);

  final inputLines = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  final stderrLines = process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  stderrLines.listen((line) {
    print('STDERR: $line');
  });

  inputLines.listen((line) {
    print('STDOUT: $line');
    if (line.isNotEmpty) {
      try {
        final json = jsonDecode(line);
        if (json['id'] == 1) {
          print(
            'Initialization successful. Calling sync_sdk_changelog tool (dry run)...',
          );
          // Call tool
          final callToolRequest = {
            'jsonrpc': '2.0',
            'method': 'tools/call',
            'params': {
              'name': 'sync_sdk_changelog',
              'arguments': {'version': version, 'dryRun': true},
            },
            'id': 2,
          };
          process.stdin.writeln(jsonEncode(callToolRequest));
        } else if (json['id'] == 2) {
          print('Tool call result received.');
          // Verify result
          final result = json['result'];
          if (result != null && result['content'] != null) {
            final content = result['content'] as List;
            if (content.isNotEmpty) {
              print('Content received: ${content[0]['text']}');
              if ((content[0]['text'] as String).contains(
                'Dry run successful',
              )) {
                print('SUCCESS: Tool execution verified (dry run).');
                process.kill();
                exit(0);
              } else {
                // If regex fails (e.g. "No entries found"), we also print failure but exit 0 if it's a valid response
                // But user wants to verify it works, so strict check is maybe better.
                // However, "No entries found" is also a valid tool execution.
                if ((content[0]['text'] as String).contains(
                  'No entries found',
                )) {
                  print('SUCCESS: Tool execution verified (no entries found).');
                  process.kill();
                  exit(0);
                }

                print('FAILURE: Unexpected tool output.');
                process.kill();
                exit(1);
              }
            }
          } else if (json['error'] != null) {
            print('FAILURE: Tool returned error: ${json['error']}');
            process.kill();
            exit(1);
          }
        }
      } catch (e) {
        // ignore non-json
      }
    }
  });

  // Init request
  final initRequest = {
    'jsonrpc': '2.0',
    'method': 'initialize',
    'params': {
      'protocolVersion': '2024-11-05',
      'capabilities': {},
      'clientInfo': {'name': 'test-client', 'version': '1.0'},
    },
    'id': 1,
  };

  process.stdin.writeln(jsonEncode(initRequest));

  // Timeout
  await Future.delayed(Duration(seconds: 10));
  print('TIMEOUT: Server did not respond in time.');
  process.kill();
  exit(1);
}

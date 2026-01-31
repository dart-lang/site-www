import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final version = args.isNotEmpty ? args.first : '3.11.0';
  print('Executing SDK changelog sync for version: $version ...');
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
          print('Initialization successful. Calling sync_sdk_changelog tool (WRITE MODE)...');
          // Call tool
          final callToolRequest = {
            'jsonrpc': '2.0',
            'method': 'tools/call',
            'params': {
              'name': 'sync_sdk_changelog',
              'arguments': {'version': version, 'dryRun': false},
            },
            'id': 2,
          };
          process.stdin.writeln(jsonEncode(callToolRequest));
        } else if (json['id'] == 2) {
          // Verify result
          final result = json['result'];
          if (result != null && result['content'] != null) {
            final content = result['content'] as List;
            if (content.isNotEmpty) {
              print('Content received: ${content[0]['text']}');
              if ((content[0]['text'] as String).contains('Successfully added')) {
                 print('SUCCESS: Tool execution verified (changes applied).');
                 process.kill();
                 exit(0);
              } else {
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
      'clientInfo': {'name': 'execute-client', 'version': '1.0'},
    },
    'id': 1,
  };

  process.stdin.writeln(jsonEncode(initRequest));

  // Timeout
  await Future.delayed(Duration(seconds: 15));
  print('TIMEOUT: Server did not respond in time.');
  process.kill();
  exit(1);
}

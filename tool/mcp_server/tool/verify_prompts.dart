/// Verification script to check if the MCP server correctly lists and retrieves
/// prompts. Specifically verifies the `update_sdk_changelog` prompt
/// availability and content.
import 'dart:convert';
import 'dart:io';

void main() async {
  print('Starting MCP server prompt verification...');
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
          print('Initialization successful. Listing prompts...');
          // List prompts
          final listPromptsRequest = {
            'jsonrpc': '2.0',
            'method': 'prompts/list',
            'id': 2,
          };
          process.stdin.writeln(jsonEncode(listPromptsRequest));
        } else if (json['id'] == 2) {
          print('Prompts list received.');
          final result = json['result'];
          if (result != null && result['prompts'] != null) {
            final prompts = result['prompts'] as List;
            print('Found ${prompts.length} prompts.');
            final updatePrompt = prompts.firstWhere(
              (p) => p['name'] == 'update_sdk_changelog',
              orElse: () => null,
            );

            if (updatePrompt != null) {
              print('SUCCESS: Found "update_sdk_changelog" prompt.');
              print('Retrieving prompt content...');
              final getPromptRequest = {
                'jsonrpc': '2.0',
                'method': 'prompts/get',
                'params': {'name': 'update_sdk_changelog'},
                'id': 3,
              };
              process.stdin.writeln(jsonEncode(getPromptRequest));
            } else {
              print('FAILURE: "update_sdk_changelog" prompt not found.');
              process.kill();
              exit(1);
            }
          }
        } else if (json['id'] == 3) {
          print('Prompt content received.');
          final result = json['result'];
          if (result != null && result['messages'] != null) {
            final messages = result['messages'] as List;
            if (messages.isNotEmpty) {
              final content = messages[0]['content'];
              // content can be TextContent or just a check
              print('Message content type: ${content.runtimeType}');
              // In dart_mcp/JSON-RPC, content might be a map
              if (content is Map && content['text'] != null) {
                final text = content['text'] as String;
                if (text.contains('# Update SDK Changelog Workflow')) {
                  print('SUCCESS: Prompt content verified.');
                  print(
                    'Preview (first 50 chars): ${text.substring(0, 50)}...',
                  );
                  process.kill();
                  exit(0);
                } else {
                  print(
                    'FAILURE: Prompt content does not match expected markdown.',
                  );
                  process.kill();
                  exit(1);
                }
              } else {
                // It might be nested differently or just text?
                // TextContent usually serializes to {type: text, text: ...}
                print('Raw content: $content');
                if (content['type'] == 'text' &&
                    (content['text'] as String).contains(
                      '# Update SDK Changelog Workflow',
                    )) {
                  print('SUCCESS: Prompt content verified.');
                  process.kill();
                  exit(0);
                }
              }
            }
          }
          print('FAILURE: Valid prompt content not found.');
          process.kill();
          exit(1);
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
      'capabilities': {'prompts': {}}, // Client supports prompts
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

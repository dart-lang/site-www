import 'dart:collection';
import 'dart:convert';
import 'dart:io';


// NOTE if we use emulate, then firebase-tools will automatically 
// validate redirects for missing/empty strings/keys. So basically 
// all this script does now is check for duplicate redirects...
Future<void> main() async {  
  final fbConfig = File('/app/firebase.json');
  
  if (!(await fbConfig.exists())) {
    stderr.writeln('Cannot find the firebase.json file!');
    exit(1);
  }

  try {
    final configString = await fbConfig.readAsString();
    final config = await jsonDecode(configString);

    final hosting = config['hosting'];
    if (hosting == null) {
      stderr.writeln('Firebase config does not have a "hosting" config');
      exit(1);
    }

    final redirects = hosting['redirects'];
    if (redirects == null) {
      stdout.writeln('Firebase config does not have "redirects"');
      return;
    }

    if (redirects is! List<dynamic> || redirects.isEmpty) {
      stderr.writeln('Firebase redirects not correctly configured');
      exit(1);
    }
    
    var int duplicatesFound = 0;

    for (final redirect in redirects) {
      final source = redirect['source'];

      if (source == null) {
        stderr.writeln('Encountered redirect without "source"');
        exit(1);
      }

      if (source is! String) {
        stderr.writeln('Encountered invalid redirect "source"');
        exit(1);
      }

      if (sources.contains(source)) {
        stderr.writeln('Encountered duplicate redirect "source"');
        duplicatesFound += 1;
      }
    }

    if (duplicatesFound > 0) {
      stderr.writeln('Found $duplicatesFound duplicate redirect sources');
      exit(1);
    }
    
  } catch(e) {
    stderr.writeln('Encountered error while loading firebase.json:');
    print(e.toString());
    exit(1);
  }
}

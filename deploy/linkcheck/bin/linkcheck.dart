import 'dart:async';

import 'package:args/args.dart';
import 'package:linkcheck/linkcheck.dart';

Future<Null> main(List<String> arguments) async {
  final parser = new ArgParser()
    ..addFlag(helpFlag,
        abbr: 'h', negatable: false, help: "Prints usage and exits.")
    ..addFlag(verboseFlag, abbr: 'v', negatable: false, help: "Verbose mode.")
    ..addOption(hostsFlag,
        allowMultiple: true,
        splitCommas: true,
        help: "Additional hosts (domains) to check.")
    ..addFlag(externalFlag,
        abbr: 'e', negatable: false, help: "Check external links, too.");
  final argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    print(parser.usage);
    return;
  }

  bool verbose = argResults[verboseFlag];
  bool shouldCheckExternal = argResults[externalFlag];

  final List<String> urls = argResults.rest.toList();
  if (urls.isEmpty) {
    urls.add("http://localhost:4000");
  }

  List<Uri> uris = urls.map((url) => Uri.parse(url)).toList();
  Set<String> hosts = uris.map((uri) => uri.host).toSet();
  hosts.addAll(argResults[hostsFlag] as Iterable<String>);

  List<Link> broken = await check(uris, hosts, shouldCheckExternal, verbose);

  reportForWriters(broken);
}

const externalFlag = "external";
const helpFlag = "help";
const hostsFlag = "hosts";
const verboseFlag = "verbose";

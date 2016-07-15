import 'dart:async';

import 'package:args/args.dart';
import 'package:linkcheck/linkcheck.dart';

Future<Null> main(List<String> arguments) async {
  final parser = new ArgParser()
    ..addFlag(helpFlag,
        abbr: 'h', negatable: false, help: "Prints usage.")
    ..addFlag(verboseFlag, abbr: 'v', negatable: false, help: "Verbose mode.")
    ..addOption(hostsFlag,
        allowMultiple: true,
        splitCommas: true,
        help: "Additional hosts (domains) to check. By default, the crawler "
            "doesn't parse HTML on sites with different host than the starting"
            "ones. If your site spans multiple domains and you want to check "
            "HTML everywhere, use this.")
    ..addFlag(externalFlag,
        abbr: 'e', negatable: false, help: "Check external links, too. By "
            "default, the tool only checks internal links.");
  final argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    print("Linkcheck will crawl given site and check links.\n");
    print("usage: linkcheck [switches] [url]");
    print(parser.usage);
    return;
  }

  bool verbose = argResults[verboseFlag];
  bool shouldCheckExternal = argResults[externalFlag];

  final List<String> urls = argResults.rest.toList();
  if (urls.isEmpty) {
    print("No URL given, checking $defaultUrl");
    urls.add(defaultUrl);
  }

  List<Uri> uris = urls.map((url) => Uri.parse(url)).toList();
  Set<String> hosts = uris.map((uri) => uri.host).toSet();
  hosts.addAll(argResults[hostsFlag] as Iterable<String>);

  List<Link> links = await check(uris, hosts, shouldCheckExternal, verbose);

  var broken = links
      .where((link) => link.destination.wasTried && link.destination.isBroken)
      .toList(growable: false);

  print("\n\nStats:");
  print("${links.length.toString().padLeft(8)} links checked");
  print("${broken.length.toString().padLeft(8)} possibly broken links found");
  print("");

  reportForWriters(broken);
}

const externalFlag = "external";
const helpFlag = "help";
const hostsFlag = "hosts";
const verboseFlag = "verbose";

const defaultUrl = "http://localhost:4000/";

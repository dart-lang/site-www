import 'dart:async';
import 'dart:convert';
import 'dart:html';

const String storageApiBase =
    "https://www.googleapis.com/storage/v1/b/dart-archive/o";
const String storageBase = "https://storage.googleapis.com/dart-archive";
Map<String, TableElement> tables = {
  'stable': querySelector("#stable"),
  'dev': querySelector('#dev')
};
Map<String, SelectElement> versionSelectors = {
  'stable': querySelector('#stable-versions'),
  'dev': querySelector('#dev-versions')
};
Map<String, SelectElement> osSelectors = {
  'stable': querySelector('#stable-os'),
  'dev': querySelector('#dev-os')
};

void main() {
  HttpRequest
      .getString("$storageApiBase?prefix=channels/stable/release/&delimiter=/")
      .then((resp) {
    getListing('stable', resp);
  });
  HttpRequest
      .getString("$storageApiBase?prefix=channels/dev/release/&delimiter=/")
      .then((resp) {
    getListing('dev', resp);
  });

  versionSelectors['stable'].onChange.listen((Event event) {
    filterTable('stable', event);
  });
  versionSelectors['dev'].onChange.listen((Event event) {
    filterTable('dev', event);
  });
  osSelectors['stable'].onChange.listen((Event event) {
    filterTable('stable', event);
  });
  osSelectors['dev'].onChange.listen((Event event) {
    filterTable('dev', event);
  });
}

void filterTable(String channel, Event event) {
  String selectedVersion =
      versionSelectors[channel].selectedOptions[0].attributes['value'];
  String selectedOs =
      osSelectors[channel].selectedOptions[0].attributes['value'];
  if (selectedVersion == 'all' && selectedOs == 'all') {
    tables[channel].querySelectorAll('tr[data-version]').classes
        .remove('hidden');
  } else {
    tables[channel].querySelectorAll('tr[data-version]').classes.add('hidden');
    String selector = 'tr';
    if (selectedVersion != 'all') {
      selector += '[data-version="$selectedVersion"]';
    }
    tables[channel].querySelectorAll(selector + '[data-os="api"]').classes
        .remove('hidden');
    if (selectedOs != 'all') {
      selector += '[data-os="$selectedOs"]';
    }
    tables[channel].querySelectorAll(selector).classes.remove('hidden');
  }
}

DateTime parseDateTime(String date) {
  try {
    return DateTime.parse(date);
  } catch (_) {}

  if (date.length == 12) {
    // Old dates show up like '201504230115', put them in a format that
    // DateTime.parse understands.
    return DateTime.parse('${date.substring(0, 4)}-${date.substring(4, 6)}-'
        '${date.substring(6, 8)} ${date.substring(8, 10)}:'
        '${date.substring(10, 12)}');
  }

  throw 'unrecognized DateTime format: $date';
}

Future getListing(String channel, String respString) async {
  Map<String, Object> resp = JSON.decode(respString);
  List<String> versions = (resp["prefixes"] as List<String>);
  versions.removeWhere((e) => e.contains('latest'));

  // Format is lines of "channels/stable/release/\d+/".
  Iterable<Future> versionRequests = versions.map((String path) async {
    try {
      return await HttpRequest.getString("$storageBase/${path}VERSION");
    } catch (error) {
      // TODO(rnystrom): Figure out why this is happening.
      // Some directories seem to not be valid. If that happens, just ignore
      // them. (We'll filter out the null entries below).
      return null;
    }
  });

  List<String> versionStrings = (await Future.wait(versionRequests))
      .where((version) => version != null)
      .map((e) => JSON.decode(e))
      .toList();

  versionStrings.sort(
      (a, b) => parseDateTime(b['date']).compareTo(parseDateTime(a['date'])));
  for (var version in versionStrings) {
    addVersion(channel, version);
  }

  versionSelectors[channel].options[1].selected = true;
  versionSelectors[channel].dispatchEvent(new Event("change"));
}

const Map<String, String> archiveMap = const {
  'Mac': 'macos',
  'Linux': 'linux',
  'Windows': 'windows',
  '32-bit': 'ia32',
  '64-bit': 'x64',
  'ARMv7': 'arm',
  'Dart SDK': 'dartsdk',
  'Dartium': 'dartium'
};

const Map<String, String> directoryMap = const {
  'Dart SDK': 'sdk',
  'Dartium': 'dartium'
};

const Map<String, String> suffixMap = const {
  'Dart SDK': '-release.zip',
  'Dartium': '-release.zip'
};

const Map<String, Object> platforms = const {
  'Mac': const {
    '32-bit': const ['Dart SDK', 'Dartium'],
    '64-bit': const ['Dart SDK']
  },
  'Linux': const {
    'ARMv7': const ['Dart SDK'],
    '32-bit': const ['Dart SDK', 'Dartium'],
    '64-bit': const ['Dart SDK', 'Dartium']
  },
  'Windows': const {
    '32-bit': const ['Dart SDK', 'Dartium'],
    '64-bit': const ['Dart SDK']
  },
};

void addVersion(String channel, Map<String, String> version) {
  OptionElement o = new OptionElement()
    ..text = version['version']
    ..attributes['value'] = version['version'];
  versionSelectors[channel].children.add(o);

  // Attempt to parse the revision number, this only works for
  // pre-github revisions.
  int parsedRevision = int.parse(version['revision'], onError: (_) => null);

  /// Use the revision number for anything <= 1.11.0-dev.0.0 (rev 45519)
  /// and the version string for later ones.
  String versionString;
  if (parsedRevision != null) {
    versionString = parsedRevision.toString();
  } else {
    versionString = version['version'];
  }

  String prettyRevRef;
  if (parsedRevision != null) {
    prettyRevRef = 'r$parsedRevision';
  } else {
    prettyRevRef = 'ref ${version['revision'].substring(0, 7)}';
  }

  // Json is like: { 'revision': '...', 'version': '...', 'date': '...' }.
  platforms.forEach((String name, Map<String, List> widthListings) {
    widthListings.forEach((String width, List<String> archives) {
      // ARMv7 builds only available later in 2015 
      if (archiveMap[name] == 'linux' &&
          width == 'ARMv7' &&
          parseDateTime(version['date']).isBefore(DateTime
              .parse((channel == "dev") ? '2015-10-21' : '2015-08-31'))) {
        return;
      } 
 
      TableRowElement row = tables[channel].addRow()
        ..attributes['data-version'] = version['version']
        ..attributes['data-os'] = archiveMap[name];

      var versionCell = row.addCell()..text = version['version'];

      versionCell.append(new SpanElement()
        ..text = '  (${prettyRevRef})'
        ..classes.add('muted'));

      row.addCell()..text = name;
      row.addCell()
        ..classes.add('nowrap')
        ..text = width;
      List<String> possibleArchives = ['Dart SDK', 'Dartium'];
      TableCellElement c = row.addCell()..classes.add('archives');
      possibleArchives.forEach((String pa) {
        if (archives.contains(pa)) {

          // We had no editor downloads after the move to GitHub.
          // This skips the editor link in those cases
          if (parsedRevision == null && pa == 'Dart Editor') {
            return;
          }

          String uri = '$storageBase/channels/$channel/release/$versionString'
              '/${directoryMap[pa]}/${archiveMap[pa]}-${archiveMap[name]}-'
              '${archiveMap[width]}${suffixMap[pa]}';
          c.append(new AnchorElement()
            ..text = pa
            ..attributes['href'] = uri);
          if (pa != 'Dart Editor' &&
              (parsedRevision == null || parsedRevision > 38976)) {
            c.append(new AnchorElement()
              ..text = "(SHA-256)"
              ..attributes['href'] = '$uri.sha256sum'
              ..classes.add('sha'));
          }
          c.append(new Element.br());
        }
      });
    });
  });

  TableRowElement row = tables[channel].addRow()
    ..attributes['data-version'] = version['version']
    ..attributes['data-os'] = 'api';
  var rev = new SpanElement()
    ..text = '  (${prettyRevRef})'
    ..classes.add('muted');
  row.addCell()
    ..text = version['version']
    ..append(rev);
  row.addCell()..text = '---';
  row.addCell()..text = '---';
  TableCellElement c = row.addCell()..classes.add('archives');
  String uri = '$storageBase/channels/$channel/release/${versionString}/' +
      'api-docs/dartdocs-gen-api.zip';
  c.append(new AnchorElement()
    ..text = 'API docs'
    ..attributes['href'] = uri);

  List<Element> templateRows = tables[channel].querySelectorAll('.template');
  if (templateRows != null) {
    templateRows.forEach((row) {
      row.remove();
    });
  }
}

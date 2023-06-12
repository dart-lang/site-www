@Tags(['browser'])
@TestOn('browser')
library;

import 'dart:async';
import 'dart:html';
import 'package:test/test.dart';
import 'package:examples_util/logger.dart';

void main() {
  test('querySelector', () {
    final html =
        // #docregion anchor-html
        '<a id="example" href="/another/example">link text</a>';
    // #enddocregion anchor-html
    document.body!.appendHtml(html);

    // #docregion href
    var anchor = querySelector('#example') as AnchorElement;
    // #enddocregion href
    expect(anchor.href, endsWith('/another/example'));
    // #docregion href
    anchor.href = 'https://dart.dev';
    // #enddocregion href
    expect(anchor.href, 'https://dart.dev/');
  });

  test('querySelectorAll', () {
    // #docregion os-html
    const html = '''<!-- In HTML: -->
    <p>
      <span class="linux">Words for Linux</span>
      <span class="macos">Words for Mac</span>
      <span class="windows">Words for Windows</span>
    </p>''';
    // #enddocregion os-html
    document.body!.appendHtml(html);

    String determineUserOs() => 'linux';
    // #docregion os
    // In Dart:
    const osList = ['macos', 'windows', 'linux'];
    final userOs = determineUserOs();

    // For each possible OS...
    for (final os in osList) {
      // Matches user OS?
      bool shouldShow = (os == userOs);

      // Find all elements with class=os. For example, if
      // os == 'windows', call querySelectorAll('.windows')
      // to find all elements with the class "windows".
      // Note that '.$os' uses string interpolation.
      for (final elem in querySelectorAll('.$os')) {
        elem.hidden = !shouldShow; // Show or hide.
      }
    }
    // #enddocregion os
    expect(querySelector('.linux')!.hidden, isFalse);
    expect(querySelector('.macos')!.hidden, isTrue);
    expect(querySelector('.windows')!.hidden, isTrue);
  });

  test('getString', skip: 'httpbin timing out', () async {
    final url = 'https://httpbin.org';
    // #docregion getString
    Future<void> main() async {
      String pageHtml = await HttpRequest.getString(url);
      // Do something with pageHtml...
      // #enddocregion getString
      expect(
        pageHtml.substring(0, 250),
        contains('<title>httpbin'),
      );
      // #docregion getString
    }
    // #enddocregion getString

    await main();
  });

  test('request', skip: 'httpbin timing out', () async {
    final url = 'https://httpbin.org/headers';
    // #docregion request
    Future<void> main() async {
      HttpRequest req = await HttpRequest.request(
        url,
        method: 'HEAD',
      );
      if (req.status == 200) {
        // Successful URL access...
      }
      // #enddocregion request
      expect(req.status, 200);
      // #docregion request
    }
    // #enddocregion request

    await main();
  });

  test('POST', skip: 'httpbin timing out', () async {
    const url = 'https://httpbin.org/post';
    // #docregion POST
    String encodeMap(Map<String, String> data) => data.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    void main() async {
      const data = {'dart': 'fun', 'angular': 'productive'};

      var request = HttpRequest();
      request
        ..open('POST', url)
        ..setRequestHeader(
          'Content-type',
          'application/x-www-form-urlencoded',
        )
        ..send(encodeMap(data));

      await request.onLoadEnd.first;

      if (request.status == 200) {
        // Successful URL access...
      }
      // #enddocregion POST
      print('Request status: ${request.status}');
      // #docregion POST
    }
    // #enddocregion POST

    expect(main, prints('Request status: 200\n'));
  });

  test('WebSockets', () async {
    final logger = Logger();
    final print = logger.print; // shadow global print
    final wsStream = StreamController<String>();

    // #docregion WebSocket
    var ws = WebSocket('ws://echo.websocket.org');
    // #enddocregion WebSocket

    // #docregion initWebSocket
    void initWebSocket([int retrySeconds = 1]) {
      var reconnectScheduled = false;

      print('Connecting to websocket');

      void scheduleReconnect() {
        if (!reconnectScheduled) {
          Timer(Duration(seconds: retrySeconds),
              () => initWebSocket(retrySeconds * 2));
        }
        reconnectScheduled = true;
      }

      ws.onOpen.listen((e) {
        print('Connected');
        // #docregion send
        ws.send('Hello from Dart!');
        // #enddocregion send
      });

      ws.onClose.listen((e) {
        print('Websocket closed, retrying in $retrySeconds seconds');
        scheduleReconnect();
      });

      ws.onError.listen((e) {
        print('Error connecting to ws');
        scheduleReconnect();
      });

      // #docregion onMessage
      ws.onMessage.listen((MessageEvent e) {
        print('Received message: ${e.data}');
        // #enddocregion initWebSocket, onMessage
        wsStream.add(('Received message'));
        // #docregion initWebSocket, onMessage
      });
      // #enddocregion onMessage
    }
    // #enddocregion initWebSocket

    final t = wsStream.stream.timeout(
      const Duration(seconds: 5),
      onTimeout: (s) => s.add('Timeout!'),
    );

    // Under heavy loads we don't get a response,
    // so let's accept the possibility of a timeout.
    try {
      initWebSocket();
      expect(
          await t.first,
          anyOf([
            contains('Received message'),
            contains('Timeout'),
          ]));
    } finally {
      await wsStream.close();
    }
  });
}

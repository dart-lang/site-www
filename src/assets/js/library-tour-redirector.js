const oldToNew = {
    'dartcore---numbers-collections-strings-and-more': '/libraries/dart-core',
    'dartcore': '/libraries/dart-core',
    'printing-to-the-console': '/libraries/dart-core#printing-to-the-console',
    'strings-and-regular-expressions': '/libraries/dart-core#strings-and-regular-expressions',
    'searching-inside-a-string': '/libraries/dart-core#searching-inside-a-string',
    'extracting-data-from-a-string': '/libraries/dart-core#extracting-data-from-a-string',
    'converting-to-uppercase-or-lowercase': '/libraries/dart-core#converting-to-uppercase-or-lowercase',
    'trimming-and-empty-strings': '/libraries/dart-core#trimming-and-empty-strings',
    'replacing-part-of-a-string': '/libraries/dart-core#replacing-part-of-a-string',
    'building-a-string': '/libraries/dart-core#building-a-string',
    'regular-expressions': '/libraries/dart-core#regular-expressions',
    'collections': '/libraries/dart-core#collections',
    'lists': '/libraries/dart-core#lists',
    'sets': '/libraries/dart-core#sets',
    'maps': '/libraries/dart-core#maps',
    'common-collection-methods': '/libraries/dart-core#common-collection-methods',
    'uris': '/libraries/dart-core#uris',
    'encoding-and-decoding-fully-qualified-uris': '/libraries/dart-core#encoding-and-decoding-fully-qualified-uris',
    'encoding-and-decoding-uri-components': '/libraries/dart-core#encoding-and-decoding-uri-components',
    'parsing-uris': '/libraries/dart-core#parsing-uris',
    'building-uris': '/libraries/dart-core#building-uris',
    'dates-and-times': '/libraries/dart-core#dates-and-times',
    'utility-classes': '/libraries/dart-core#utility-classes',
    'comparing-objects': '/libraries/dart-core#comparing-objects',
    'implementing-map-keys': '/libraries/dart-core#implementing-map-keys',
    'iteration': '/libraries/dart-core#iteration',
    'exceptions': '/libraries/dart-core#exceptions',
    'weak-references-and-finalizers': '/libraries/dart-core#weak-references-and-finalizers',

    'dartasync---asynchronous-programming': '/libraries/dart-async',
    'dartasync': '/libraries/dart-async',
    'futures': '/libraries/dart-async#futures',
    'using-await': '/libraries/dart-async#using-await',
    'basic-usage': '/libraries/dart-async#basic-usage',
    'chaining-multiple-asynchronous-methods': '/libraries/dart-async#chaining-multiple-asynchronous-methods',
    'waiting-for-multiple-futures': '/libraries/dart-async#waiting-for-multiple-futures',
    'handling-errors-for-multiple-futures': '/libraries/dart-async#handling-errors-for-multiple-futures',
    'streams': '/libraries/dart-async#streams',
    'using-an-asynchronous-for-loop': '/libraries/dart-async#using-an-asynchronous-for-loop',
    'listening-for-stream-data': '/libraries/dart-async#listening-for-stream-data',
    'transforming-stream-data': '/libraries/dart-async#transforming-stream-data',
    'handling-errors-and-completion': '/libraries/dart-async#handling-errors-and-completion',

    'dartmath---math-and-random': '/libraries/dart-math',
    'dartmath': '/libraries/dart-math',
    'trigonometry': '/libraries/dart-math#trigonometry',
    'maximum-and-minimum': '/libraries/dart-math#maximum-and-minimum',
    'math-constants': '/libraries/dart-math#math-constants',
    'random-numbers': '/libraries/dart-math#random-numbers',

    'dartconvert---decoding-and-encoding-json-utf-8-and-more': '/libraries/dart-convert',
    'dartconvert': '/libraries/dart-convert',
    'decoding-and-encoding-json': '/libraries/dart-convert#decoding-and-encoding-json',
    'decoding-and-encoding-utf-8-characters': '/libraries/dart-convert#decoding-and-encoding-utf-8-characters',
    'other-functionality': '/libraries/dart-convert#other-functionality',

    'darthtml-browser-based-apps': '/libraries/dart-html',
    'darthtml': '/libraries/dart-html',
    'manipulating-the-dom': '/libraries/dart-html#manipulating-the-dom',
    'finding-elements': '/libraries/dart-html#finding-elements',
    'manipulating-elements': '/libraries/dart-html#manipulating-elements',
    'creating-elements': '/libraries/dart-html#creating-elements',
    'adding-replacing-and-removing-nodes': '/libraries/dart-html#adding-replacing-and-removing-nodes',
    'manipulating-css-styles': '/libraries/dart-html#manipulating-css-styles',
    'handling-events': '/libraries/dart-html#handling-events',
    'using-http-resources-with-httprequest': '/libraries/dart-html#using-http-resources-with-httprequest',
    'sending-and-receiving-real-time-data-with-websockets': '/libraries/dart-html#sending-and-receiving-real-time-data-with-websockets',
    'sending-data': '/libraries/dart-html#sending-data',
    'receiving-data': '/libraries/dart-html#receiving-data',
    'handling-websocket-events': '/libraries/dart-html#handling-websocket-events',

    'dartio-io-for-servers-and-command-line-apps': '/libraries/dart-io',
    'dartio': '/libraries/dart-io',
    'files-and-directories': '/libraries/dart-io#files-and-directories',
    'reading-a-file-as-text': '/libraries/dart-io#reading-a-file-as-text',
    'reading-a-file-as-binary': '/libraries/dart-io#reading-a-file-as-binary',
    'handling-errors': '/libraries/dart-io#handling-errors',
    'streaming-file-contents': '/libraries/dart-io#streaming-file-contents',
    'writing-file-contents': '/libraries/dart-io#writing-file-contents',
    'listing-files-in-a-directory': '/libraries/dart-io#listing-files-in-a-directory',
    'other-common-functionality': '/libraries/dart-io#other-common-functionality',
    'http-clients-and-servers': '/libraries/dart-io#http-clients-and-servers',
    'http-server': '/libraries/dart-io#http-server',
    'http-client': '/libraries/dart-io#http-client',
};

function toDefault() {
    window.location.replace('/libraries');
}

function handleRedirect() {
    const rawOldFragment = window.location.hash;

    // If no fragment was specified, go to 'Dart introduction' page.
    if (!rawOldFragment) {
        toDefault();
        return;
    }

    const oldFragmentWithHash = rawOldFragment.trim().toLowerCase();

    // If the fragment is empty, go to 'Dart library overview' page.
    if (oldFragmentWithHash.length === 0) {
        toDefault();
        return;
    }

    const oldFragment = oldFragmentWithHash.substring(1);

    // If the fragment did not exist, go to 'Dart library overview' page.
    if (!(oldFragment in oldToNew)) {
        toDefault();
        return;
    }

    const newDestination = oldToNew[oldFragment];

    // If the desired destination exists, go there.
    // Otherwise, go to 'Dart library overview' page.
    fetch(newDestination)
        .then((response) => {
            if (response.status === 200) {
                window.location.replace(newDestination);
            } else {
                toDefault();
            }
        }).catch((_) => toDefault());
}

const currentLocation = window.location.href;

if (currentLocation.includes('library-tour')) {
    handleRedirect();
}

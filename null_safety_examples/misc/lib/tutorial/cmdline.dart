import 'dart:io';

void printEnvVar() {
  // #docregion env
  final envVarMap = Platform.environment;

  print('PWD = ${envVarMap['PWD']}');
  print('LOGNAME = ${envVarMap['LOGNAME']}');
  print('PATH = ${envVarMap['PATH']}');
  // #enddocregion env
}

Future<void> writeQuote() async {
  // #docregion write-quote
  final quotes = File('quotes.txt');
  const stronger = 'That which does not kill us makes us stronger. -Nietzsche';

  await quotes.writeAsString(stronger, mode: FileMode.append);
  // #enddocregion write-quote
  print('Data written.');
}

Future<void> writeQuotes() async {
  // #docregion write-quotes
  final quotes = File('quotes.txt').openWrite(mode: FileMode.append);

  quotes.write("Don't cry because it's over, ");
  quotes.writeln('smile because it happened. -Dr. Seuss');
  await quotes.close();
  // #enddocregion write-quotes
  print('Done!');
}

// Not currently used
Future<void> writeQuoteTryCatch() async {
  final quotesFile = File('quotes.txt');
  const stronger = 'That which does not kill us makes us stronger. -Nietzsche';

  try {
    await quotesFile.writeAsString(stronger, mode: FileMode.append);
    print('Data written.');
  } catch (e) {
    print('Oops!');
  }
}

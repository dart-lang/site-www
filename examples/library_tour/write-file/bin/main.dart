import 'dart:io';

void overwriteFile() {
  var logFile = new File('log.txt');
  var sink = logFile.openWrite();
  sink.write('FILE ACCESSED ${new DateTime.now()}\n');
  sink.close();
}

void appendToFile() {
  var logFile = new File('betterLog.txt');
  var sink = logFile.openWrite(mode: FileMode.APPEND);
  sink.write('FILE ACCESSED ${new DateTime.now()}\n');
  sink.close();
}

void writeBinary() {
  var binaryFile = new File('copyOfIcon.ico');
  var sink = binaryFile.openWrite();
  var icoFile = new File('icon.ico'); // UNUSED in CH03
  var data = icoFile.openSync().readSync(icoFile.lengthSync()); //UNUSED in CH03
  sink.add(data);
  sink.close();
}

void main() {
  overwriteFile();
  appendToFile();
  writeBinary();
}

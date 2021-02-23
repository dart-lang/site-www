import 'dart:io';

final _majorVersNum = RegExp(r'(\d+)\.');

final int dartMajorVers =
    int.parse(_majorVersNum.firstMatch(Platform.version)![1]!);

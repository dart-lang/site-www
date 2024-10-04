// ignore_for_file: unused_import, duplicate_import
import 'foo/file_system.dart';
import 'foo/slider_menu.dart';

//----------------------------------------------------------------------------

// #docregion import-as
import 'dart:math' as math;
import 'package:examples/effective_dart/foo.dart' as angular_components;
import 'package:examples/effective_dart/bar.dart' as js;
// #enddocregion import-as

//----------------------------------------------------------------------------

// #docregion dart-import-first
import 'dart:async';
import 'dart:html';

// #docregion pkg-import-before-local, sorted
import 'package:examples/effective_dart/bar/bar.dart';
import 'package:examples/effective_dart/foo/foo.dart';
// #enddocregion dart-import-first, pkg-import-before-local, sorted

// #docregion pkg-import-before-local, sorted

import 'foo.dart';
// #enddocregion pkg-import-before-local
import 'foo/foo.dart';
// #enddocregion sorted

//----------------------------------------------------------------------------
// #docregion export
import 'src/error.dart';
import 'src/foo_bar.dart';

export 'src/error.dart';
// #enddocregion export

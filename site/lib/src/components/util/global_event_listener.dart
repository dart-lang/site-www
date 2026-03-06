// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

final class GlobalEventListener extends StatefulComponent {
  const GlobalEventListener(this.child, {this.onClick, this.onKeyDown});

  final Component child;
  final void Function(web.MouseEvent)? onClick;
  final void Function(web.KeyboardEvent)? onKeyDown;

  @override
  State<GlobalEventListener> createState() => _GlobalClickListenerState();
}

class _GlobalClickListenerState extends State<GlobalEventListener> {
  StreamSubscription<web.MouseEvent>? _clickSubscription;
  StreamSubscription<web.KeyboardEvent>? _keyDownSubscription;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      if (component.onClick case final onClick?) {
        _clickSubscription = web.EventStreamProviders.clickEvent
            .forTarget(web.document)
            .listen(onClick);
      }
      if (component.onKeyDown case final onKeyDown?) {
        _keyDownSubscription = web.EventStreamProviders.keyDownEvent
            .forTarget(web.document)
            .listen(onKeyDown);
      }
    }
  }

  @override
  void didUpdateComponent(GlobalEventListener oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (kIsWeb) {
      _clickSubscription = _updateListener(
        component.onClick,
        oldComponent.onClick,
        _clickSubscription,
        web.EventStreamProviders.clickEvent,
      );
      _keyDownSubscription = _updateListener(
        component.onKeyDown,
        oldComponent.onKeyDown,
        _keyDownSubscription,
        web.EventStreamProviders.keyDownEvent,
      );
    }
  }

  StreamSubscription<T>? _updateListener<T extends web.Event>(
    void Function(T)? newCallback,
    void Function(T)? oldCallback,
    StreamSubscription<T>? subscription,
    web.EventStreamProvider<T> provider,
  ) {
    if (newCallback != oldCallback) {
      unawaited(subscription?.cancel());
      if (newCallback case final callback?) {
        return provider.forTarget(web.document).listen(callback);
      }
      return null;
    }
    return subscription;
  }

  @override
  void dispose() {
    unawaited(_clickSubscription?.cancel());
    unawaited(_keyDownSubscription?.cancel());
    super.dispose();
  }

  @override
  Component build(BuildContext _) => component.child;
}

// ignore_for_file: annotate_overrides, type_annotate_public_apis, strict_raw_type
import 'dart:async';

abstract class MyStream<T> implements Stream<T> {
  // #docregion main-stream-members
  Future<T> get first;
  Future<bool> get isEmpty;
  Future<T> get last;
  Future<int> get length;
  Future<T> get single;
  Future<bool> any(bool Function(T element) test);
  Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert);
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert);
  Stream<R> cast<R>();
  Future<bool> contains(Object? needle);
  Stream<T> distinct([bool Function(T previous, T next)? equals]);
  Future<E> drain<E>([E? futureValue]);
  Future<T> elementAt(int index);
  Future<bool> every(bool Function(T element) test);
  Stream<S> expand<S>(Iterable<S> Function(T element) convert);
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse});
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine);
  Future forEach(void Function(T element) action);
  Future<String> join([String separator = '']);
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse});
  Stream<S> map<S>(S Function(T event) convert);
  Future pipe(StreamConsumer<T> streamConsumer);
  Future<T> reduce(T Function(T previous, T element) combine);
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse});
  Stream<T> skip(int count);
  Stream<T> skipWhile(bool Function(T element) test);
  Stream<T> take(int count);
  Stream<T> takeWhile(bool Function(T element) test);
  Future<List<T>> toList();
  Future<Set<T>> toSet();
  Stream<T> where(bool Function(T event) test);
  // #enddocregion main-stream-members

  bool get isBroadcast;

  Stream<T> asBroadcastStream(
      {void Function(StreamSubscription<T> subscription)? onListen,
      void Function(StreamSubscription<T> subscription)? onCancel});

  // #docregion special-stream-members
  Stream<T> handleError(Function onError, {bool Function(dynamic error)? test});
  Stream<T> timeout(Duration timeLimit,
      {void Function(EventSink<T> sink)? onTimeout});
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer);
  // #enddocregion special-stream-members

  // #docregion listen
  StreamSubscription<T> listen(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError});
  // #enddocregion listen
}

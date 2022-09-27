import 'package:rxdart/rxdart.dart';

///
/// Special streamable value container (storage), similar to [BehaviorSubject], with the ability to emit
/// value and error changes. It differs from the [BehaviorSubject] in the ability to accept new values and errors
/// even after it is closed, but those changes are not emitted.
///
/// Useful for the cases when you need a flexible container (storage) for a value or an error and you need to
/// emit those when either changes, but don't want to be limited by a stream lifecycle.
///
class Streamable<T> {
  final _behaviorSubject = BehaviorSubject<T>();

  T _value;

  /// Create [Streamable]
  Streamable(this._value);

  /// Value stream
  ValueStream<T> get stream => _behaviorSubject.stream;

  /// Get latest value
  T get value => _value;

  /// Get latest error

  /// Set new value and emit it (only if stream is open)
  set value(T value) => add(value);

  /// Set new value and emit it (only if stream is open)
  void add(T value) {
    _value = value;

    if (!_behaviorSubject.isClosed) {
      _behaviorSubject.add(value);
    }
  }

  /// Close the stream
  void close() {
    _behaviorSubject.close();
  }

  /// Is stream closed
  bool get isClosed => _behaviorSubject.isClosed;
}

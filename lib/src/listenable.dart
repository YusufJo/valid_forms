import 'package:meta/meta.dart';

/// Provides a simple change notification api.
abstract class Listenable {
  Listenable() : _listeners = [];

  /// void callbacks to be invoked when a change happens.
  late final List<void Function()> _listeners;

  /// register a callback.
  @mustCallSuper
  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) _listeners.add(listener);
  }

  /// unregister a callback.
  @mustCallSuper
  void removeListener(void Function() listener) {
    if (!_listeners.contains(listener)) return;
    _listeners.remove(listener);
  }

  /// invokes all callbacks. This method should be called whenever
  /// a change that the listeners are interested in happens.
  @protected
  @visibleForTesting
  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// unregisters all listeners.
  @mustCallSuper
  void dispose() {
    while (_listeners.isNotEmpty) {
      removeListener(_listeners.last);
    }
  }
}

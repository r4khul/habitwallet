/// Performance utilities for achieving 60+ FPS with zero jank.
///
/// Contains memoization helpers, frame-aware scheduling, and
/// widget optimization utilities for low-end device support.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Debounces rapid state updates to prevent frame drops.
///
/// Use this for user input that triggers expensive computations.
class Debouncer {
  Debouncer({this.milliseconds = 100});

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Throttles state updates to a maximum frequency.
///
/// Unlike debounce, throttle executes immediately then ignores
/// subsequent calls until the cooldown expires.
class Throttler {
  Throttler({this.milliseconds = 100});

  final int milliseconds;
  DateTime? _lastCall;

  void run(VoidCallback action) {
    final now = DateTime.now();
    if (_lastCall == null ||
        now.difference(_lastCall!).inMilliseconds >= milliseconds) {
      _lastCall = now;
      action();
    }
  }
}

/// Schedules a callback for the next frame using post-frame callback.
///
/// Useful for deferring expensive operations until after the current
/// frame has been rendered to prevent jank.
void schedulePostFrame(VoidCallback callback) {
  SchedulerBinding.instance.addPostFrameCallback((_) => callback());
}

/// Schedules work to run during idle time.
///
/// For non-urgent computations that can be deferred.
void scheduleIdle(VoidCallback callback) {
  SchedulerBinding.instance.scheduleTask(callback, Priority.idle);
}

/// Memoizes a computation result with a simple single-value cache.
///
/// Use for expensive pure functions that are called repeatedly
/// with the same input.
class Memoizer<T, R> {
  T? _lastInput;
  R? _lastResult;

  R call(T input, R Function(T) computation) {
    if (_lastInput == input && _lastResult != null) {
      return _lastResult!;
    }
    _lastResult = computation(input);
    _lastInput = input;
    return _lastResult!;
  }

  void clear() {
    _lastInput = null;
    _lastResult = null;
  }
}

/// Multi-key memoizer for functions with multiple parameters.
class MultiKeyMemoizer<R> {
  List<dynamic>? _lastKeys;
  R? _lastResult;

  R call(List<dynamic> keys, R Function() computation) {
    if (_lastKeys != null &&
        listEquals(_lastKeys, keys) &&
        _lastResult != null) {
      return _lastResult!;
    }
    _lastResult = computation();
    _lastKeys = List.from(keys);
    return _lastResult!;
  }

  void clear() {
    _lastKeys = null;
    _lastResult = null;
  }
}

/// Extension for frame-aware async operations.
extension FrameAwareAsync<T> on Future<T> {
  /// Awaits this future but yields to the frame scheduler between
  /// expensive operations to maintain 60 FPS.
  Future<T> get yieldToFrame async {
    await Future<void>.delayed(Duration.zero);
    return this;
  }
}

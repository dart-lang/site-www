/// NOTE: This is a toy task interceptor, not one you'd use in a real app!
import 'dart:async';
import 'dart:collection';

/// A task scheduled with a timer.
class _TimerTask extends LinkedListEntry {
  int scheduledAtTime;
  Function task;

  _TimerTask(this.scheduledAtTime, this.task);
}

/// Our implementation of the Timer interface.
class _Timer implements Timer {
  bool _isActive = true;
  bool get isActive => _isActive;
  void cancel() {
    _isActive = false;
  }
}

/// The class that simulates Dart's event-loop and timer behavior.
class EventLoop {
  /// Queue of micro tasks.
  final _microtasks = new Queue();
  /// Sorted linked list _TimerTasks.
  final LinkedList<_TimerTask> _timerTasks = new LinkedList<_TimerTask>();

  /// Simulate the current time in milliseconds.
  int _currentTime = 0;

  /// Boolean to make sure that this instance is only used once
  /// for forking a new zone.
  bool _forked = false;

  /// Pops the next task to execute.
  Function _popNextTask() {
    // If there are still microtasks to do, execute them.
    if (_microtasks.isNotEmpty) return _microtasks.removeFirst();
    // Otherwise execute the first timer task (and update the
    // current time).
    if (_timerTasks.isEmpty) return null;
    _TimerTask timerTask = _timerTasks.first;
    timerTask.unlink();
    _currentTime = timerTask.scheduledAtTime;
    return timerTask.task;
  }

  /// The simulated scheduleMicrotask simply adds the task to the
  /// end of the queue.
  void _scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone,
                          Function microtask) {
   // Note that the microtask is bound to the origin-zone.
    _microtasks.add(zone.bindCallback(microtask, runGuarded: true));
  }

  /// Adds the given [task] at the correct position of the timer list.
  // TODO: the performance could be improved by using a priority queue.
  void _scheduleIn(Duration duration, Function task) {
    int scheduledAtTime = _currentTime + duration.inMilliseconds;
    var newTimerTask = new _TimerTask(scheduledAtTime, task);
    // Increment the currentTime, so that scheduling multiple events
    // in the same event will be scheduled in the right order.
    _currentTime++;
    if (_timerTasks.isEmpty) {
      _timerTasks.add(newTimerTask);
      return;
    }
    var timerTask = _timerTasks.first;
    while (timerTask.scheduledAtTime < scheduledAtTime) {
      timerTask = timerTask.next;
      if (timerTask == null) {
        _timerTasks.add(newTimerTask);
        return;
      }
    }
    timerTask.insertBefore(newTimerTask);
  }

  /// Creates a new Timer for the simulated event loop.
  Timer _createTimer(Zone self, ZoneDelegate parent, Zone zone,
                    Duration duration, Function callback) {
    _Timer result = new _Timer();

    void wrappedCallback() {
      if (result.isActive) {
        result._isActive = false;
        // The callback is again executed in the origin zone.
        zone.runGuarded(callback);
      }
    }

    _scheduleIn(duration, wrappedCallback);
  }

  Timer _createPeriodicTimer(Zone self, ZoneDelegate parent, Zone zone,
                             Duration duration, Function callback) {
    throw new UnimplementedError('createPeriodicTimer');
  }

  void forkCurrentAndRun(void f()) {
    if (_forked) throw new StateError('Can only fork once');
    _forked = true;
    // Creates a specification that overrides the microtask and
    // timer operations.
    var specification = new ZoneSpecification(
        scheduleMicrotask: _scheduleMicrotask,
        createTimer: _createTimer,
        createPeriodicTimer: _createPeriodicTimer);
    Zone zone = Zone.current.fork(specification: specification);
    // Schedule the given function as if it was a microtask.
    zone.scheduleMicrotask(f);
    // Run the event loop to completion.
    while (true) {
      Function nextTask = _popNextTask();
      if (nextTask == null) return;
      nextTask();
    }
  }
}

// =========== Code to run and test the ZoneSpecification =========
void tests() {
  Timer.run(() {
    print('Timer');
    scheduleMicrotask(() {
      print('t1');
    });
    new Timer(new Duration(milliseconds: 5), () {
      print('t2 5ms');
    });
    new Timer(new Duration(milliseconds: 3), () {
      print('t2 3ms');
      throw 't2 3ms';
    });
    scheduleMicrotask(() {
      print('t2');
    });
  });
  scheduleMicrotask(() { print('1'); });
}

void main() {
  runZoned(() {
    var eventLoop = new EventLoop();
    eventLoop.forkCurrentAndRun(tests);
  }, onError: print);
}

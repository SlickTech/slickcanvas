import 'dart:html' as dom;

enum _AnimationFrameStatus {
  started,
  stopped,
}

class AnimationFrameSubscriber {
  final String id;
  final bool repeat;
  final Function callback;

  AnimationFrameSubscriber(this.id, this.repeat, this.callback);
}

class AnimationFrame {

  static AnimationFrame _instance = null;

  var _loopStatus = _AnimationFrameStatus.stopped;
  var _inAnimFrame = false;

  final _subscribers = <String, AnimationFrameSubscriber> {};
  final _pendingAddSubscribers = <String, AnimationFrameSubscriber> {};
  final _pendingRemoveSubscribers = new Set<String>();

  factory AnimationFrame() {
    if (_instance == null) {
      _instance = new AnimationFrame._constructor();
    }
    return _instance;
  }

  AnimationFrame._constructor();

  void _start() {
    if (_loopStatus != _AnimationFrameStatus.started) {
      _loopStatus = _AnimationFrameStatus.started;
      dom.window.animationFrame.then(onAnimationFrame);
    }
  }

  void _stop() {
    _loopStatus = _AnimationFrameStatus.stopped;
  }

  void onAnimationFrame(num timestamp) {
    for (var id in _pendingRemoveSubscribers) {
      _subscribers.remove(id);
    }
    _pendingRemoveSubscribers.clear();

    if (_subscribers.isEmpty) {
      _stop();
      return;
    }

    if (_loopStatus == _AnimationFrameStatus.started) {

      var repeat = false;
      var oneTimeSubscribers = <AnimationFrameSubscriber> [];

      _inAnimFrame = true;

      for (var subscriber in _subscribers.values) {
        subscriber.callback(timestamp);

        if (subscriber.repeat) {
          repeat = true;
        } else {
          oneTimeSubscribers.add(subscriber);
        }
      };

      _inAnimFrame = false;

      for (var subscriber in oneTimeSubscribers) {
        unsubscribe(subscriber.id);
      }

      if (repeat) {
        dom.window.animationFrame.then(onAnimationFrame);
      }

      _pendingAddSubscribers.forEach((String id, AnimationFrameSubscriber subscriber) {
        _subscribers[id] = subscriber;
      });
    }
  }

  void subscribe(String id, Function callback, {bool repeat: true}) {
    if (_subscribers.isEmpty) {
      _start();
    }

    if (_inAnimFrame) {
      _pendingAddSubscribers[id] = new AnimationFrameSubscriber(id, repeat, callback);
    } else {
      _subscribers[id] = new AnimationFrameSubscriber(id, repeat, callback);
    }
  }

  void unsubscribe(String id) {
    if (_inAnimFrame) {
      _pendingRemoveSubscribers.add(id);
    } else {
      _subscribers.remove(id);
    }

    if (_subscribers.isEmpty) {
      _stop();
    }
  }
}

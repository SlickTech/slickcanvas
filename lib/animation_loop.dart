part of smartcanvas;

enum AnimLoopStatus {
  started,
  stopped,
}

class AnimationLoopSubscriber {
  final String id;
  final bool repeat;
  final Function callback;

  AnimationLoopSubscriber(this.id, this.repeat, this.callback);
}

class AnimationLoop {

  static AnimationLoop _instance = null;

  AnimLoopStatus _loopStatus = AnimLoopStatus.stopped;
  final Map<String, AnimationLoopSubscriber> _subscribers = {};

  static AnimationLoop get instance {
    if (_instance == null) {
      _instance = new AnimationLoop();
    }
    return _instance;
  }

  void _start() {
    if (_loopStatus != AnimLoopStatus.started) {
      _loopStatus = AnimLoopStatus.started;
      dom.window.animationFrame.then(onAnimationFrame);
    }
  }

  void _stop() {
    _loopStatus = AnimLoopStatus.stopped;
  }

  void onAnimationFrame(num timestamp) {
    if (_loopStatus == AnimLoopStatus.started) {
      bool repeat = false;
      List<AnimationLoopSubscriber> oneTimeSubscribers = [];
      for (AnimationLoopSubscriber subscriber in _subscribers.values) {
        subscriber.callback(timestamp);

        if (subscriber.repeat) {
          repeat = true;
          oneTimeSubscribers.add(subscriber);
        }
      };

      for (AnimationLoopSubscriber subscriber in oneTimeSubscribers) {
        unsubscribe(subscriber.id);
      }

      if (repeat) {
        dom.window.animationFrame.then(onAnimationFrame);
      }
    }
  }

  void subscribe(String id, Function callback, {bool repeat: true}) {
    if (_subscribers.isEmpty) {
      _start();
    }
    _subscribers[id] = new AnimationLoopSubscriber(id, repeat, callback);
  }

  void unsubscribe(String id) {
    _subscribers.remove(id);
    if (_subscribers.isEmpty) {
      _stop();
    }
  }
}

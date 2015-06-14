part of smartcanvas;

enum AnimLoopStatus {
  started,
  stopped,
}

class AnimationLoop {

  static AnimationLoop _instance = null;

  AnimLoopStatus _loopStatus = AnimLoopStatus.stopped;
  final Map<String, Function> _subscribers = {};

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
      _subscribers.forEach((id, callback) {
        callback(timestamp);
      });

      dom.window.animationFrame.then(onAnimationFrame);
    }
  }

  void subscribe(String id, Function callback) {
    if (_subscribers.isEmpty) {
      _start();
    }
    _subscribers[id] = callback;
  }

  void unsubscribe(String id) {
    _subscribers.remove(id);
    if (_subscribers.isEmpty) {
      _stop();
    }
  }
}

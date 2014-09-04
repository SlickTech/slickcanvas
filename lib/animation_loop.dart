part of smartcanvas;

class AnimationLoop {

  static const num s_stopped = 0;
  static const num s_started = 1;
  static AnimationLoop _instance = null;

  num _loopStatus = s_stopped;
  Map<String, Function> _subscribers = {};

  static AnimationLoop get instance {
    if (_instance == null) {
      _instance = new AnimationLoop();
    }
    return _instance;
  }

  void _start() {
    if (_loopStatus != s_started) {
      _loopStatus = s_started;
      DOM.window.animationFrame.then(onAnimationFrame);
   }
  }

  void _stop() {
    _loopStatus = s_stopped;
  }

  void onAnimationFrame(num timestamp) {
    if (_loopStatus == s_started) {
      _subscribers.forEach((id, callback){
        callback(timestamp);
      });

      DOM.window.animationFrame.then(onAnimationFrame);
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

part of smartcanvas;

class EventBus {
  Map<String, EventHandlers> _eventListeners = {};

  EventBus on(String events, Function handler, [String id]) {
    List<String> ss = events.split(' ');
    ss.forEach((event) {
      if (_eventListeners[event] == null) {
        _eventListeners[event] = new EventHandlers();
      }
      _eventListeners[event].add(new EventHandler(id, handler));
    });
  }

  EventBus off(String event, [String id]) {
    EventHandlers listeners = _eventListeners[event];
    if (listeners != null) {
      var i = 0;
      while (i < listeners.length) {
        EventHandler listener = listeners[i];
        if (listener.id == id) {
          listeners.removeAt(i);
        } else {
          i++;
        }
      }

      if (listeners.isEmpty) {
        _eventListeners.remove(event);
      }
    }
  }

  void fire(String event, [dynamic arg0, arg1, arg2, arg3, arg4, arg5]) {
    EventHandlers listeners = _eventListeners[event];
    if (listeners != null) {
      listeners(arg0, arg1, arg2, arg3, arg4, arg5);
    }
  }

  bool hasListener(String event) {
    return _eventListeners[event] != null;
  }

  Map<String, EventHandlers> get eventListeners => _eventListeners;
}
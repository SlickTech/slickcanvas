library smartcanvas.event_bus;

import 'package:dart_ext/function_ext.dart';

part 'event_handler.dart';

class EventBus {
  final Map<String, EventHandlers> eventListeners = {};

  void on(String events, Function handler, [String id]) {
    List<String> ss = events.split(' ');
    ss.forEach((event) {
      if (eventListeners[event] == null) {
        eventListeners[event] = new EventHandlers();
      }
      eventListeners[event].add(new EventHandler(id, handler));
    });
  }

  void off(String event, [String id]) {
    EventHandlers listeners = eventListeners[event];
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
        eventListeners.remove(event);
      }
    }
  }

  void fire(String event, [dynamic arg0, arg1, arg2, arg3, arg4, arg5]) {
    EventHandlers listeners = eventListeners[event];
    if (listeners != null) {
      listeners(arg0, arg1, arg2, arg3, arg4, arg5);
    }
  }

  bool hasListener(String event) {
    return eventListeners[event] != null;
  }
}

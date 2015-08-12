part of smartcanvas.event_bus;

class EventHandler {
  String id;
  Function handler;
  Function _relaxHandler;

  EventHandler(this.id, this.handler) {
    _relaxHandler = relaxFn(handler);
  }

  call([dynamic arg0, arg1, arg2, arg3, arg4, arg5]) {
    _relaxHandler(arg0, arg1, arg2, arg3, arg4, arg5);
  }
}

class EventHandlers {
  final List<EventHandler> _handlers = [];

  void add(EventHandler handler) {
    _handlers.add(handler);
  }

  void remove(EventHandler handler) {
    _handlers.remove(handler);
  }

  void removeAt(int index) {
    _handlers.removeAt(index);
  }

  operator [](int index) {
    return _handlers[index];
  }

  num get length => _handlers.length;

  bool get isEmpty => _handlers.isEmpty;

  bool get isNotEmpty => _handlers.isNotEmpty;

  call([dynamic arg0, arg1, arg2, arg3, arg4, arg5]) {
    for (EventHandler handler in _handlers) {
      handler(arg0, arg1, arg2, arg3, arg4, arg5);
    }
  }
}

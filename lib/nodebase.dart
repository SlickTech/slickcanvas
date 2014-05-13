part of smartcanvas;

int _guid = 0;

/**
 *
 */
class NodeBase extends EventBus {
  int _uid;
  Map<String, dynamic> _attrs = {};

  NodeBase([Map<String, dynamic> config = const {}]) {
    _attrs.addAll(config);
    _uid = ++_guid;
  }

  void _setAttributeFromConfig(String attr, Map<String, dynamic> config, [dynamic defaultVal = null]) {
    if (config.containsKey(attr)) {
      setAttribute(attr, config[attr]);
    } else if (defaultVal != null) {
      setAttribute(attr, defaultVal);
    }
  }

  void setAttribute(String attr, dynamic value, [bool removeIfNull = false]) {
    var oldValue = _attrs[attr];
    if (value == null && removeIfNull) {
      removeAttribute(attr);
    } else {
      _attrs[attr] = value;
    }
    if (oldValue != value) {
      var event = attr + CHANGED;
      if (hasListener(event)) {
        fire(event, oldValue, value);
      } else{
        fire(ANY_CHANGED, attr, oldValue, value);
      }
    }
  }

  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    dynamic rt = _attrs[attr];
    return rt == null ? defaultValue : rt;
  }

  void removeAttribute(String attr) {
    var oldValue = _attrs[attr];
    _attrs.remove(attr);
    var event = attr + CHANGED;
    if (hasListener(event)) {
      fire(event, oldValue, null);
    } else{
      fire(ANY_CHANGED, attr, oldValue, null);
    }
  }

  String getAttributeString(String attr) {
    var value = getAttribute(attr);
    return '$value';
  }

  bool hasAttribute(String attr){
    return _attrs.containsKey(attr);
  }

  Map<String, dynamic> get attrs => _attrs;
  int get uid => _uid;
}
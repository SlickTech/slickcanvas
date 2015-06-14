part of smartcanvas;

int _guid = 0;

class NodeBase extends EventBus {

  final int uid = ++_guid;
  final Map<String, dynamic> attrs = {};

  NodeBase(Map<String, dynamic> config) {
    if (config == null) {
      config = {};
    }
    attrs.addAll(config);
  }

  void setAttribute(String attr, dynamic value, [bool removeIfNull = false]) {
    var oldValue = attrs[attr];
    if (value == null && removeIfNull) {
      removeAttribute(attr);
    } else {
      attrs[attr] = value;
    }
    if (oldValue != value) {
      var event = '${attr}Changed';
      if (hasListener(event)) {
        fire(event, value, oldValue);
      } else {
        fire(attrChanged, attr, value, oldValue);
      }
    }
  }

  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    var rt = attrs[attr];
    return rt == null ? defaultValue : rt;
  }

  void removeAttribute(String attr) {
    var oldValue = attrs[attr];
    attrs.remove(attr);
    var event = '${attr}Changed';
    if (hasListener(event)) {
      fire(event, null, oldValue);
    } else {
      fire(attrChanged, attr, null, oldValue);
    }
  }

  String getAttributeString(String attr) {
    var value = getAttribute(attr);
    return '$value';
  }

  bool hasAttribute(String attr) => attrs.containsKey(attr);
}

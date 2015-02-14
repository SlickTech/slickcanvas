part of smartcanvas;

abstract class NodeImpl {
  NodeImpl parent;
  Node _shell;

  NodeImpl(this._shell): super() {
  }

  String get type;

  void remove();

  NodeImpl clone() {
    ClassMirror cm = reflectClass(this.runtimeType);
    NodeImpl clone = cm.newInstance(const Symbol(EMPTY), []).reflectee;
    return clone;
  }

  Node get shell => _shell;

  LayerImpl get layer {
    NodeImpl parent = this.parent;
    while(parent != null && parent is! LayerImpl) {
      parent = parent.parent;
    }
    return parent;
  }

  Stage get stage {
    LayerImpl layer = this.layer;
    if (layer != null) {
      return (layer.shell as Layer)._parent;
    }
    return null;
  }

  void on(String events, Function handler, [String id]);

  void setAttribute(String attr, dynamic value, [bool removeIfNull = false]) {
    shell.setAttribute(attr, value, removeIfNull);
  }

  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    return shell.getAttribute(attr, defaultValue);
  }

  void set id(String value) => setAttribute(ID, value);
  String get id => getAttribute(ID, '');

  num get width => getAttribute(WIDTH);
  num get height => getAttribute(HEIGHT);

  void set fill(dynamic value) => setAttribute(FILL, value);
  dynamic get fill => getAttribute(FILL);

  void set stroke(dynamic value) => setAttribute(STROKE, value);
  dynamic get stroke => getAttribute(STROKE);

  void set strokeWidth(dynamic value) => setAttribute(STROKE_WIDTH, value);
  dynamic get strokeWidth => getAttribute(STROKE_WIDTH);
}
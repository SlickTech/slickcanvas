part of smartcanvas;

abstract class NodeImpl {
  NodeImpl parent;
  final Node shell;

  NodeImpl(this.shell) : super();

  String get type;

  void remove();

  NodeImpl clone() {
    ClassMirror cm = reflectClass(this.runtimeType);
    NodeImpl clone = cm.newInstance(const Symbol(EMPTY), []).reflectee;
    return clone;
  }

  LayerImpl get layer {
    NodeImpl parent = this.parent;
    while (parent != null && parent is! LayerImpl) {
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

  void setAttribute(String attr, value, [bool removeIfNull = false]) {
    shell.setAttribute(attr, value, removeIfNull);
  }

  getAttribute(String attr, [defaultValue = null]) {
    return shell.getAttribute(attr, defaultValue);
  }

  String get id => shell.id;

  num get width => shell.width;
  num get height => shell.height;

  void set fill(value) {
    shell.fill = value;
  }
  get fill => shell.fill;

  void set stroke(value) {
    shell.stroke = value;
  }
  get stroke => shell.stroke;

  void set strokeWidth(num value) {
    shell.strokeWidth = value;
  }
  num get strokeWidth => shell.strokeWidth;
}

part of smartcanvas;

abstract class NodeImpl extends NodeBase {
//  Stage _stage;
  NodeImpl parent;
  Node _shell;
  TransformMatrix _transformMatrix;

  NodeImpl(this._shell): super() {
    this._attrs = _shell._attrs;
    this._eventListeners.addAll(_shell._eventListeners);
  }

  String get type;

  void remove();
  void translate();

  NodeImpl clone() {
    ClassMirror cm = reflectClass(this.runtimeType);
    NodeImpl clone = cm.newInstance(const Symbol(EMPTY), [_attrs]).reflectee;
    return clone;
  }

  void dragStart(DOM.MouseEvent e);

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

  void set id(String value) => setAttribute(ID, value);
  String get id => getAttribute(ID, '');

  num get width => getAttribute(WIDTH);
  num get height => getAttribute(HEIGHT);
  bool get isDragging;
  Position get absolutePosition;
  TransformMatrix get transformMatrix => shell._transformMatrix;
}
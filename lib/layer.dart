part of smartcanvas;

class Layer extends Group {
  Stage _stage;
  LayerImpl _impl;

  Layer(String type, Map<String, dynamic> config) : super(config) {
    _layer = this;
    _impl = createImpl(type);
  }

  NodeImpl _createSvgImpl() {
    return  new SvgLayer(this);
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  Layer _clone() {
     return new Layer(_impl.type, _attrs);
  }

  void suspend() {
    if (_impl != null) {
      _impl.suspend();
    }
  }

  void resume() {
    if (_impl != null) {
      _impl.resume();
    }
  }

  void add(Node child) {
    if (child._parent != null) {
      child.remove();
    }

    _children.add(child);
    child._parent = this;
    child._layer = this._layer;

    if (child._impl == null) {
      child._impl = child.createImpl(_impl.type);
    }
    _impl.add(child._impl);
    if (_stage != null) {
      _stage._reflect(child);
    }
  }

  void insert(int index, Node node) {
    if (node._parent != null) {
      node.remove();
    }

    node._parent = this;
    _children.insert(index, node);
    if (node._impl == null) {
      node._impl = node.createImpl(_impl.type);
    }
    _impl.insert(index, node._impl);
    if (_stage != null) {
      _stage._reflectionLayer.insertNode(new _ReflectionNode(node));
    }
  }

  String get type => _impl.type;

  void set width(num value) => setAttribute(WIDTH, value);
  num get width => getAttribute(WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);
  num get height => getAttribute(HEIGHT);
}
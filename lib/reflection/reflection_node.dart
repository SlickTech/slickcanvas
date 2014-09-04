part of smartcanvas;

class ReflectionNode extends Node implements I_Reflection {
  Node _node;

  ReflectionNode(Node node): super(node.attrs) {
    _node = node;
    _node._reflection = this;
    this._attrs = _node.attrs;
    _eventListeners.addAll(_node._eventListeners);
  }

  NodeImpl _createSvgImpl(bool isReflection) {
    NodeImpl reflectionImpl = _node._createSvgImpl(true);
    return reflectionImpl;
  }

  NodeImpl _createCanvasImpl() {
    throw 'Reflection Node should alwyas on svg canvas';
  }

  void set scaleX(num x) { _node.scaleX = x; }
  num get scaleX => _node.scaleX;

  void set scaleY(num y) { _node.scaleY = y; }
  num get scaleY => _node.scaleY;

  void set translateX(num tx) { _node.translateX = tx; }
  num get translateX => _node.translateX;

  void set translateY(num ty) { _node.translateY = ty; }
  num get translateY => _node.translateY;
}
part of smartcanvas;

class _ReflectionNode extends Node implements _I_Reflection {
  Node _node;

  _ReflectionNode(Node node): super(node.attrs) {
    _node = node;
    _node._reflection = this;
    _eventListeners.addAll(_node._eventListeners);
  }

  NodeImpl _createSvgImpl() {
    assert(_node._impl != null);
    NodeImpl reflectionImpl = _node._createSvgImpl();
    reflectionImpl.on(DRAGMOVE, _onDragMove);
    return reflectionImpl;
  }

  NodeImpl _createCanvasImpl() {
    throw 'Reflection Node should alwyas on svg canvas';
  }

  void _onDragMove(DOM.MouseEvent e) {
    (_node._impl as SvgNode).element.setAttribute(TRANSFORM,
        (_impl as SvgNode).element.attributes[TRANSFORM]);
  }
}
part of smartcanvas;

class _ReflectionNode extends Node {
  Node _node;

  _ReflectionNode(this._node): super() {}

  NodeImpl _createSvgImpl() {
    assert(_node._impl != null);
    if (_node._reflection == null) {
      _node._reflection = _node.reflect();
      _node._reflection.on(DRAGMOVE, _onDragMove);
    }
    _node._reflection._shell = this;
    return _node._reflection;
  }

  NodeImpl _createCanvasImpl() {
    throw 'Reflection Node should alwyas on svg canvas';
  }

  void _onDragMove(DOM.MouseEvent e) {
    (_node._impl as SvgNode).element.setAttribute(TRANSFORM,
        (_impl as SvgNode).element.attributes[TRANSFORM]);
  }
}
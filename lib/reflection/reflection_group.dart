part of smartcanvas;

class ReflectionGroup extends Group implements I_Container_Reflection {
  Group _node;

  ReflectionGroup(Node node): super(node._attrs) {
    _node = node;
    _node._reflection = this;
    this._attrs = _node.attrs;
    _eventListeners.addAll(_node._eventListeners);
    _buildReflectionGroup(_node._children);
  }

  void _buildReflectionGroup(List<Node> children) {
    children.forEach((child) {
      if (!child.reflectable) {
        if (child is Container) {
          _buildReflectionGroup(child._children);
        }
        return;
      }

      Node reflectionChild = _createReflection(child) as Node;
      addChild(reflectionChild);
    });

    // If all children were not reflectable, reflect the firt child.
    // We need some solid shape inside the group
    if (_children.isEmpty && children.isNotEmpty) {
      Node reflectionChild = _createReflection(children.first) as Node;
      addChild(reflectionChild);
    }
  }

  NodeImpl _createSvgImpl(bool isReflection) {
    assert(_node._impl != null);
    SvgGroup rt = super._createSvgImpl(true);
    return rt;
  }


  NodeImpl _createCanvasImpl() {
    throw 'Reflection Node should alwyas on svg canvas';
  }

  void addChild(Node child) {
    if (!(child is I_Reflection)) {
      throw 'Reflection Layer can only add reflection node';
    }
    super.addChild(child);
  }

  void insertChild(int index, Node node) {
    if (!(node is I_Reflection)) {
      throw 'Reflection Layer can only add reflection node';
    }
    super.insertChild(index, node);
  }

  void reflectionAdd(Node child) {
    addChild(_createReflection(child) as Node);
  }

  void insertNode(I_Reflection node) {
    // find next reflectable node in the same group
    Node realNode = node._node;
    Node nextReflectableNode = _node.firstReflectableNode(startIndex:_node._children.indexOf(realNode) + 1);
    if (nextReflectableNode != null) {
      insertChild(_children.indexOf(nextReflectableNode._reflection as Node), node as Node);
    } else {
      addChild(node as Node);
    }
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
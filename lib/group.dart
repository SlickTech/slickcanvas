part of smartcanvas;

class Group extends Node implements Container<Node> {
  List<Node> _children = new List<Node>();

  Group([Map<String, dynamic> config = null]): super(config) {}

  NodeImpl _createSvgImpl() {
    SvgGroup impl = new SvgGroup(this);
    _children.forEach((node) {
      if (node.impl == null || node._impl.type != svg) {
        node._impl = node.createImpl(svg);
      }
      impl.add(node._impl);
    });
    return impl;
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  void add(Node child) {
    if (child._parent != null) {
      child.remove();
    }

    _children.add(child);
    child._parent = this;
    child._layer = this._layer;

    if (_impl != null ) {
      // re-create impl if child switched to different type of layer
      if (child._impl == null || child._impl.type != _impl.type) {
        child._impl = child.createImpl(_impl.type);
      }

      (_impl as Container).add(child._impl);
    }

    if (stage != null && !(this is _I_Reflection)) {
      // only reflect reflectable node
      if (child.reflectable) {
        _reflectionAdd(child);
      }
    }
  }

  void _reflectionAdd(Node child) {
    // if the group already reflected, add children to its reflecton
    if (_reflection != null) {
      (_reflection as _I_Container_Reflection).reflectionAdd(child);
    } else if (parent != null){
      // this group wasn't reflectable before, since the child is
      // reflectable, the group is reflectable now. Reflect the group.
      (parent as Group)._reflectionAdd(this);
    }
  }

  void removeChild(Node node) {
    node._parent = null;
    _children.remove(node);

    if (_reflection != null && node._reflection != null) {
      (_reflection as Group).removeChild(node._reflection as Node);
    }
  }

  void insert(int index, Node node) {
    if (node._parent != null) {
      node.remove();
    }

    _children.insert(index, node);
    node._parent = this;
    node._layer = this._layer;
    if (_impl != null) {
      if (node._impl == null || node._impl.type != _impl.type) {
        node._impl = node.createImpl(_impl.type);
      }
      (_impl as Container).insert(index, node._impl);
    }

    if (stage != null && !(this is _I_Reflection)) {
      // only reflect reflectable node
      if (!node.reflectable) {
        // if group wasn't reflectable, reflect its children.
        if (node is Container) {
          (node as Container).children.forEach((node) {
            _reflectionInsert(node);
          });
        }
        return;
      }
      _reflectionInsert(node);
    }
  }

  void _reflectionInsert(Node child) {
    // if the group already reflected, insert children to its reflecton
    if (this._reflection != null) {
      (this._reflection as _I_Container_Reflection).insertNode(_createReflection(child));
    }
  }

  List<Node> get children => _children;

  void _addChildImpl(NodeImpl impl, Node child, Layer layer) {
    NodeImpl chldImpl = child.createImpl(layer.type);
  }

  Node clone([Map<String, dynamic> config]) {
    ClassMirror cm = reflectClass(this.runtimeType);
    Map<String, dynamic> cnfg;
    if(config != null) {
      cnfg = new Map<String, dynamic>.from(_attrs);
      cnfg.addAll(config);
    } else {
      cnfg = _attrs;
    }
    Node clone = cm.newInstance(const Symbol(EMPTY), [cnfg]).reflectee;

    _children.forEach((child) {
      (clone as Container).add(child.clone());
    });
    return clone;
  }

  Node firstReflectableNode({int startIndex: 0, bool excludeChild: false}) {
    for (int i = startIndex, len = _children.length; i < len; i++) {
      Node node = _children[i];
      if (node.reflectable) {
        return node;
      } else if (node is Group) {
        if (!excludeChild) {
          Node child = node.firstReflectableNode();
          if (child != null) {
            return child;
          }
        }
      }
    }
    return null;
  }

  bool get reflectable {
    bool rt = super.reflectable;
    if (!rt) {
      for (int i = 0; i < _children.length; i++) {
        if (_children[i].reflectable) {
          rt = true;
          break;
        }
      }
    }
    return rt;
  }

  List get _defs {
    List defs = [];
    _children.forEach((child) {
      defs.addAll(child._defs);
    });
    return defs;
  }
}
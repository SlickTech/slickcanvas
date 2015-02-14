part of smartcanvas;

class Group extends Node implements Container<Node> {
  List<Node> _children = new List<Node>();

  Group([Map<String, dynamic> config = null]) : super(config);

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    SvgGroup impl = new SvgGroup(this, isReflection);

    if (isReflection) {
      _reflectGroupChildren(_children, impl);
    } else {
      _children.forEach((node) {
        if (node.impl == null || node._impl.type != svg) {
          node._impl = node._createSvgImpl(isReflection);
        }
        impl.addChild(node._impl);
      });
    }
    return impl;
  }

  void _reflectGroupChildren(List<Node> children, SvgGroup impl) {
    children.forEach((child) {
      if (child.reflectable) {
        if (child._reflection == null)
        {
          child._reflection = child._createReflection();
        }
        impl.addChild(child._reflection);
      }
    });

    // If all children were not reflectable, reflect the firt child.
    // We need some solid shape inside the group
    if (impl.children.isEmpty && children.isNotEmpty) {
      var node = children.first;
      if (node._reflection == null) {
        node._reflection = node._createReflection();
      }
      impl.addChild(node._reflection);
    }
  }

  NodeImpl _createCanvasImpl() {
    throw ExpNotImplemented;
  }

  void addChild(Node child) {
    if (child._parent != null) {
      child.remove();
    }

    _children.add(child);
    child._parent = this;
    child._layer = this._layer;
    if (_impl != null) {
      // re-create impl if child switched to different type of layer
      if (child._impl == null || child._impl.type != _impl.type) {
        child._impl = child.createImpl(_impl.type);
      }

      (_impl as Container).addChild(child._impl);
    }

    if (layer != null) {
      // only reflect reflectable node
      if (child.reflectable) {
        _reflectChild(child);
      }
    }
  }

  void _reflectChild(Node child) {
    // if the group already reflected, add children to its reflecton
    if (_reflection != null) {
      if (child._reflection == null) {
        child._reflection = child._createReflection();
      }

      var nextReflectableChild = this.firstReflectableNode(startIndex: _children.indexOf(child) + 1);
      if (nextReflectableChild == null || nextReflectableChild._reflection == null) {
        (_reflection as Container).addChild(child._reflection);
      } else if(nextReflectableChild._reflection != null) {
        Container grpReflection = _reflection as Container;
        grpReflection.insertChild(grpReflection.children.indexOf(nextReflectableChild._reflection), child._reflection);
      }
    } else if (parent != null) {
      // this group wasn't reflectable before, since the child is
      // reflectable, the group is reflectable now. Reflect the group.
      (parent as Group)._reflectChild(this);
    }
  }

  void removeChild(Node node) {
    _children.remove(node);

    if (node._reflection != null) {
      node._reflection.remove();
    }

    if (_impl != null && node.impl != null) {
      (_impl as Container).removeChild(node.impl);
    }

    node._parent = null;
  }

  void clearChildren() {
    while (_children.isNotEmpty) {
      this.removeChild(_children.first);
    }
  }

  void insertChild(int index, Node node) {
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
      (_impl as Container).insertChild(index, node._impl);
    }

    if (layer != null) {
      // only reflect reflectable node
      if (node.reflectable) {
        _reflectChild(node);
      }
    }
  }

  List<Node> get children => _children;

  Node clone([Map<String, dynamic> config]) {
    ClassMirror cm = reflectClass(this.runtimeType);
    Map<String, dynamic> cnfg;
    if (config != null) {
      cnfg = new Map<String, dynamic>.from(_attrs);
      cnfg.addAll(config);
    } else {
      cnfg = _attrs;
    }
    Node clone = cm.newInstance(const Symbol(EMPTY), [cnfg]).reflectee;

    _children.forEach((child) {
      (clone as Container).addChild(child.clone());
    });
    return clone;
  }

  Node firstReflectableNode({int startIndex: 0, bool excludeChild: false}) {
    for (int i = startIndex,
        len = _children.length; i < len; i++) {
      Node node = _children[i];
      if (node.reflectable) {
        return node;
      } else if (node is Group && !excludeChild) {
        Node child = node.firstReflectableNode();
        if (child != null) {
          return child;
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

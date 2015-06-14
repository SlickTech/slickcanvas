part of smartcanvas;

class Group extends ContainerNode {

  Group([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new Group(config);

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    var impl = new SvgGroup(this, isReflection);

    if (isReflection) {
      _reflectGroupChildren(children, impl);
    } else {
      children.forEach((node) {
        if (node.impl == null || node._impl.type != CanvasType.svg) {
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
        if (child._reflection == null) {
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

  bool get reflectable {
    var rt = super.reflectable;
    if (!rt) {
      for (int i = 0; i < children.length; i++) {
        if (children[i].reflectable) {
          rt = true;
          break;
        }
      }
    }
    return rt;
  }

  List get _defs {
    var defs = [];
    children.forEach((child) {
      defs.addAll(child._defs);
    });
    return defs;
  }
}

part of smartcanvas;

abstract class ContainerNode extends Node with Container<Node> {

  ContainerNode([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) {
    ContainerNode copy = _createNewInstance(config);
    children.forEach((child) {
      copy.addChild(child.clone());
    });
    return copy;
  }

  Node _createNewInstance(Map<String, dynamic> config);

  @override
  void addChild(Node child) {
    if (child._parent != null) {
      child.remove();
    }

    children.add(child);
    if (_impl != null) {
      // re-create impl if child switched to different type of layer
      if (child._impl == null || child._impl.type != _impl.type) {
        child._impl = child.createImpl(_impl.type);
      }

      // set parent after creating child impl
      // to avoid adding def multiple times when
      // child is a group
      child._parent = this;
      (_impl as Container).addChild(child._impl);
    } else {
      child._parent = this;
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

      var nextReflectableChild = this.firstReflectableNode(startIndex: children.indexOf(child) + 1);
      if (nextReflectableChild == null || nextReflectableChild._reflection == null) {
        if (_reflection is SvgLayer) {
          (_reflection.shell as _ReflectionLayer).reflectNode(child);
        } else {
          (_reflection as Container).addChild(child._reflection);
        }
      } else if (nextReflectableChild._reflection != null) {
        var grpReflection = _reflection as Container;
        var index = grpReflection.children.indexOf(nextReflectableChild._reflection);
        if (index != -1) {
          grpReflection.insertChild(index, child._reflection);
        } else {
          grpReflection.addChild(child._reflection);
        }
      }
    } else if (parent != null) {
      // this group wasn't reflectable before, since the child is
      // reflectable, the group is reflectable now. Reflect the group.
      (parent as Group)._reflectChild(this);
    }
  }

  Node firstReflectableNode({int startIndex: 0, bool excludeChild: false}) {
    for (int i = startIndex, len = children.length; i < len; i++) {
      var node = children[i];
      if (node.reflectable) {
        return node;
      } else if (node is Group && !excludeChild) {
        var child = node.firstReflectableNode();
        if (child != null) {
          return child;
        }
      }
    }
    return null;
  }

  @override
  void removeChild(Node node) {

    children.remove(node);

    if (node._reflection != null && node._reflection.parent != null) {
      (node._reflection.parent as Container).children.remove(node._reflection);
    }

    if (_impl != null && node.impl != null) {
      (_impl as Container).removeChild(node.impl);
    }

    node._parent = null;
  }

  @override
  void clearChildren() {
    while (children.isNotEmpty) {
      this.removeChild(children.first);
    }
  }

  @override
  void insertChild(int index, Node node) {
    if (node._parent != null) {
      node.remove();
    }

    children.insert(index, node);
    node._parent = this;

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

  @override
  BBox getBBox(bool isAbsolute) {
    Map box = {
      'left': double.MAX_FINITE,
      'right': -double.MAX_FINITE,
      'top': double.MAX_FINITE,
      'bottom': -double.MAX_FINITE
    };

    for (Node node in children) {
      var bbx = node.getBBox(isAbsolute);

      if (isAbsolute == false && node is ContainerNode) {
        box['left'] = min(box['left'], node.x + bbx.left);
        box['right'] = max(box['right'], node.y + bbx.right);
        box['top'] = min(box['top'], node.x + bbx.top);
        box['bottom'] = max(box['bottom'], node.y + bbx.bottom);
      } else {
        box['left'] = min(box['left'], bbx.left);
        box['right'] = max(box['right'], bbx.right);
        box['top'] = min(box['top'], bbx.top);
        box['bottom'] = max(box['bottom'], bbx.bottom);
      }
    }

    box.forEach((k, value) {
      if (value.abs() == double.MAX_FINITE) {
        switch (k) {
          case 'right':
            box[k] = width;
            break;
          case 'bottom':
            box[k] = height;
            break;
          default:
            box[k] = 0;
            break;
        }
      }
    });

    if (isAbsolute == false) {
      return new BBox(
        x: x + box['left'],
        y: y + box['top'],
        width: (box['right'] - box['left']) * scaleX * getAttribute(RESIZE_SCALE_X, 1),
        height: (box['bottom'] - box['top']) * scaleY * getAttribute(RESIZE_SCALE_Y, 1)
      );
    }

    return new BBox(
      x: box['left'],
      y: box['top'],
      width: (box['right'] - box['left']) * scaleX * getAttribute(RESIZE_SCALE_X, 1),
      height: (box['bottom'] - box['top']) * scaleY * getAttribute(RESIZE_SCALE_Y, 1)
    );
  }
}

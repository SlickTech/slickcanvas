part of smartcanvas;

class _ReflectionLayer extends Layer {

  _ReflectionLayer(Map<String, dynamic> config)
      : super(svg, merge(config, {
        ID: '__reflection_layer',
        OPACITY: 0
      }));

  void addChild(Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }

    _impl.addChild(node._reflection);
  }

  void insertChild(int index, Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }
    _impl.insertChild(index, node._reflection);
  }

  void insertNode(Node node) {
    // find next reflectable node in the same layer
    Node nextReflectableNode = node.layer.firstReflectableNode(startIndex: node.layer._children.indexOf(node) + 1);
    if (nextReflectableNode != null && nextReflectableNode._reflection != null) {
      insertChild(_impl._children.indexOf(nextReflectableNode._reflection), node);
    } else {
      reflectNode(node);
    }
  }

  void reflectionAdd(Node child) {
    reflectNode(child);
  }

  void reflectNode(Node node) {
    if (node.layer == null) {
      return;
    }

    if (!node.reflectable) {
      return;
    }

    var node_layer = node.layer;
    var layerIndex = stage.children.indexOf(node_layer);
    bool reflectionAdded = false;

    for (int i = layerIndex + 1,
        len = _parent.children.length; i < len; i++) {
      var layer = _parent.children[i];
      var firstRefNode = layer.firstReflectableNode(excludeChild: true);
      if (firstRefNode != null && firstRefNode._reflection != null) {
        var index = this._impl.children.indexOf(firstRefNode._reflection);
        if (index != -1) {
          insertChild(index, node);
          reflectionAdded = true;
          break;
        }
      }
    }

    if (reflectionAdded == false) {
      addChild(node);
    }
  }
}

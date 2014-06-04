part of smartcanvas;

class _ReflectionLayer extends Layer implements I_Container_Reflection {

  Node _node;
  _ReflectionLayer _layer;
  SvgLayer _impl;

  _ReflectionLayer(Map<String, dynamic> config)
    :super(svg, merge(config, {
      ID: '__reflection_layer',
      OPACITY: 0
    }))
  {}

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

  void insertNode(I_Reflection node) {
    // find next reflectable node in the same layer
    Node realNode = node._node;
    Node nextReflectableNode = realNode.layer.firstReflectableNode(startIndex:realNode.layer._children.indexOf(realNode) + 1);
    if (nextReflectableNode != null) {
      insertChild(_children.indexOf(nextReflectableNode._reflection as Node), node as Node);
    } else {
      reflectNode(realNode);
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

    var reflection = _createReflection(node);

    // find top layer
    var topLayerIndex = _parent._children.length - 1;

    // check if the node is on top layer
    if (topLayerIndex >= 0 && _parent._children.indexOf(node.layer) < topLayerIndex) {
      // the node isn't on top layer
      // insert the node before the first node of the top layer

      // get top layer
      var topLayer = _parent._children[topLayerIndex];

      // find the reflection index of the first node in top layer
      var firstReflectableNode = topLayer.firstReflectableNode(excludeChild: true);
      var index = firstReflectableNode == null ? -1 : this._children.indexOf(firstReflectableNode._reflection);

      if (index != -1) {
        insertChild(index, reflection as Node);
      } else {
        // top layer doesn't have any reflectable node yet, just add the node
        addChild(reflection as Node);
      }
    } else {
      addChild(reflection as Node);
    }
  }
}
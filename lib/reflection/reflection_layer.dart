part of smartcanvas;

class _ReflectionLayer extends Layer {

  _ReflectionLayer([Map<String, dynamic> config = const {}])
  : super(CanvasType.svg, merge(config, {
    ID: '__reflection_layer',
    OPACITY: 0
  }));

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) => new SvgLayer(this, true);

  @override
  void addChild(Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }

    (impl as SvgLayer).addChild(node._reflection);
  }

  @override
  void insertChild(int index, Node node) {
    if (node._reflection == null) {
      node._reflection = node._createReflection();
    }
    (impl as SvgLayer).insertChild(index, node._reflection);
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

    for (int i = layerIndex + 1, len = _stage.children.length;
    i < len; i++) {

      Layer layer = _stage.children[i];
      var firstRefNode = layer.firstReflectableNode(excludeChild: true);
      if (firstRefNode != null && firstRefNode._reflection != null) {
        var index = (impl as SvgLayer).children.indexOf(firstRefNode._reflection);
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

part of smartcanvas;

class _ReflectionLayer extends Layer implements I_Container_Reflection {

    Node _node;
    _ReflectionLayer _layer;
    SvgLayer _impl;
    Map<Layer, num> _layerReflectionMap = {};

    _ReflectionLayer(Map<String, dynamic> config)
            : super(svg, merge(config, {
                ID: '__reflection_layer',
                OPACITY: 0
            }));
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
        Node nextReflectableNode = realNode.layer.firstReflectableNode(startIndex: realNode.layer._children.indexOf(realNode) + 1);
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

        var node_layer = node.layer;
        var layerIndex = _parent._children.indexOf(node_layer);

        if (_layerReflectionMap.containsKey(node_layer)) {
            ++_layerReflectionMap[node_layer];
            insertChild(_layerReflectionMap[node_layer], reflection as Node);
        } else {
            bool nodeAdded = false;
            for (num i = _parent.children.length - 1; i >= 0; i--) {
                var layer = _parent.children[i];
                if (_layerReflectionMap.containsKey(layer)) {
                    if (i > layerIndex) {
                        ++_layerReflectionMap[layer];
                    } else {
                        num pos = _layerReflectionMap[layer] + 1;
                        insertChild(pos, reflection as Node);
                        _layerReflectionMap[node_layer] = pos;
                        break;
                    }
                }
            }

            if (_layerReflectionMap.containsKey(node_layer) == false) {
                insertChild(0, reflection as Node);
                _layerReflectionMap[node_layer] = 0;
            }
        }
    }
}

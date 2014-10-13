part of smartcanvas;

class _ReflectionLayer extends Layer implements I_Container_Reflection {

    Node _node;
    _ReflectionLayer _layer;
    SvgLayer _impl;

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
        var layerIndex = stage.children.indexOf(node_layer);
        bool reflectionAdded = false;

        for (int i = layerIndex + 1, len = _parent.children.length;
                i < len; i++) {
            var layer = _parent.children[i];
            var firstRefNode = layer.firstReflectableNode(excludeChild: true);
            if (firstRefNode != null) {
                var index = this.children.indexOf(firstRefNode);
                if (index != -1) {
                    insertChild(index, reflection as Node);
                    reflectionAdded = true;
                    break;
                }
            }
        }

        if (reflectionAdded == false) {
            addChild(reflection as Node);
        }
    }
}

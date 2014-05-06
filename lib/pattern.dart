part of smartcanvas;

class SCPattern extends Group{

  SCPattern([Map<String, dynamic> config = null]): super(config) {}

  NodeImpl _createSvgImpl() {
    SvgPattern impl = new SvgPattern(this);
    _children.forEach((node) {
      node._impl = node.createImpl(svg);
      impl.add(node._impl);
    });
    return impl;
  }

  String get id => getAttribute(ID, '__sc_node_${uid}');
}
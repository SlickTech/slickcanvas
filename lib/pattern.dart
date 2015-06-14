part of smartcanvas;

class SCPattern extends Group {

  SCPattern([Map<String, dynamic> config = const {}]): super(config);

  @override
  Node _createNewInstance(Map<String, dynamic> config) => new SCPattern(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) {
    var impl = new SvgPattern(this);
    children.forEach((node) {
      node._impl = node._createSvgImpl(isReflection);
      impl.addChild(node._impl);
    });
    return impl;
  }

  @override
  String get id => getAttribute(ID, '__sc_pattern_${uid}');
}

part of smartcanvas;

class SCPattern extends Group{

  SCPattern([Map<String, dynamic> config = null]): super(config) {}

  NodeImpl _createSvgImpl([bool isReflection = false]) {
    SvgPattern impl = new SvgPattern(this);
    _children.forEach((node) {
      node._impl = node._createSvgImpl(isReflection);
      impl.addChild(node._impl);
    });
    return impl;
  }

  String get id => getAttribute(ID, '__sc_pattern_${uid}');
}
part of smartcanvas.svg;

class SvgPath extends SvgNode {
  SvgPath(Path shell, bool isReflection): super(shell, isReflection) {}

  SVG.SvgElement _createElement() {
    return new SVG.PathElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([D]);
    return attrs;
  }

  String get _nodeName => SC_PATH;

  SVG.PathElement get element => super.element;
}
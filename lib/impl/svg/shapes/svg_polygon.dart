part of smartcanvas.svg;

class SvgPolygon extends SvgNode {
  SvgPolygon(Polygon shell, bool isReflection): super(shell, isReflection) {}

  SVG.SvgElement _createElement() {
    return new SVG.PolygonElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([POINTS]);
    return attrs;
  }

  String get _nodeName => SC_POLYGON;
}
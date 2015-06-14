part of smartcanvas.svg;

class SvgPolygon extends SvgNode {
  SvgPolygon(Polygon shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.PolygonElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([POINTS]);
    return attrs;
  }

  static const String _scPolygon = '__sc_polygon';

  @override
  String get _nodeName => _scPolygon;
}

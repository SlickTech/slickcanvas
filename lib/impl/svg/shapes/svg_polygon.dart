part of smartcanvas.svg;

class SvgPolygon extends SvgPolyShape {

  SvgPolygon(Polygon shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.PolygonElement();

  static const String _scPolygon = '__sc_polygon';

  @override
  String get _nodeName => _scPolygon;
}

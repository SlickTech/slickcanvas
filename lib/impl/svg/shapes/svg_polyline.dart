part of smartcanvas.svg;

class SvgPolyline extends SvgPolyShape {

  SvgPolyline(Polyline shell, bool isReflection) : super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.PolylineElement();

  @override
  List<String> _getStyleNames() {
    var rt = super._getStyleNames();
    rt.addAll([STROKE_LINE_JOIN, STROKE_LINECAP]);
    return rt;
  }

  @override
  bool _setElementAttribute(String attr) {
    if (attr == POINTS) {
      _implElement.attributes[attr] = (shell as Polyline).pointsString;
      return false;
    }
    return super._setElementAttribute(attr);
  }

  void set points(List<num> value) => setAttribute(POINTS, value);

  List<num> get points => getAttribute(POINTS, []) as List<num>;

  static const String _scPolyline = '__sc_polyline';

  @override
  String get _nodeName => _scPolyline;

}

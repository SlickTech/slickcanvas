part of smartcanvas.svg;

class SvgPolyline extends SvgNode {
  SvgPolyline(Polyline shell, bool isReflection) : super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.PolylineElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([POINTS]);
    return attrs;
  }

  @override
  void _setElementAttribute(String attr) {
    if (attr == POINTS) {
      _element.attributes[attr] = shell.pointsString;
    } else {
      super._setElementAttribute(attr);
    }
  }

  @override
  List<String> _getStyleNames() {
    var rt = super._getStyleNames();
    rt.addAll([STROKE_LINE_JOIN, STROKE_LINECAP]);
    return rt;
  }

  void set points(List<num> value) => setAttribute(POINTS, value);

  List<num> get points => getAttribute(POINTS, []);

  static const String _scPolyline = '__sc_polyline';

  @override
  String get _nodeName => _scPolyline;

  @override
  Polyline get shell => super.shell;
}

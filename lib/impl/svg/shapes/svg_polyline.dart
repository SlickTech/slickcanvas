part of smartcanvas.svg;

class SvgPolyline extends SvgNode {
    SvgPolyline(Polyline shell, bool isReflection) : super(shell, isReflection);
    SVG.SvgElement _createElement() {
        return new SVG.PolylineElement();
    }

    Set<String> _getElementAttributeNames() {
        var attrs = super._getElementAttributeNames();
        attrs.addAll([POINTS]);
        return attrs;
    }

    void _setElementAttribute(String attr) {
        if (attr == POINTS) {
            _element.attributes[attr] = shell.pointsString;
        } else {
            super._setElementAttribute(attr);
        }
    }

    List<String> _getStyleNames() {
        var rt = super._getStyleNames();
        rt.addAll([STROKE_LINE_JOIN, STROKE_LINECAP]);
        return rt;
    }

    void set points(List<num> value) => setAttribute(POINTS, value);
    List<num> get points => getAttribute(POINTS, []);

    String get _nodeName => SC_POLYLINE;

    Polyline get shell => super.shell;
}

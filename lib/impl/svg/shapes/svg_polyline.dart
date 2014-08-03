part of smartcanvas.svg;

class SvgPolyline extends SvgNode {
  SvgPolyline(Polyline shell, bool isReflection): super(shell, isReflection) {}

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
      if (points.isEmpty) {
        return;
      }

      num i = 0;
      String attrValue = EMPTY;
      points.forEach((point) {
        if (i == 1) {
          attrValue += COMMA;
        } else if (i == 2) {
          attrValue += SPACE;
          i -= 2;
        }
        attrValue += '${point}';
        ++i;
      });

      // append 0 if there was odd numbers in the array
      if (i == 1) {
        attrValue += ',${0}';
      }
      _element.attributes[attr] = attrValue;
    } else {
      super._setElementAttribute(attr);
    }
  }

  void set points(List<num> value) => setAttribute(POINTS, value);
  List<num> get points => getAttribute(POINTS, []);

  String get _nodeName => SC_POLYLINE;
}
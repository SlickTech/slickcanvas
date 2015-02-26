part of smartcanvas.svg;

class SvgImage extends SvgNode {

  SvgImage(Image shell, bool isReflection): super(shell, isReflection);

  SVG.SvgElement _createElement() {
    return new SVG.ImageElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([WIDTH, HEIGHT, HREF]);
    return attrs;
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        if (attr == HREF) {
          _element.setAttributeNS(NS_XLINK, HREF, '$value');
        } else {
          _element.attributes[attr] = '$value';
        }
      }
    }
  }

  String get _nodeName => SC_IMAGE;
}
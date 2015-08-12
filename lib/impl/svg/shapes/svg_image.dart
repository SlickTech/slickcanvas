part of smartcanvas.svg;

class SvgImage extends SvgNode {

  SvgImage(Image shell, bool isReflection) : super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.ImageElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([WIDTH, HEIGHT, HREF]);
    return attrs;
  }

  @override
  bool _setElementAttribute(String attr) {
    if (attr == HREF) {
      var value = getAttribute(attr);
      if (value != null) {
        if (value is! String || !value.isEmpty) {
          _implElement.setAttributeNS(NS_XLINK, HREF, '$value');
        }
      }
      return false;
    }
    return super._setElementAttribute(attr);
  }

  static const String _scImage = '__sc_image';

  @override
  String get _nodeName => _scImage;
}

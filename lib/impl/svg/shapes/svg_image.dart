part of smartcanvas.svg;

class SvgImage extends SvgNode {
  SVG.ImageElement _image;

  SvgImage(Image shell, bool isReflection): super(shell, isReflection) {
    new Future.delayed(new Duration(seconds: 1), (){
      _addImage();
    });
  }

  SVG.SvgElement _createElement() {
    return new SVG.SvgSvgElement();
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([WIDTH, HEIGHT]);
    return attrs;
  }

  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    switch (attr) {
      case NS_XLINK:
        return 'http://www.w3.org/1999/xlink';
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }

  void _addImage() {
    _image = new SVG.ImageElement();
    _setImageAttributes();
    _element.append(_image);
  }

  void _setImageAttributes() {
    [X, Y, WIDTH, HEIGHT, XLINK_HREF].forEach((attr) {
      var value = getAttribute(attr);
      if (value != null) {
        if (!(value is String) || !value.isEmpty) {
          _image.attributes[attr] = '$value';
        }
      }
    });
  }

  String get _nodeName => SC_IMAGE;
}
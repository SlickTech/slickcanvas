part of smartcanvas.svg;

abstract class SvgPolyShape extends SvgNode {
  num _offsetX = 0;
  num _offsetY = 0;

  SvgPolyShape(shell, bool isReflection): super(shell, isReflection);

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y, POINTS]);
    return attrs;
  }

  @override
  bool _setElementAttribute(String attr) {
    if (attr == X) {
      _offsetX = getAttribute(attr, 0);
      return false;
    } else if (attr == Y) {
      _offsetY = getAttribute(attr, 0);
      return false;
    }
    return super._setElementAttribute(attr);
  }

  @override
  void set translateX(num value) { shell.translateX = value - _offsetX; }

  @override
  num get translateX => _offsetX + super.translateX;

  @override
  void set translateY(num value) { shell.translateY = value - _offsetY; }

  @override
  num get translateY => _offsetY + super.translateY;
}

part of smartcanvas.svg;

class SvgPattern extends SvgGroup {

  SvgPattern(SCPattern shell): super(shell, false) {}

  SVG.SvgElement _createElement() {
    return new SVG.PatternElement();
  }

  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([WIDTH, HEIGHT, PATTERN_UNITS]);
    return rt;
  }

  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    if (attr == ID) {
      return super.getAttribute(attr, defaultValue != null ? defaultValue : shell.id);
    } else {
      return super.getAttribute(attr, defaultValue);
    }
  }

  String get _nodeName => SC_PATTERN;
}
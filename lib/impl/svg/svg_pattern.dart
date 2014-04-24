part of smartcanvas.svg;

class SvgPattern extends SvgGroup {

  SvgPattern(SCPattern shell): super(shell) {}

  SVG.SvgElement _createElement() {
    return new SVG.PatternElement();
  }

  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([WIDTH, HEIGHT, PATTERN_UNITS]);
    return rt;
  }

  String get _nodeName => SC_PATTERN;
}
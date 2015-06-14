part of smartcanvas.svg;

class SvgPattern extends SvgGroup {

  static const String scPattern = '__sc_pattern';

  SvgPattern(SCPattern shell): super(shell, false);

  @override
  svg.SvgElement _createElement() => new svg.PatternElement();

  @override
  Set<String> _getElementAttributeNames() {
    var rt = super._getElementAttributeNames();
    rt.addAll([WIDTH, HEIGHT, PATTERN_UNITS]);
    return rt;
  }

  @override
  dynamic getAttribute(String attr, [dynamic defaultValue = null]) {
    if (attr == ID) {
      return super.getAttribute(attr, defaultValue != null ? defaultValue : shell.id);
    }
    return super.getAttribute(attr, defaultValue);
  }

  @override
  String get _nodeName => scPattern;
}

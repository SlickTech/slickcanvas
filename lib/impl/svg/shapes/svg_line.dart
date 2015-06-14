part of smartcanvas.svg;

class SvgLine extends SvgNode {
  SvgLine(Line shell, bool isReflection): super(shell, isReflection);

  @override
  svg.SvgElement _createElement() => new svg.LineElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X1, Y1, X2, Y2]);
    return attrs;
  }

  static const String _scLine = '__sc_line';

  @override
  String get _nodeName => _scLine;
}

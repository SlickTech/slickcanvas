part of smartcanvas.svg;

class SvgPath extends SvgNode {
  SvgPath(Path shell, bool isReflection) : super(shell, isReflection) {
    this.shell.on('dChanged', () => _setElementAttribute(D));
  }

  @override
  svg.SvgElement _createElement() => new svg.PathElement();

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([D]);
    return attrs;
  }

  @override
  List<String> _getStyleNames() {
    var rt = super._getStyleNames();
    rt.addAll([STROKE_LINE_JOIN, STROKE_LINECAP]);
    return rt;
  }

  static const String _scPath = '__sc_path';

  @override
  String get _nodeName => _scPath;

  @override
  svg.PathElement get element => super.element;
}

part of smartcanvas.svg;

class SvgPath extends SvgNode {
    SvgPath(Path shell, bool isReflection) : super(shell, isReflection) {
        this.shell.on('dChanged', () => _setElementAttribute(D));
    }

    SVG.SvgElement _createElement() {
        return new SVG.PathElement();
    }

    Set<String> _getElementAttributeNames() {
        var attrs = super._getElementAttributeNames();
        attrs.addAll([D]);
        return attrs;
    }

    List<String> _getStyleNames() {
        var rt = super._getStyleNames();
        rt.addAll([STROKE_LINE_JOIN, STROKE_LINECAP]);
        return rt;
    }

    String get _nodeName => SC_PATH;

    SVG.PathElement get element => super.element;
}

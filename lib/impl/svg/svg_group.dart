part of smartcanvas.svg;

class SvgGroup extends SvgContainerNode {

    SvgGroup(Group shell, bool isReflection) : super(shell, isReflection);

    @override
    svg.SvgElement _createElement() => new svg.GElement();

    @override
    void _setElementAttribute(String attr) {
        super._setElementAttribute(attr);
        num x = shell.attrs[X];
        num y = shell.attrs[Y];
        bool b = false;
        if (x != null) {
            shell.translateX = x;
            b = true;
        }

        if (y != null) {
            shell.translateY = y;
            b = true;
        }

        if (b) {
            transform();
        }
    }

    static const String _scGroup = '__sc_group';
    @override
    String get _nodeName => _scGroup;
}

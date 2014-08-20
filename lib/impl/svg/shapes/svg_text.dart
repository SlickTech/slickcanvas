part of smartcanvas.svg;

class SvgText extends SvgNode{
  SvgText(Text shell, bool isReflection): super(shell, isReflection) {
    shell.on('textChanged', _handleTextChange);
  }

  SVG.SvgElement _createElement() {
    SVG.SvgElement text = new SVG.TextElement();
    text.text = getAttribute(TEXT, EMPTY);
    return text;
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y]);
    return attrs;
  }

  void _setElementStyles() {
    super._setElementStyles();
    Text txt = shell as Text;
    _element.style.setProperty(FONT_SIZE, '${txt.fontSize}px');
    _element.style.setProperty(FONT_FAMILY, '${txt.fontFamily}');
    _element.style.setProperty(FONT_WEIGHT, '${txt.fontWeight}');
    _element.style.setProperty(TEXT_ANCHOR, '${txt.textAnchor}');
  }

  bool _isStyle(String attr) {
    if (attr == FONT_SIZE ||
        attr == FONT_FAMILY ||
        attr == TEXT_ANCHOR ||
        attr == FONT_WEIGHT) {
      return true;
    }
    return super._isStyle(attr);
  }

  void _handleTextChange(oldValue, newValue) {
    _element.text = newValue;
  }

  num get width {
    return (_element as SVG.TextElement).getBBox().width;
  }

  String get _nodeName => SC_TEXT;
}
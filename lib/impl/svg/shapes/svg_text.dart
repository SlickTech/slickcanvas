part of smartcanvas.svg;

class SvgText extends SvgNode{
  SvgText(Text shell, bool isReflection): super(shell, isReflection) {
    shell.on('textChanged', _handleTextChange);
  }

  SVG.SvgElement _createElement() {
    SVG.SvgElement text = new SVG.TextElement();

    _updateTextContent(text);
    return text;
  }

  void _updateTextContent(SVG.TextElement text) {
    text.nodes.clear();

    var parts = shell.partsOfWrappedText();

    for (num i = 0; i < parts.length; ++i) {
      if (i == 0) {
        text.appendText(parts[i] + (i == parts.length - 1 ? '' : shell.wordSpliter));
      } else {
        SVG.TSpanElement tspan = new SVG.TSpanElement();
        tspan.appendText(parts[i] + (i == parts.length - 1 ? '' : shell.wordSpliter));
        tspan.setAttribute('dx', '-${Text.measureText(shell.font, parts[i - 1] + shell.wordSpliter)}');
        tspan.setAttribute('dy', '${shell.fontSize}');
        text.append(tspan);
      }
    }
  }

  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y]);
    return attrs;
  }

  void _setElementStyles() {
    super._setElementStyles();
    _element.style.setProperty(FONT_SIZE, '${shell.fontSize}px');
    _element.style.setProperty(FONT_FAMILY, '${shell.fontFamily}');
    _element.style.setProperty(FONT_WEIGHT, '${shell.fontWeight}');
    _element.style.setProperty(FONT_STYLE, '${shell.fontStyle}');
    _element.style.setProperty(TEXT_ANCHOR, '${shell.textAnchor}');
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

  void _handleTextChange() {
    _updateTextContent(_element);
  }

  num get width {
    return (_element as SVG.TextElement).getBBox().width;
  }

  String get _nodeName => SC_TEXT;

  Text get shell => super.shell;
}
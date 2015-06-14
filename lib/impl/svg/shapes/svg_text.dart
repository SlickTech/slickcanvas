part of smartcanvas.svg;

class SvgText extends SvgNode {
  SvgText(Text shell, bool isReflection): super(shell, isReflection) {
    shell.on('textChanged', _handleTextChange);
  }

  @override
  svg.SvgElement _createElement() {
    svg.SvgElement text = new svg.TextElement();

    _updateTextContent(text);
    return text;
  }

  void _updateTextContent(svg.TextElement text) {
    text.nodes.clear();

    var parts = shell.partsOfWrappedText();

    for (num i = 0; i < parts.length; ++i) {
      if (i == 0) {
        text.appendText(parts[i] + (i == parts.length - 1 ? '' : shell.wordSplitter));
      } else {
        svg.TSpanElement tspan = new svg.TSpanElement();
        tspan.appendText(parts[i] + (i == parts.length - 1 ? '' : shell.wordSplitter));
        tspan.setAttribute('dx', '-${Text.measureText(shell.font, parts[i - 1] + shell.wordSplitter)}');
        tspan.setAttribute('dy', '${shell.fontSize}');
        text.append(tspan);
      }
    }
  }

  @override
  Set<String> _getElementAttributeNames() {
    var attrs = super._getElementAttributeNames();
    attrs.addAll([X, Y]);
    return attrs;
  }

  @override
  void _setElementStyles() {
    super._setElementStyles();
    _element.style.setProperty(FONT_SIZE, '${shell.fontSize}px');
    _element.style.setProperty(FONT_FAMILY, '${shell.fontFamily}');
    _element.style.setProperty(FONT_WEIGHT, '${shell.fontWeight}');
    _element.style.setProperty(FONT_STYLE, '${shell.fontStyle}');
    _element.style.setProperty(TEXT_ANCHOR, '${shell.textAnchor}');
  }

  @override
  bool _isStyle(String attr) {
    if (attr == FONT_SIZE ||
    attr == FONT_FAMILY ||
    attr == TEXT_ANCHOR ||
    attr == FONT_WEIGHT) {
      return true;
    }
    return super._isStyle(attr);
  }

  void _handleTextChange() => _updateTextContent(_element);

  @override
  num get width => (_element as svg.TextElement).getBBox().width;

  static const String _scText = '__sc_text';

  @override
  String get _nodeName => _scText;

  @override
  Text get shell => super.shell;
}

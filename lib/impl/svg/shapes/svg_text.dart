part of smartcanvas.svg;

class SvgText extends SvgNode {
  SvgText(Text shell, bool isReflection): super(shell, isReflection) {
    shell
      ..on('textChanged', _handleTextChange)
      ..on('widthChanged', _handleTextChange)
    ;
  }

  @override
  svg.SvgElement _createElement() {
    svg.SvgElement text = new svg.TextElement();

    _updateTextContent(text);
    return text;
  }

  void _updateTextContent(svg.TextElement el) {
    el.nodes.clear();

    var text = shell as Text;
    var parts = text.partsOfWrappedText();
    var splitter = text.wordSplitter;
    var fontSize = text.fontSize;

    for (num i = 0; i < parts.length; ++i) {
      if (i == 0) {
        el.appendText(parts[i] + (i == parts.length - 1 ? '' : splitter));
      } else {
        svg.TSpanElement tspan = new svg.TSpanElement();
        tspan.appendText(parts[i] + (i == parts.length - 1 ? '' : splitter));
        tspan.setAttribute('x', '0');
        tspan.setAttribute('dy', '${fontSize}');
        el.append(tspan);
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
    var text = shell as Text;
    super._setElementStyles();
    _implElement.style.setProperty(FONT_SIZE, '${text.fontSize}px');
    _implElement.style.setProperty(FONT_FAMILY, '${text.fontFamily}');
    _implElement.style.setProperty(FONT_WEIGHT, '${text.fontWeight}');
    _implElement.style.setProperty(FONT_STYLE, '${text.fontStyle}');
    _implElement.style.setProperty(TEXT_ANCHOR, '${text.textAnchor}');
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

  void _handleTextChange() => _updateTextContent(_implElement);

  @override
  num get width => (_implElement as svg.TextElement).getBBox().width;

  static const String _scText = '__sc_text';

  @override
  String get _nodeName => _scText;

}

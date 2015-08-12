part of smartcanvas;

class Text extends Node {

  static final TextMeasure _textMeasure = new TextMeasure();
  static const String PX_SPACE = 'px ';

  List<String> _parts = [];

  Text([Map<String, dynamic> config = const {}]) : super(config) {
    _updateParts();

    this
      ..on('textChanged', _updateParts)
      ..on('widthChanged', _updateParts);
  }

  @override
  Node _clone(Map<String, dynamic> config) => new Text(config);

  @override
  NodeImpl _createSvgImpl([bool isReflection = false]) =>
    new SvgText(this, isReflection);

  @override
  NodeImpl _createCanvasImpl() => new CanvasText(this);

  static num measureText(String font, String text) {
    return _textMeasure.measureText(font, text);
  }

  List<String> partsOfWrappedText() {
    if (_parts.isEmpty) {
      _updateParts();
    }
    return _parts;
  }

  void _updateParts() {
    _parts.clear();

    if (wrap == false || !hasAttribute(WIDTH)) {
      _parts = [this.text];
    } else {
      if (Text.measureText(font, text) > getAttribute(WIDTH)) {
        var words = text.split(wordSplitter);
        var i = 0;
        var partial = empty;
        var t;
        while (i < words.length) {
          t = (partial.isEmpty ? empty : wordSplitter) + words[i];
          if (Text.measureText(font, partial + t) > getAttribute(WIDTH)) {
            if (partial.isEmpty) {
              // The only word is too long to fit
              _parts.add(t);
              ++i;
            } else {
              _parts.add(partial);
              partial = empty;
            }
          } else {
            partial += t;
            ++i;
          }
        }

        if (partial.isNotEmpty) {
          _parts.add(partial);
        }
      } else {
        _parts = [this.text];
      }
    }
  }

  void set text(String value) => setAttribute(TEXT, value);
  String get text => getAttribute(TEXT);

  /**
   * set/get font family. 'Arial' is default.
   */
  void set fontFamily(String value) => setAttribute(FONT_FAMILY, value);
  String get fontFamily => getAttribute(FONT_FAMILY, 'Arial');

//  /**
//   * set/get font variant. Can be 'normal' or 'small-caps'.  'normal' is the default.
//   */
//  void set fontVariant(String value) => setAttribute('font-variant', value);
//  String get fontVariant => getAttribute('font-variant', 'normal');
//
  /**
   *  set/get font style. Can be 'normal', 'italic' or 'bold'. 'normal' is default.
   */
  void set fontStyle(String value) => setAttribute('font-style', value);
  String get fontStyle => getAttribute('font-style', 'normal');

  /**
   * set/get font size. 12 is default.
   */
  void set fontSize(num value) => setAttribute(FONT_SIZE, value);
  num get fontSize => getAttribute(FONT_SIZE, 12);

  void set fontWeight(String value) => setAttribute(FONT_WEIGHT, value);
  String get fontWeight => getAttribute(FONT_WEIGHT, normal);

  /**
   * get font.
   */
  String get font => '$fontSize' + PX_SPACE + fontFamily;

  /**
   * set/get padding
   */
  void set padding(num value) => setAttribute(PADDING, value);
  num get padding => getAttribute(PADDING, 0);

  @override
  num get width {
    var rt = 0;
    _parts.forEach((t) {
      num w = measureText(font, t);
      if (rt < w) {
        rt = w;
      }
    });
    return rt;
  }

  @override
  num get height => fontSize * _parts.length;

  void set textAnchor(String value) => setAttribute(TEXT_ANCHOR, value);
  String get textAnchor => getAttribute(TEXT_ANCHOR);

  void set wrap(bool value) => setAttribute(WRAP, value);
  bool get wrap => getAttribute(WRAP, false);

  void set wordSplitter(String value) => setAttribute(WORD_SPLITTER, value);
  String get wordSplitter => getAttribute(WORD_SPLITTER, ' ');

  @override
  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(x: pos.x, y: pos.y - fontSize, width: actualWidth, height: this.actualHeight);
  }
}

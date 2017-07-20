import 'graph_node.dart';

class Text extends GraphNode {
  static const String PX_SPACE = 'px ';

  List<String> _parts = [];

  Text([Map<String, dynamic> props = const {}]) : super(props) {
    _updateParts();

    properties.changes.listen((changes) {
      for (MapChangeRecord<String, dynamic> change in changes) {
        if (change.key == 'textChanged' || change.key == 'widthChanged') {
          _updateParts();
        }
      }
    });
  }

  @override
  Text clone([Map<String, dynamic> propertiesOverride = const {}]) =>
      new Text(cloneProperties(propertiesOverride));

//  @override
//  Node _clone(Map<String, dynamic> config) => new Text(config);
//
//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) =>
//    new SvgText(this, isReflection);
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasText(this);

  num measureText(String font, String text) =>
      measureText != null ? measureText(font, text) : fontSize * text.length;

  List<String> partsOfWrappedText() {
    if (_parts.isEmpty) {
      _updateParts();
    }
    return _parts;
  }

  void _updateParts() {
    _parts.clear();

    if (wrap == false || !hasProperty('width')) {
      _parts = [this.text];
    } else {
      if (measureText(font, text) > getProperty('width')) {
        var words = text.split(wordSplitter);
        var i = 0;
        var partial = '';
        var t;
        while (i < words.length) {
          t = (partial.isEmpty ? '' : wordSplitter) + words[i];
          if (measureText(font, partial + t) > getProperty('width')) {
            if (partial.isEmpty) {
              // The only word is too long to fit
              _parts.add(t);
              ++i;
            } else {
              _parts.add(partial);
              partial = '';
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

  void set text(String value) => setProperty('text', value);
  String get text => getProperty('text');

  /**
   * set/get font family. 'Arial' is default.
   */
  void set fontFamily(String value) => setProperty('font-family', value);
  String get fontFamily => getProperty('font-family', 'Arial');

//  /**
//   * set/get font variant. Can be 'normal' or 'small-caps'.  'normal' is the default.
//   */
//  void set fontVariant(String value) => setProperty('font-variant', value);
//  String get fontVariant => getProperty('font-variant', 'normal');
//
  /**
   *  set/get font style. Can be 'normal', 'italic' or 'bold'. 'normal' is default.
   */
  void set fontStyle(String value) => setProperty('font-style', value);
  String get fontStyle => getProperty('font-style', 'normal');

  /**
   * set/get font size. 12 is default.
   */
  void set fontSize(num value) => setProperty('font-size', value);
  num get fontSize => getProperty('font-size', 12);

  void set fontWeight(String value) => setProperty('font-weight', value);
  String get fontWeight => getProperty('font-weight', 'normal');

  /**
   * get font.
   */
  String get font => '${fontStyle} ${fontSize}px ${fontFamily}';

  /**
   * set/get padding
   */
  void set padding(num value) => setProperty('padding', value);
  num get padding => getProperty('padding', 0);

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

  void set textAnchor(String value) => setProperty('text-anchor', value);
  String get textAnchor => getProperty('text-anchor');

  void set wrap(bool value) => setProperty('wrap', value);
  bool get wrap => getProperty('wrap', false);

  void set wordSplitter(String value) => setProperty('wordSplitter', value);
  String get wordSplitter => getProperty('wordSplitter', ' ');

  @override
  BoundingBox get bbox {
    var pos = absolutePosition;
    return new BoundingBox(pos.x, pos.y - fontSize, width, height);
  }
}

part of smartcanvas.canvas;

class CanvasLayer extends CanvasNode implements LayerImpl {

  List<CanvasNode> _children = new List<CanvasNode>();
  bool _suspended = false;
  DOM.Element _element;
  Set<String> _classNames = new Set<String>();

  CanvasLayer(Layer shell): super(shell) {
    _element = new DOM.CanvasElement();
    _element.dataset['scNode'] = '${shell.uid}';
    _setElementAttributes();
    _setElementStyles();
  }

  void _setClassName() {
    _classNames.add(SC_CANVAS);
    if (hasAttribute(CLASS)) {
      _classNames.addAll(getAttribute(CLASS).split(SPACE));
    }
    setAttribute(CLASS, _classNames.join(SPACE));
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([ID, CLASS, WIDTH, HEIGHT]);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        _element.attributes[attr] = '$value';
      }
    }
  }

  void _setElementStyles() {
    _element.style
    ..position = ABSOLUTE
    ..top = ZERO
    ..left = ZERO
    ..margin = ZERO
    ..padding = ZERO;
  }

  void add(CanvasNode node) {
  }

  void insert(int index, CanvasNode node) {
  }

  void removeChild(CanvasNode node) {
  }

  void suspend() {
    _suspended = true;
  }

  void resume() {
    _suspended = false;
    _draw();
  }

  void _draw() {
    if (!_suspended) {

    }
  }

  List<CanvasNode> get children => _children;
  DOM.Element get element => _element;

  Position get absolutePosition {
    return null;
  }
}
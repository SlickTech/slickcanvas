part of smartcanvas.canvas;

class CanvasTile extends NodeBase implements Container<CanvasGraphNode> {

  static num MAX_WIDTH = 800;
  static num MAX_HEIGHT = 600;

  TransformMatrix _transformMatrix;

  DOM.CanvasElement _element;
  DOM.CanvasRenderingContext2D _context;
  CanvasLayer _layer;

  bool _dirty = false;
  bool _suspended =false;

  List<CanvasGraphNode> _children = [];

  BBox _dirtyRagion;
  BBox _previousDirtyRagion;

  CanvasTile(this._layer, Map<String, dynamic> config): super(config) {
    _element = new DOM.CanvasElement();
    _element.dataset['scNode'] = '${uid}';

    _setElementAttributes();
    _setElementStyles();

    _context = _element.context2D;
    _context.scale(DOM.window.devicePixelRatio, DOM.window.devicePixelRatio);

    this
      .on('widthChanged', _onWidthChanged)
      .on('heightChanged', _onHeightChanged);
  }

  void _scaleCanvas() {
      _element.setAttribute(WIDTH, '${this.width * DOM.window.devicePixelRatio}');
      _element.setAttribute(HEIGHT, '${this.height * DOM.window.devicePixelRatio}');
      _element.style.width = '${this.width}px';
      _element.style.height = '${this.height}px';
      _context.scale(DOM.window.devicePixelRatio, DOM.window.devicePixelRatio);
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (value is! String || !value.isEmpty) {
        if ((attr == WIDTH || attr == HEIGHT)) {
          value = value * DOM.window.devicePixelRatio;
        }
        _element.attributes[attr] = '$value';
      }
    }
  }

  void _setElementStyles() {
    _element.style
    ..position = ABSOLUTE
    ..top = '${y}px'
    ..left = '${x}px'
    ..margin = ZERO
    ..padding = ZERO
    ..borderWidth = ZERO
    ..background = 'transparent'
    ..width = '${width}px'
    ..height = '${height}px';
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([ID, CLASS, WIDTH, HEIGHT]);
  }

  void _onWidthChanged(oldValue, newValue) {
    _element.style.width = '${newValue}px';
    _element.setAttribute(WIDTH, '${newValue * DOM.window.devicePixelRatio}');
  }

  void _onHeightChanged(oldValue, newValue) {
    _element.style.height = '${newValue}px';
    _element.setAttribute(HEIGHT, '${newValue * DOM.window.devicePixelRatio}');
  }

  void remove() {
    _element.remove();
  }

  void draw() {
    if (_suspended || _dirtyRagion == null) {
      return;
    }

    _context.save();
    _context.scale(DOM.window.devicePixelRatio, DOM.window.devicePixelRatio);

    var left, top, right, bottom;

    if (_previousDirtyRagion != null) {
      left = min(_previousDirtyRagion.x, _dirtyRagion.x);
      top = min(_previousDirtyRagion.y, _dirtyRagion.y);
      right = max(_previousDirtyRagion.right, _dirtyRagion.right);
      bottom = max(_previousDirtyRagion.bottom, _dirtyRagion.bottom);
      _context.clearRect(left - this.x - 10, top - this.y - 10, right - left + 20, bottom - top + 20);
    } else {
      left = _dirtyRagion.x;
      top = _dirtyRagion.top;
      right = _dirtyRagion.right;
      bottom = _dirtyRagion.bottom;
      _context.clearRect(_dirtyRagion.x - this.x - 10, _dirtyRagion.y - this.y - 10, _dirtyRagion.width + 20, _dirtyRagion.height + 20);
    }

    _children.forEach((node) {
      // only redraw node inside dirty ragion
      var bbox = node.shell.getBBox(true);
      if (bbox.left <= right &&
          bbox.right >= left &&
          bbox.top <= bottom &&
          bbox.bottom >= top) {
        _context.save();
        node.draw(this.x, this.y, _context);
        _context.restore();
      }
    });
    _context.restore();
    _previousDirtyRagion = _dirtyRagion;
    _dirtyRagion = null;
  }

  void suspend() {
    _suspended = true;
  }

  void resume() {
    _suspended = false;
    draw();
  }

  void set x(num value) => setAttribute(X, value);
  num get x => getAttribute(X, 0);

  void set y(num value) => setAttribute(Y, value);
  num get y => getAttribute(Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);
  num get width => getAttribute(WIDTH, MAX_WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);
  num get height => getAttribute(HEIGHT, MAX_HEIGHT);

  void addChild(CanvasGraphNode node) {
    _children.add(node);
  }

  void removeChild(CanvasGraphNode node) {
    _children.remove(node);
  }

  void clearChildren() {
    while(_children.isNotEmpty) {
      _children.first.remove();
    }
  }

  void insertChild(num index, CanvasGraphNode node) {
    _children.insert(index, node);
  }

  void nodeDirty(BBox dirtyRagion) {
    if (_dirtyRagion == null) {
      _dirtyRagion = dirtyRagion;
    } else {
      num x = min(_dirtyRagion.x, dirtyRagion.x);
      num y = min(_dirtyRagion.y, dirtyRagion.y);
      _dirtyRagion = new BBox(
          x: x, y: y,
          width: max(_dirtyRagion.right, dirtyRagion.right) - x,
          height: max(_dirtyRagion.bottom, dirtyRagion.bottom) - y);
    }
  }

  List<CanvasGraphNode> get children => _children;
  bool get dirty => _dirty;
}
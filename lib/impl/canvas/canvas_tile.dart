part of smartcanvas.canvas;

class CanvasTile extends NodeBase with Container<CanvasGraphNode> {

  static int MAX_WIDTH = 800;
  static int MAX_HEIGHT = 600;

  final dom.CanvasElement _element = new dom.CanvasElement();
  dom.CanvasRenderingContext2D _context;

  bool _dirty = false;
  bool _suspended = false;

  BBox _dirtyRagion;
  BBox _previousDirtyRagion;

  CanvasTile(Map<String, dynamic> config): super(config) {
    _element.dataset['scNode'] = '${uid}';

    _setElementAttributes();
    _setElementStyles();

    _context = _element.context2D;
    _context.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);

    this
      ..on('widthChanged', _onWidthChanged)
      ..on('heightChanged', _onHeightChanged);
  }

  void _scaleCanvas() {
    _element.setAttribute(WIDTH, '${this.width * dom.window.devicePixelRatio}');
    _element.setAttribute(HEIGHT, '${this.height * dom.window.devicePixelRatio}');
    _element.style.width = '${this.width}px';
    _element.style.height = '${this.height}px';
    _context.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);
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
          value = value * dom.window.devicePixelRatio;
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

  Set<String> _getElementAttributeNames() => new Set<String>.from([ID, CLASS, WIDTH, HEIGHT]);

  void _onWidthChanged(newValue) {
    _element.style.width = '${newValue}px';
    _element.setAttribute(WIDTH, '${newValue * dom.window.devicePixelRatio}');
  }

  void _onHeightChanged(newValue) {
    _element.style.height = '${newValue}px';
    _element.setAttribute(HEIGHT, '${newValue * dom.window.devicePixelRatio}');
  }

  void remove() => _element.remove();

  void draw() {
    if (_suspended || _dirtyRagion == null) {
      return;
    }

    _context.save();
    _context.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);

    var left, top, right, bottom;

    if (_previousDirtyRagion != null) {
      left = min(_previousDirtyRagion.x, _dirtyRagion.x) - 10;
      top = min(_previousDirtyRagion.y, _dirtyRagion.y) - 10;
      right = max(_previousDirtyRagion.right, _dirtyRagion.right) + 10;
      bottom = max(_previousDirtyRagion.bottom, _dirtyRagion.bottom) + 10;
      _context.clearRect(left - this.x, top - this.y, right - left, bottom - top);
    } else {
      left = _dirtyRagion.x - 10;
      top = _dirtyRagion.top - 10;
      right = _dirtyRagion.right + 10;
      bottom = _dirtyRagion.bottom + 10;
      _context.clearRect(left - this.x, top - this.y, _dirtyRagion.width + 20, _dirtyRagion.height + 20);
    }

    children.forEach((node) {
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

  @override
  void addChild(CanvasGraphNode node) {
    children.add(node);
  }

  @override
  void removeChild(CanvasGraphNode node) {
    children.remove(node);
  }

  @override
  void clearChildren() {
    while (children.isNotEmpty) {
      children.first.remove();
    }
  }

  @override
  void insertChild(num index, CanvasGraphNode node) {
    children.insert(index, node);
  }

  void nodeDirty(BBox dirtyRagion) {
    if (_dirtyRagion == null) {
      _dirtyRagion = dirtyRagion;
    } else {
      var x = min(_dirtyRagion.x, dirtyRagion.x);
      var y = min(_dirtyRagion.y, dirtyRagion.y);
      _dirtyRagion = new BBox(
          x: x, y: y,
          width: max(_dirtyRagion.right, dirtyRagion.right) - x,
          height: max(_dirtyRagion.bottom, dirtyRagion.bottom) - y);
    }
  }

  void set x(num value) => setAttribute(X, value);

  num get x => getAttribute(X, 0);

  void set y(num value) => setAttribute(Y, value);

  num get y => getAttribute(Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);

  num get width => getAttribute(WIDTH, MAX_WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);

  num get height => getAttribute(HEIGHT, MAX_HEIGHT);

  bool get dirty => _dirty;
}

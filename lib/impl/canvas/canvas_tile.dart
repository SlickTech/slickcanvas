part of smartcanvas.canvas;

num _getPixelRatio() {
  DOM.CanvasElement canvas = new DOM.CanvasElement();
  return DOM.window.devicePixelRatio / canvas.context2D.backingStorePixelRatio;
}

class CanvasTile extends NodeBase {

  static num MAX_WIDTH = 800;
  static num MAX_HEIGHT = 600;
  static num _defaultPixelRatio = _getPixelRatio();

  TransformMatrix _transformMatrix;

  DOM.CanvasElement _element;
  DOM.CanvasRenderingContext2D _context;
  CanvasLayer _layer;
  num _pixelRatio = _defaultPixelRatio;

  bool _dirty = false;
  bool _suspended =false;

  CanvasTile(this._layer, Map<String, dynamic> config): super(config) {
    _element = new DOM.CanvasElement();
    _element.dataset['scNode'] = '${uid}';
    _context = _element.context2D;
    _setElementAttributes();
    _setElementStyles();

    this
      .on('pixelRatioChanged', _onPixelRatioChanged)
      .on('widthChanged', _onWidthChanged)
      .on('heightChanged', _onHeightChanged);
  }

  void _scaleCanvas() {
    if (DOM.window.devicePixelRatio != _context.backingStorePixelRatio) {
      _element.setAttribute(WIDTH, '${this.width * _pixelRatio}');
      _element.setAttribute(HEIGHT, '${this.height * _pixelRatio}');
      _element.style.width = '${this.width}px';
      _element.style.height = '${this.height}px';
      _context.scale(_pixelRatio, _pixelRatio);
    }
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (value is! String || !value.isEmpty) {
        if ((attr == WIDTH || attr == HEIGHT) &&
            DOM.window.devicePixelRatio != _context.backingStorePixelRatio) {
          value = value * _pixelRatio;
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
    ..border = ZERO
    ..background = 'transparent'
    ..width = '${width}px'
    ..height = '${height}px';
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([ID, CLASS, WIDTH, HEIGHT]);
  }

  dynamic getAttribute(String attr, [dynamic defaultValue]) {
    switch (attr) {
      case WIDTH:
        return CanvasTile.MAX_WIDTH * _pixelRatio;
      case HEIGHT:
        return CanvasTile.MAX_HEIGHT * _pixelRatio;
      default:
        return super.getAttribute(attr, defaultValue);
    }
  }

  void _onPixelRatioChanged(oldValue, newValue) {
    if (DOM.window.devicePixelRatio != _context.backingStorePixelRatio) {
      _context.scale(newValue, newValue);
      _element.setAttribute(WIDTH, '${this.width * newValue}');
      _element.setAttribute(HEIGHT, '${this.height * newValue}');
    }
  }

  void _onWidthChanged(oldValue, newValue) {
    _element.style.width = '${newValue}px';
    if (DOM.window.devicePixelRatio != _context.backingStorePixelRatio) {
      _element.setAttribute(WIDTH, '${this.width * newValue}');
    } else {
      _element.setAttribute(WIDTH, '$newValue');
    }
  }

  void _onHeightChanged(oldValue, newValue) {
    _element.style.height = '${newValue}px';
    if (DOM.window.devicePixelRatio != _context.backingStorePixelRatio) {
      _element.setAttribute(HEIGHT, '${this.width * newValue}');
    } else {
      _element.setAttribute(HEIGHT, '$newValue');
    }
  }

  void remove() {
    _element.remove();
  }

  void draw() {
    if (_suspended || !_dirty) {
      return;
    }
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

  void set pixelRatio(num value) {
    num oldValue = _pixelRatio;
    _pixelRatio = value;
    if (oldValue != value) {
      fire('pixelRatioChanged', oldValue, value);
    }
  }
  num get pixelRatio => _pixelRatio;

  void set dirty(bool value) {
    _dirty = value;
    if (value) {
      draw();
    }
  }
  bool get dirty => _dirty;
}
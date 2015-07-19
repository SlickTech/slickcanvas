part of smartcanvas.canvas;

abstract class CanvasGraphNode extends CanvasNode {

  bool _dirty = false;
  bool _useCache = false;

  final dom.CanvasElement _cacheCanvas = new dom.CanvasElement();
  dom.CanvasRenderingContext2D _cacheContext;

  BBox _oldBBox = new BBox(x: double.MAX_FINITE, y: double.MAX_FINITE,
  width: -double.MAX_FINITE, height: -double.MAX_FINITE);

  CanvasGraphNode(Node shell): super(shell) {
    _cacheContext = _cacheCanvas.context2D;

    _setElementAttributes();
    _setElementStyles();

    shell
      ..on('translateXChanged', () => _refresh())
      ..on('translateYChanged', () => _refresh())
      ..on('widthChanged', _onWidthChanged)
      ..on('heighChanged', _onHeightChanged)
      ..on(attrChanged, () {
      if (_useCache) {
        _updateCache(true);
      } else {
        _tiles.forEach((tile) {
          tile.nodeDirty(this.shell.getBBox(true));
        });
        _oldBBox = shell.getBBox(true);
      }
    });

    new Future.delayed(new Duration(seconds:0), () {
      if (_useCache) {
        _updateCache(true);
      }
    });

    _cacheContext.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);
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
        _cacheCanvas.attributes[attr] = '$value';
      }
    }
  }

  void _onWidthChanged(newValue) {
    _cacheCanvas.style.width = '${newValue}px';
    _cacheCanvas.setAttribute(WIDTH, '${newValue * dom.window.devicePixelRatio}');
    _refresh(true);
  }

  void _onHeightChanged(newValue) {
    _cacheCanvas.style.height = '${newValue}px';
    _cacheCanvas.setAttribute(HEIGHT, '${newValue * dom.window.devicePixelRatio}');
    _refresh(true);
  }

  void _setElementStyles() {
    _cacheCanvas.style
      ..width = '${width}px'
      ..height = '${height}px';
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([WIDTH, HEIGHT]);
  }

  void _refresh([bool dirty = false]) {
    _updateTiles();
    if (_useCache) {
      _updateCache(dirty);
    } else {
      _tiles.forEach((tile) {
        tile.nodeDirty(this.shell.getBBox(true));
      });
      _oldBBox = shell.getBBox(true);
    }
  }

  void _updateCache(bool dirty) {
    if (dirty) {
      _cacheGraph();
      _fillGraph();
      _strokeGraph();
    }
    _tiles.forEach((tile) {
      tile.nodeDirty(this.shell.getBBox(true));
    });
    _oldBBox = shell.getBBox(true);
  }

  void _drawGraph(dom.CanvasRenderingContext2D context) {
    __drawGraph(context);
    _fillGraph(context);
    _strokeGraph(context);
  }

  void _cacheGraph();

  void __drawGraph(dom.CanvasRenderingContext2D context);

  void _fillGraph([dom.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }
    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill == 'none' ? 'transparent' : shell.fill;
        context.fill();
      }
    } else {
      context.fillStyle = 'black';
      context.fill();
    }
  }

  void _strokeGraph([dom.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    if (stroke != null) {
      context.lineWidth = shell.strokeWidth.toDouble();
      context.strokeStyle = shell.stroke;
      context.lineJoin = shell.strokeLineJoin;
      context.stroke();
    }
  }

  void _updateTiles() {
    var newTiles = [];
    var bbox = this.shell.getBBox(true);
    layer._tiles.forEach((tile) {
      if (bbox.left <= (tile.x + tile.width) &&
      bbox.right >= tile.x &&
      bbox.top <= (tile.y + tile.height) &&
      bbox.bottom >= tile.y) {
        if (!tile.children.contains(this)) {
          tile.addChild(this);
          tile.nodeDirty(this.shell.getBBox(true));
        }
        newTiles.add(tile);
      } else if (tile.children.contains(this)) {
        tile.children.remove(this);
        tile.nodeDirty(this.shell.getBBox(true));
      }
    });
    this._tiles = newTiles;
    _oldBBox = shell.getBBox(true);
  }

  void draw(num offsetX, num offsetY, dom.CanvasRenderingContext2D context) {
    if (shell.visible == false) {
      return;
    }

    var matrix = shell.transformMatrix;
    context.save();

    if (shell.rotate != null) {
      num rx = shell.x + shell.getAttribute(ROTATE_X, 0);
      num ry = shell.y + shell.getAttribute(ROTATE_Y, 0);
      if (rx != 0 || ry != 0) {
        context.translate(rx, ry);
        context.rotate(shell.rotate * PI / 180);
        context.translate(-rx, -ry);
      } else {
        context.rotate(shell.rotate * PI / 180);
      }
    }
    context.transform(matrix.m11, matrix.m12, matrix.m21, matrix.m22, shell.x - offsetX, shell.y - offsetY);

    if (_useCache) {
      context.drawImageScaled(_cacheCanvas, 0, 0, _cacheCanvas.width / dom.window.devicePixelRatio,
      _cacheCanvas.height / dom.window.devicePixelRatio);
    } else {
      _drawGraph(context);
    }
    context.restore();
  }
}

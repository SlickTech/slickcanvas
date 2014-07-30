part of smartcanvas.canvas;

abstract class CanvasGraphNode extends CanvasNode {

  bool _dirty = false;
  bool _useCache = false;
  DOM.CanvasElement _cacheCanvas;
  DOM.CanvasRenderingContext2D _cacheContext;
  BBox _oldBBox = new BBox(x: double.MAX_FINITE, y: double.MAX_FINITE,
      width: -double.MAX_FINITE, height: -double.MAX_FINITE);

  CanvasGraphNode(Node shell): super(shell) {
    _cacheCanvas = new DOM.CanvasElement();
    _cacheContext = _cacheCanvas.context2D;

    _setElementAttributes();
    _setElementStyles();

    shell
      .on('translateXChanged', _refresh)
      .on('translateYChanged', _refresh)
      .on('widthChanged', _refresh)
      .on('heighChanged', _refresh)
      .on(ATTR_CHANGED, () {
        if (_useCache) {
          _updateCache();
        } else {
          _tiles.forEach((tile) {
            tile.nodeDirty(this.shell.getBBox(true));
          });
          _oldBBox = shell.getBBox(true);
        }

    });

    new Future.delayed(new Duration(seconds:0), () {
      if (_useCache) {
        _updateCache();
      }
    });
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (value is! String || !value.isEmpty) {
        _cacheCanvas.attributes[attr] = '$value';
      }
    }
  }

  void _setElementStyles() {
    _cacheCanvas.style
      ..width = '${width}px'
      ..height = '${height}px';
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([WIDTH, HEIGHT]);
  }

  void _refresh() {
    _updateTiles();
    if (_useCache) {
      _updateCache();
    } else {
      _tiles.forEach((tile) {
        tile.nodeDirty(this.shell.getBBox(true));
      });
      _oldBBox = shell.getBBox(true);
    }
  }

  void _updateCache() {
    _cacheGraph();
    _fillGraph();
    _strokeGraph();
    _tiles.forEach((tile) {
      tile.nodeDirty(this.shell.getBBox(true));
    });
    _oldBBox = shell.getBBox(true);
  }

  void _drawGraph(DOM.CanvasRenderingContext2D context) {
    __drawGraph(context);
    _fillGraph(context);
    _strokeGraph(context);
  }

  void _cacheGraph();
  void __drawGraph(DOM.CanvasRenderingContext2D context);

  void _fillGraph([DOM.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }
    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill;
        context.fill();
      }
    }
  }

  void _strokeGraph([DOM.CanvasRenderingContext2D context]) {
    if (context == null) {
      context = _cacheContext;
    }

    if (stroke != null) {
      context.strokeStyle = shell.stroke;
      context.stroke();
    }
  }

  void _updateTiles() {
    List<CanvasTile> newTiles = [];
    BBox bbox = this.shell.getBBox(true);
    num i = 0;
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
      i++;
    });
    this._tiles = newTiles;
    _oldBBox = shell.getBBox(true);
  }

  void draw(num offsetX, num offsetY, DOM.CanvasRenderingContext2D context) {
    var matrix = shell.transformMatrix;
    context.save();
    context.transform(matrix.m11, matrix.m12, matrix.m21, matrix.m22, shell.x - offsetX, shell.y - offsetY);
    if (shell.rotation != null) {
      context.rotate(shell.rotation);
    }

    if (_useCache) {
      context.drawImage(_cacheCanvas, 0, 0);
    } else {
      _drawGraph(context);
    }
    context.restore();
  }
}
part of smartcanvas.canvas;

abstract class CanvasGraphNode extends CanvasNode {

  bool _dirty = false;

  dom.CanvasElement _cacheCanvas;
  dom.CanvasRenderingContext2D _cacheContext;

  CanvasGraphNode(Node shell): super(shell) {
//    if (getAttribute('useCache', false)) {
//      _cacheCanvas = new dom.CanvasElement();
//      _cacheContext = _cacheCanvas.context2D;
//
//      _setElementAttributes();
//      _setElementStyles();
//
//      _cacheContext.scale(dom.window.devicePixelRatio, dom.window.devicePixelRatio);
//      new Future.delayed(new Duration(seconds:0), () => _updateCache(true));
//    }

    shell
      ..on([translateXChanged, translateYChanged, translateChanged,
        scaleXChanged, scaleYChanged, scaleChanged, resize], () => _refresh())
      ..on('widthChanged', _onWidthChanged)
      ..on('heighChanged', _onHeightChanged)
      ..on(attrChanged, _onAttrChanged)
    ;
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

  void _onAttrChanged() {
    if (_cacheCanvas != null) {
      _updateCache(true);
    } else {
      var bbox = getBBox(true);
      for (CanvasTile tile in _tiles) {
        tile.nodeDirty(bbox);
      }
    }
  }

  void _onWidthChanged(newValue) {
    if (_cacheCanvas != null) {
      _cacheCanvas.style.width = '${newValue}px';
      _cacheCanvas.setAttribute(WIDTH, '${newValue * dom.window.devicePixelRatio}');
    }
    _refresh(true);
  }

  void _onHeightChanged(newValue) {
    if (_cacheCanvas != null) {
      _cacheCanvas.style.height = '${newValue}px';
      _cacheCanvas.setAttribute(HEIGHT, '${newValue * dom.window.devicePixelRatio}');
    }
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
    if (_cacheCanvas != null) {
      _updateCache(dirty);
    } else {
//      var bbox = getBBox(true);
//      _tiles.forEach((tile) {
//        tile.nodeDirty(bbox);
//      });
    }
  }

  void _updateCache(bool dirty) {
    if (dirty) {
      _clearCache();
      _drawGraph(_cacheContext);
      _fillGraph(_cacheContext);
      _strokeGraph(_cacheContext);

      var bbox = getBBox(true);
//      _tiles.forEach((tile) {
//        tile.nodeDirty(bbox);
//      });
    }
  }

  void _drawNode(dom.CanvasRenderingContext2D context) {
    _drawGraph(context);
    _fillGraph(context);
    _strokeGraph(context);
  }

  void _clearCache() {
//    print("********** clear cache");
//    _cacheContext.save();
//    _cacheContext.clearRect(0, 0, _cacheCanvas.width, _cacheCanvas.height);
//    _cacheContext.restore();
  }

  void _drawGraph(dom.CanvasRenderingContext2D context);

  void _fillGraph(dom.CanvasRenderingContext2D context) {
    if (fill != null) {
      if (fill is Gradient) {

      } else if (fill is SCPattern) {

      } else {
        context.fillStyle = shell.fill == 'none' ? 'transparent' : shell.fill;
        context.fill();
      }
    } else {
//      context.fillStyle = 'black';
      context.fillStyle = 'transparent';
      context.fill();
    }
  }

  void _strokeGraph(dom.CanvasRenderingContext2D context) {
    if (stroke != null) {
      context.lineWidth = shell.strokeWidth.toDouble();
      context.strokeStyle = shell.stroke;
      context.lineJoin = shell.strokeLineJoin;
      context.stroke();
    }
  }

  void _updateTiles() {
    if (parent != null) {
      if (parent is CanvasLayer) {
        List<CanvasTile> newTiles = [];
        var bbox = this.getBBox(true);

        for (CanvasTile tile in layer._tiles) {
          if (bbox.left <= (tile.x + tile.width) &&
            bbox.right >= tile.x &&
            bbox.top <= (tile.y + tile.height) &&
            bbox.bottom >= tile.y) {
            if (!tile.children.contains(this)) {
              tile.addChild(this);
            }
            tile.nodeDirty(bbox);
            newTiles.add(tile);
          } else if (tile.children.contains(this)) {
            tile.children.remove(this);
            tile.nodeDirty(bbox);
          }
        }
        this._tiles = newTiles;
      } else {
        parent._updateTiles();
      }
    }
  }

  void draw(num offsetX, num offsetY, dom.CanvasRenderingContext2D context) {
    if (shell.visible == false) {
      return;
    }

//    _cacheGraph();

    var matrix = shell.transformMatrix;
    context.save();

    if (shell.rotate != null) {
      num rx = shell.x + getAttribute(ROTATE_X, 0);
      num ry = shell.y + getAttribute(ROTATE_Y, 0);
      if (rx != 0 || ry != 0) {
        context.translate(rx, ry);
        context.rotate(shell.rotate * PI / 180);
        context.translate(-rx, -ry);
      } else {
        context.rotate(shell.rotate * PI / 180);
      }
    }
    context.transform(
      matrix.m11 * getAttribute(RESIZE_SCALE_X, 1),
      matrix.m12,
      matrix.m21,
      matrix.m22 * getAttribute(RESIZE_SCALE_Y, 1),
      shell.x - offsetX,
      shell.y - offsetY
    );

    if (_cacheCanvas != null) {
//      context.drawImageScaled(
//        _cacheCanvas, 0, 0,
//        _cacheCanvas.width / dom.window.devicePixelRatio,
//        _cacheCanvas.height / dom.window.devicePixelRatio
//      );
      context.drawImage(_cacheCanvas, 0, 0);
    } else {
      _drawNode(context);
    }
    context.restore();
  }
}

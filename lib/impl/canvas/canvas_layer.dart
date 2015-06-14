part of smartcanvas.canvas;

class CanvasLayer extends CanvasNode with Container<CanvasGraphNode> implements LayerImpl {

  static const String _scCanvas = '__sc_canvas';

  bool _suspended = false;
  final dom.Element _element = new dom.DivElement();
  final Set<String> _classNames = new Set<String>();

  CanvasLayer(Layer shell): super(shell) {
    _element.dataset['scNode'] = '${shell.uid}';
    _setElementAttributes();
    _setElementStyles();
    _setClassName();

    _updateTiles();
    _registerEvents();
  }

  void _setClassName() {
    _classNames.add(_scCanvas);
    if (shell.hasAttribute(CLASS)) {
      _classNames.addAll(getAttribute(CLASS).split(space));
    }
    setAttribute(CLASS, _classNames.join(space));
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  Set<String> _getElementAttributeNames() => new Set<String>.from([ID, CLASS]);

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
      ..padding = ZERO
      ..width = '${width}px'
      ..height = '${height}px';
  }

  void _updateTiles() {
    if (width != null && width > 0 && height != null && height > 0) {
      var nTilesInRow = (width / CanvasTile.MAX_WIDTH).ceil();
      var nRows = (height / CanvasTile.MAX_HEIGHT).ceil();
      var nTiles = 0;
      var tileWidth = width / (width / CanvasTile.MAX_WIDTH).ceil();
      var tileHeight = height / (height / CanvasTile.MAX_HEIGHT).ceil();
      for (int i = 0; i < nRows; i++) {
        for (int j = 0; j < nTilesInRow; j++) {
          if ((i * nTilesInRow + j) < _tiles.length) {
            var tile = _tiles[nTiles];
            _adjustTileSize(tile, tileWidth, tileHeight);
            ++nTiles;
            continue;
          } else {
            var tile = new CanvasTile({
              X: j * tileWidth,
              Y: i * tileHeight
            });
            _adjustTileSize(tile, tileWidth, tileHeight);
            _tiles.add(tile);
          }
          _element.append(_tiles.last._element);
          ++nTiles;
        }
      }

      while (nTiles < _tiles.length) {
        var tile = _tiles[nTiles];
        tile.remove();
        _tiles.remove(tile);
      }
    }

    children.forEach((node) {
      node._updateTiles();
    });
  }

  void _adjustTileSize(CanvasTile tile, num tileWidth, num tileHeight) {
    if ((tile.x + tileWidth) > width) {
      tile.width = width - tile.x;
    } else {
      tile.width = tileWidth;
    }

    if ((tile.y + tileHeight) > height) {
      tile.height = height - tile.y;
    } else {
      tile.height = tileHeight;
    }
  }

  void _registerEvents() {
    shell
      ..on('widthChanged', _onWidthChanged)
      ..on('heightChanged', _onHeightChanged)
      ..on('opacityChanged', _onOpacityChanged)
      ..on('stageSet', _onStageSet);
  }

  void _onWidthChanged(newValue) {
    _element.style.width = '${newValue}px';
    _updateTiles();
  }

  void _onHeightChanged(newValue) {
    _element.style.height = '${newValue}px';
    _updateTiles();
  }

  void _onOpacityChanged(num newValue) {
    _element.style.opacity = '$newValue';
  }

  void _onStageSet() {
    if (children.isNotEmpty) {
      AnimationLoop.instance.subscribe(shell.uid.toString(), _draw);
    }
  }

  void addChild(CanvasGraphNode node) {
    if (children.isEmpty && stage != null) {
      AnimationLoop.instance.subscribe(shell.uid.toString(), _draw);
    }

    children.add(node);
    node.parent = this;
    node._updateTiles();
  }

  void insertChild(int index, CanvasGraphNode node) {
    if (children.isEmpty) {
      AnimationLoop.instance.subscribe(shell.uid.toString(), _draw);
    }

    children.insert(index, node);
    node.parent = this;
    node._updateTiles();
  }

  void removeChild(CanvasNode node) {
    _tiles.forEach((tile) {
      if (tile.children.contains(node)) {
        tile.children.remove(node);
      }
    });

    node.parent = null;
    children.remove(node);

    if (children.isEmpty) {
      AnimationLoop.instance.unsubscribe(shell.uid.toString());
    }
  }

  void clearChildren() {
    children.forEach((node) {
      this.removeChild(node);
    });
  }

  void suspend() {
    _suspended = true;
  }

  void resume() {
    _suspended = false;
  }

  void _draw(num timestamp) {
    if (!_suspended) {
      _tiles.forEach((tile) {
        tile.draw();
      });
    }
  }

  void remove() {
    _element.remove();
    if (parent != null) {
      (parent as Container).children.remove(this);
    }
    _tiles.forEach((tile) {
      tile.remove();
    });
    _tiles.clear();
    parent = null;
  }

  void translate() {
  }

  dom.Element get element => _element;

  @override
  CanvasLayer get layer => this;
}

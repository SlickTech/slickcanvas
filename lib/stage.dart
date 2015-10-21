part of smartcanvas;

class Stage extends NodeBase with Container<Node> {
  dom.Element _container;
  dom.Element _element;
  Layer _defaultLayer;

  _ReflectionLayer _reflectionLayer;
  final CanvasType _defaultLayerType;

  Position _pointerPosition;
  bool _dragStarting = false;
  bool _dragging = false;
  bool _dragStarted = false;
  num _dragOffsetX = 0;
  num _dragOffsetY = 0;
  final TransformMatrix _transformMatrix = new TransformMatrix();

  Stage(this._container, {Map<String, dynamic> config: const {}, defaultLayerType: CanvasType.svg})
  : _defaultLayerType = defaultLayerType
  , super(config) {

    _populateConfig(config);
    _createElement();

    if (_container == null) {
      throw "container doesn't exit";
    }

    if (getValue(config, CREATE_SHADOW_ROOT, false)) {
      _container.createShadowRoot().append(this._element);
    } else {
      _container.nodes.add(this._element);
    }

    if (isStatic == false) {
      _reflectionLayer = new _ReflectionLayer({WIDTH: this.width, HEIGHT: this.height});
      _reflectionLayer.stage = this;
      children.add(_reflectionLayer);
      _element.nodes.add(_reflectionLayer.impl.element);
    }

    _element.onMouseDown.listen(_onMouseDown);
    _element.onMouseMove.listen(_onMouseMove);
    _element.onMouseUp.listen(_onMouseUp);
    _element.onMouseEnter.listen(_setPointerPosition);
    _element.onMouseLeave.listen(_setPointerPosition);
    _element.onMouseOver.listen(_setPointerPosition);
    _element.onMouseOut.listen(_setPointerPosition);

    this.on('draggableChanged', (newValue) {
      if (!newValue) {
        _dragEnd();
      }
    });
  }

  void remove() {
    this._element.remove();
  }

  void _createElement() {
    var c = getAttribute(CLASS);
    _element = new dom.DivElement();
    if (id != null && !id.isEmpty) {
      _element.id = id;
    }
    _element.classes.add('smartcanvas-stage');
    if (c != null) {
      _element.classes.addAll(c.split(space));
    }
    _element.setAttribute('role', 'presentation');
    _element.style
      ..display = 'inline-block'
      ..position = 'relative'
      ..width = '${getAttribute(WIDTH)}px'
      ..height = '${getAttribute(HEIGHT)}px'
      ..margin = '0'
      ..padding = '0';
  }

  void _populateConfig(Map<String, dynamic> config) {
    if (getAttribute(WIDTH) == null) {
      setAttribute(WIDTH, _container.clientWidth);
    }

    if (getAttribute(HEIGHT) == null) {
      setAttribute(HEIGHT, _container.clientHeight);
    }

    var scale = getAttribute(SCALE);
    if (scale != null) {
      scaleX = scale;
      scaleY = scale;
    } else {
      scale = getAttribute(SCALE_X);
      if (scale != null) {
        scaleX = scale;
      }

      scale = getAttribute(SCALE_Y);
      if (scale != null) {
        scaleY = scale;
      }
    }
  }

  void _onMouseDown(e) {
    _setPointerPosition(e);
    fire(stageMouseDown, e);
    if (isDraggable) {
      _dragStart(e);
    }
  }

  void _onMouseMove(e) {
    _setPointerPosition(e);
    fire(stageMouseMove, e);
    if (_dragStarting) {
      _dragMove(e);
    }
  }

  void _onMouseUp(e) {
    _setPointerPosition(e);
    fire(stageMouseUp, e);
    if (_dragging) {
      _dragEnd(e);
    }
  }

  void _setPointerPosition(e) {
    var elementClientRect = _element.getBoundingClientRect();
    var x = (e.client.x - elementClientRect.left) / _transformMatrix.scaleX -
    _transformMatrix.translateX;
    var y = (e.client.y - elementClientRect.top) / _transformMatrix.scaleY -
    _transformMatrix.translateY;
    this._pointerPosition = new Position(x: x, y: y);
  }

  void _updatePointerPositionXFromScaleXChange(num newScaleX, num oldScaleX) {
    if (_pointerPosition != null) {
      var factor = oldScaleX / newScaleX;
      _pointerPosition.x = _pointerPosition.x * factor +
      _transformMatrix.translateX * (factor - 1);
    }
  }

  void _updatePointerPositionYFromScaleYChange(num newScaleY, num oldScaleY) {
    if (_pointerPosition != null) {
      var factor = oldScaleY / newScaleY;
      _pointerPosition.y = _pointerPosition.y * factor +
      _transformMatrix.translateY * (factor - 1);
    }
  }

  void _updatePointerPositionXFromTranslateXChange(num newTransX, num oldTransX) {
    if (_pointerPosition != null) {
      _pointerPosition.x += oldTransX - newTransX;
    }
  }

  void _updatePointerPositionYFromTranslateYChange(num newTransY, num oldTransY) {
    if (_pointerPosition != null) {
      _pointerPosition.y += oldTransY - newTransY;
    }
  }

  Position get pointerPosition => _pointerPosition;

  @override
  void addChild(Node node) {
    if (node is Layer) {
      node.stage = this;
      node._reflection = _reflectionLayer.impl as SvgLayer;

      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }

      if (_reflectionLayer != null) {
        int index = _element.nodes.indexOf(_reflectionLayer.impl.element);
        _element.nodes.insert(index, node.impl.element);
        children.insert(index, node);

        node.children.forEach((child) {
          _reflectionLayer.reflectNode(child);
        });
      } else {
        _element.nodes.add(node.impl.element);
        children.add(node);
      }
    } else {
      if (_defaultLayer == null) {
        _defaultLayer = new Layer(this._defaultLayerType, {
          ID: '__default_layer',
          WIDTH: width,
          HEIGHT: height
        });
        addChild(_defaultLayer);
      }
      _defaultLayer.addChild(node);
    }
  }

  @override
  void removeChild(Node node) {
    if (node is Layer) {
      children.remove(node);
      node._stage = null;
      node._reflection = null;
    } else {
      _defaultLayer.removeChild(node);
    }
  }

  @override
  void clearChildren() {
    while (children.isNotEmpty) {
      this.removeChild(children.first);
    }
  }

  @override
  void insertChild(int index, Node node) {
    if (node is Layer) {
      node.stage = this;

      children.insert(index, node);
      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }
      _element.nodes.insert(index, node.impl.element);

      if (_reflectionLayer != null) {
        node._reflection = _reflectionLayer.impl as SvgLayer;
        node.children.forEach((child) {
          _reflectionLayer.reflectNode(child);
        });
      }
    } else {
      _defaultLayer.insertChild(index, node);
    }
  }

  void _dragStart(dom.MouseEvent e) {
    if (this._dragStarting) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();

    this._dragStarting = true;

    this._dragOffsetX = _pointerPosition.x;
    this._dragOffsetY = _pointerPosition.y;
  }

  void _dragMove(dom.MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();
    if (!_dragStarted) {
      this._dragging = true;
      fire(dragStart, e);
      _dragStarted = true;
    }
    translateX += _pointerPosition.x - _dragOffsetX;
    translateY += _pointerPosition.y - _dragOffsetY;
    fire(dragMove, e);
  }

  void _dragEnd([dom.MouseEvent e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }
    _dragStarting = false;
    _dragging = false;
    if (_dragStarted) {
      fire(dragEnd, e);
    }
    _dragStarted = false;
  }

//  void getSvg(SvgNode defNode) {
//    if (_svgDefLayer == null) {
//      _svgDefLayer = new Layer(svg, {});
//      _svgDefLayer.stage = this;
//      _children.add(_svgDefLayer);
//      _element.nodes.add(_svgDefLayer._impl.element);
//    }
//  }

  dom.Element get element => _element;

  void set id(String value) => setAttribute(ID, value);

  String get id => getAttribute(ID);

  num get x => getAttribute(X, 0);

  num get y => getAttribute(Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);

  num get width => getAttribute(WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);

  num get height => getAttribute(HEIGHT);

  void set scaleX(num x) {
    var oldValue = _transformMatrix.scaleX;
    _transformMatrix.scaleX = x;

    if (oldValue != x) {
      _updatePointerPositionXFromScaleXChange(x, oldValue);
      fire('scaleXChanged', x, oldValue);
    }
  }

  void set scaleY(num y) {
    var oldValue = _transformMatrix.scaleY;
    _transformMatrix.scaleY = y;

    if (oldValue != y) {
      _updatePointerPositionYFromScaleYChange(y, oldValue);
      fire('scaleYChanged', y, oldValue);
    }
  }

  void set scale(scale) {
    num x, y;
    if (scale is num) {
      x = scale;
      y = scale;
    } else if (scale is Map) {
      x = getValue(scale, X);
      y = getValue(scale, Y);
      if (x == null && y == null) {
        return;
      } else if (x == null) {
        x = y;
      } else if (y == null) {
        y = x;
      }
    }

    scaleX = x;
    scaleY = y;
  }

  num get scaleX => _transformMatrix.scaleX;

  num get scaleY => _transformMatrix.scaleY;

  void set translateX(num tx) {
    var oldValue = _transformMatrix.translateX;
    _transformMatrix.translateX = tx;

    if (oldValue != tx) {
//      if (this._dragging == false) {
      _updatePointerPositionXFromTranslateXChange(tx, oldValue);
//      }
      fire('translateXChanged', tx, oldValue);
    }
  }

  num get translateX => _transformMatrix.translateX;

  void set translateY(num ty) {
    var oldValue = _transformMatrix.translateY;
    _transformMatrix.translateY = ty;

    if (oldValue != ty) {
//      if (!this._dragging == false) {
      _updatePointerPositionYFromTranslateYChange(ty, oldValue);
//      }
      fire('translateYChanged', ty, oldValue);
    }
  }

  num get translateY => _transformMatrix.translateY;

  dom.Element get container => _container;

  void set isDraggable(bool value) => setAttribute(DRAGGABLE, value);

  bool get isDraggable => getAttribute(DRAGGABLE, false);

  bool get isDragging => _dragging;

  bool get isStatic => getAttribute(IS_STATIC, false);
}

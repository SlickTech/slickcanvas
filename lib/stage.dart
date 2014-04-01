part of smartcanvas;

class Stage extends NodeBase implements Container<Node> {
  DOM.Element _container;
  DOM.Element _element;
  Layer _defaultLayer;
  _ReflectionLayer _reflectionLayer;
  String _defualtLayerType;
  List<Node> _children = new List<Node>();
  Position _pointerPosition;

  bool _dragging = false;
  bool _dragStarted = false;
  num _dragOffsetX = 0;
  num _dragOffsetY = 0;
  TransformMatrix _transformMatrix = new TransformMatrix();

  Stage(this._container, String this._defualtLayerType, Map<String, dynamic> config): super(){
    _populateConfig(config);
    _createElement();

    if (_container == null) {
      throw "container doesn't exit";
    }
    _container.createShadowRoot().append(this._element);
//    _container.nodes.add(this._element);

    _reflectionLayer = new _ReflectionLayer({
      WIDTH: this.width,
      HEIGHT: this.height
    });
    _reflectionLayer.stage = this;
    _children.add(_reflectionLayer);
    _element.nodes.add(_reflectionLayer._impl.element);

    _element.onMouseDown.listen(_onMouseDown);
    _element.onMouseMove.listen(_onMouseMove);
    _element.onMouseUp.listen(_onMouseUp);
    _element.onMouseEnter.listen(_setPointerPosition);
    _element.onMouseLeave.listen(_setPointerPosition);
  }

  void _createElement() {
    String c = getAttribute(CLASS);
    _element = new DOM.DivElement();
    if (id != null && !id.isEmpty) {
      _element.id = id;
    }
    _element.classes.add('smartcanvas-stage');
    if (c != null) {
      _element.classes.addAll(c.split(SPACE));
    }
    _element.setAttribute('role', 'presentation');
    _element.style
      ..display = 'inline-block'
      ..width = '${getAttribute(WIDTH)}'
      ..height = '${getAttribute(HEIGHT)}';
  }

  void _populateConfig(Map<String, dynamic> config) {
    _attrs.addAll(config);
    if (getAttribute(WIDTH) == null) {
      setAttribute(WIDTH, _container.clientWidth);
    }

    if (getAttribute(HEIGHT) == null) {
      setAttribute(HEIGHT, _container.clientHeight);
    }

    num scale = getAttribute(SCALE_X);
    if (scale != null) {
      scaleX = scale;
    }

    scale = getAttribute(SCALE_Y);
    if (scale != null) {
      scaleY = scale;
    }

    scale = getAttribute(SCALE);
    if (scale != null) {
      scaleX = scale;
      scaleY = scale;
    }
  }

  void _onMouseDown(e) {
    _setPointerPosition(e);
    fire('contentMouseDown', e);
    if (draggable) {
      _dragStart(e);
    }
  }

  void _onMouseMove(e) {
    _setPointerPosition(e);
    fire('contentMouseMove', e);
    if (_dragging) {
      _dragMove(e);
    }
  }

  void _onMouseUp(e) {
    _setPointerPosition(e);
    fire('contentMouseUp', e);
    if (_dragging) {
      _dragEnd(e);
    }
  }

  void _setPointerPosition(e) {
    num x = (e.client.x - _transformMatrix.tx) / _transformMatrix.sx;
    num y = (e.client.y - _transformMatrix.ty) / _transformMatrix.sy;
    print('cx: ${e.client.x}, ${e.client.y} - t: ${_transformMatrix.tx}, ${_transformMatrix.ty} - pp: $x, $y');
    this._pointerPosition = new Position(x: x, y: y);
  }

  Position get pointerPosition => _pointerPosition;

  void add(Node node) {
    if (node is Layer) {
      node.stage = this;
      node._reflection = _reflectionLayer;

      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }

      int index = _element.nodes.indexOf(_reflectionLayer._impl.element);
      _element.nodes.insert(index, node._impl.element);
      _children.add(node);

      node.children.forEach((child) {
        _reflectionLayer.reflectNode(child);
      });

    } else {
      if (_defaultLayer == null) {
        _defaultLayer = new Layer(this._defualtLayerType, {
          ID: '__default_layer',
          WIDTH: width,
          HEIGHT: height
        });
        add(_defaultLayer);
      }
      _defaultLayer.add(node);
    }
  }

  void removeChild(Node node) {
    if (node is Layer) {
      _children.remove(node);
      node._stage = null;
    } else {
      _defaultLayer.removeChild(node);
    }
  }

  void insert(int index, Node node) {
    if (node is Layer) {
      node.stage = this;
      _children.insert(index, node);
      if (node.width == null) {
        node.width = this.width;
        node.height = this.height;
      }
      node.createImpl(node.type);
      _element.nodes.add(node._impl.element);
    } else {
      _defaultLayer.insert(index, node);
    }
  }

  void _dragStart(DOM.MouseEvent e) {
    e.preventDefault();
    this._dragging = true;

    this._dragOffsetX = _pointerPosition.x - _transformMatrix.tx / _transformMatrix.sx;
    this._dragOffsetY = _pointerPosition.y - _transformMatrix.ty / _transformMatrix.sy;

    _element.onMouseUp.listen(_dragEnd).resume();
  }

  void _dragMove(DOM.MouseEvent e) {
    e.preventDefault();
    if (!_dragStarted) {
      fire('dragstart', e);
      _dragStarted = true;
    }
    _transformMatrix.tx = _pointerPosition.x - _dragOffsetX;
    _transformMatrix.ty = _pointerPosition.y - _dragOffsetY;
    fire(DRAGMOVE, e);
  }

  void _dragEnd(DOM.MouseEvent e) {
    e.preventDefault();
    _dragging = false;
  }


  List<Node> get children => _children;

  DOM.Element get element => _element;

  void set id(String value) => setAttribute(ID, value);
  String get id => getAttribute(ID);

  num get x => getAttribute(X, 0);
  num get y => getAttribute(Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);
  num get width => getAttribute(WIDTH);

  void set height(num value) => setAttribute(HEIGHT, value);
  num get height => getAttribute(HEIGHT);

  void set scaleX(num x) {
    num oldValue = _transformMatrix.sx;
    _transformMatrix.sx = x;
    if (oldValue != x) {
      fire('scaleXChanged', oldValue, x);
    }
  }
  void set scaleY(num y) {
    num oldValue = _transformMatrix.sy;
    _transformMatrix.sy = y;
    if (oldValue != y) {
      fire('scaleYChanged', oldValue, y);
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
      } else if (y == null){
        y = x;
      }
    }

    scaleX = x;
    scaleY = y;
  }

  num get scaleX => _transformMatrix.sx;
  num get scaleY => _transformMatrix.sy;

//  void set(num tx) {
//    var oldValue = _transformMatrix.tx;
//    _transformMatrix.tx = tx;
//    if (oldValue != tx) {
//      fire('translateXChanged', oldValue, tx);
//    }
//  }
//  num get tx => _transformMatrix.tx;
//
//  void set ty(num ty) {
//    var oldValue = _transformMatrix.ty;
//    _transformMatrix.ty = ty;
//    if (oldValue != ty) {
//      fire('translateYChanged', oldValue, ty);
//    }
//  }
//  num get ty => _transformMatrix.ty;

  DOM.Element get container => _container;

  void set draggable(bool value) => setAttribute(DRAGGABLE, value);
  bool get draggable => getAttribute(DRAGGABLE, false);
}


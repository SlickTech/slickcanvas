part of smartcanvas;

abstract class Node extends NodeBase {
  Layer _layer;
  NodeImpl _impl;
  Container<Node> _parent;
  I_Reflection _reflection;
  TransformMatrix _transformMatrix = new TransformMatrix();
  num _x0, _y0, _rotation;
  bool _listening = false;

  Node([Map<String, dynamic> config = const {}]): super(config) {
    populateConfig();
  }

  void populateConfig() {
    _x0 = getAttribute(X, 0);
    _y0 = getAttribute(Y, 0);
    if (hasAttribute(OFFSET_X)) {
      _transformMatrix.translateX -= getAttribute(OFFSET_X);
    }

    if (hasAttribute(OFFSET_Y)) {
      _transformMatrix.translateY -= getAttribute(OFFSET_Y);
    }
  }

  void remove() {
    if (_parent != null) {
      if (_impl != null) {
        _impl.remove();
      }

      if (_reflection != null) {
        (_reflection as Node).remove();
      }

      _parent.children.remove(this);
      _parent = null;
    }
  }

  NodeImpl createImpl(type) {
    switch (type) {
      case svg:
        return _createSvgImpl(this.isReflection);
      default:
        return _createCanvasImpl();
    }
  }

  NodeImpl _createSvgImpl(bool isReflection);
  NodeImpl _createCanvasImpl();

  void moveTo(Container parent) {
    if (_parent != null) {
      _parent.removeChild(this);
    }
    parent.addChild(this);
  }

  void moveUp() {
    int index;
    Container container = _parent;
    if (container != null) {
      index = container.children.indexOf(this);
      if (index != container.children.length - 1) {
        remove();
        container.insertChild(index + 1, this);
      }
    }
  }

  void moveDown() {
    int index;
    Container container = _parent;
    if (container != null) {
      index = container.children.indexOf(this);
      if (index > 0) {
        remove();
        container.insertChild(index - 1, this);
      }
    }
  }

  void moveToTop() {
    Container container = _parent;
    if (container != null) {
      int index = container.children.indexOf(this);
      if (index != container.children.length - 1) {
        this.remove();
        container.addChild(this);
      }
    }
  }

  void moveToBottom() {
    int index;
    Container container = _parent;
    if (container != null) {
      index = container.children.indexOf(this);
      if (index > 0) {
        this.remove();
        container.insertChild(0, this);
      }
    }
  }

  NodeBase on(String events, Function handler, [String id]) {
    List<String> ss = events.split(SPACE);
    ss.forEach((event) {
      if (_eventListeners[event] == null) {
        _eventListeners[event] = new EventHandlers();
      }
      _eventListeners[event].add(new EventHandler(id, handler));

      if (!_listening) {
        _listening = isDomEvent(event);
        if (_listening && this is! ReflectionNode && _parent != null) {
            (_parent as Group)._reflectionAdd(this);
        }
      }

      if (_impl != null) {
        _impl.on(event, handler, id);
      }

      if (_reflection != null) {
        (_reflection as Node).on(event, handler, id);
      }
    });
    // allow chaining
    return this;
  }

  Node clone([Map<String, dynamic> config]) {
    ClassMirror cm = reflectClass(this.runtimeType);
    Map<String, dynamic> cnfg;
    if(config != null) {
      cnfg = new Map<String, dynamic>.from(_attrs);
      cnfg.addAll(config);
    } else {
      cnfg = _attrs;
    }
    Node clone = cm.newInstance(const Symbol(EMPTY), [cnfg]).reflectee;
    if (_impl != null) {
      clone._impl = clone.createImpl(_impl.type);
    }
    return clone;
  }

  BBox getBBox(bool isAbsolute) {
    Position pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(x: pos.x, y: pos.y, width: this.width, height: this.height);
  }

  Position getRelativePosition(Node referenceParent) {
    Position pos = position;
    Position posParent;
    var parent = _parent;
    while (parent != null) {
      posParent = (parent as Node).position;
      pos += posParent;
      if (parent == referenceParent) {
        return pos;
      }
      parent = parent.parent;
    }
    return null;
  }

  /**
   * Show the node
   */
  void show() {
    visible = true;
  }

  /**
   * Hide the node
   */
  void hide() {
    visible = false;
  }

  /**
   * Get parent of this node
   */
  Container<Node> get parent => _parent;

  /**
   * Where or not the node if reflectable
   *
   * A node is reflectable if the node was draggable or listening
   */
  bool get reflectable {
    return draggable || _listening;
  }

  /**
   * Get the layer of the node
   */
  Layer get layer {
    Node parent = this._parent as Node;
    while(parent != null && parent is! Layer) {
      parent = parent._parent as Node;
    }
    return parent;
  }

  /**
   * Get the stage
   */
  Stage get stage {
    return layer == null ? null : layer.stage;
  }

  NodeImpl get impl => _impl;

  void set id(String value) => setAttribute(ID, value);
  String get id => getAttribute(ID);

  void set className(String value) => setAttribute(CLASS, value);
  String get className => getAttribute(CLASS, '');

  void set x(num value) { translateX = value - _x0; }
  num get x { return _x0 + _transformMatrix.translateX; }

  void set y(num value) { translateY = value - _y0; }
  num get y { return _y0 + _transformMatrix.translateY; }

  void set offsetX(num value) {
    num oldValue = getAttribute(OFFSET_X, 0);
    if (oldValue != value) {
      _attrs[OFFSET_X] = value;
      _transformMatrix.translateX += value - oldValue;
      fire('offsetXChanged', oldValue, value);
    }
  }
  num get offsetX => getAttribute(OFFSET_X, 0);

  void set offsetY(num value) {
    num oldValue = getAttribute(OFFSET_Y, 0);
    if (oldValue != value) {
      _attrs[OFFSET_Y] = value;
      _transformMatrix.translateY += value - oldValue;
      fire('offsetYChanged', oldValue, value);
    }
  }
  num get offsetY => getAttribute(OFFSET_Y, 0);

  void set width(num value) => setAttribute(WIDTH, value);
  num get width => getAttribute(WIDTH, 0);

  void set height(num value) => setAttribute(HEIGHT, value);
  num get height => getAttribute(HEIGHT, 0);

  void set stroke(dynamic value) => setAttribute(STROKE, value);
  dynamic get stroke => getAttribute(STROKE);

  void set strokeWidth(num value) => setAttribute(STROKE_WIDTH, value);
  num get strokeWidth => getAttribute(STROKE_WIDTH, 1);

  void set strokeOpacity(num value) => setAttribute(STROKE_OPACITY, value);
  num get strokeOpacity => getAttribute(STROKE_OPACITY);

  void set strokeLinecap(String value) => setAttribute(STROKE_LINECAP, value);
  String get strokeLinecap => getAttribute(STROKE_LINECAP);

  void set strokeLineJoin(String value) => setAttribute(STROKE_LINE_JOIN, value);
  String get strokeLineJoin => getAttribute(STROKE_LINE_JOIN);

  void set strokeDashArray(String value) => setAttribute(STROKE_DASHARRAY, value, true);
  String get strokeDashArray => getAttribute(STROKE_DASHARRAY);

  void set fill(dynamic value) => setAttribute(FILL, value);
  dynamic get fill => getAttribute(FILL);

  void set fillOpacity(num value) => setAttribute(FILL_OPACITY, value);
  num get fillOpacity => getAttribute(FILL_OPACITY);

  void set opacity(num value) => setAttribute(OPACITY, value);
  num get opacity => getAttribute(OPACITY, 1);

  void set draggable(bool value) => setAttribute(DRAGGABLE, value);
  bool get draggable => getAttribute(DRAGGABLE, false);

  bool get listening => _listening;

  void set visible(bool value) {
    if (!value) {
      setAttribute(DISPLAY, 'none');
    } else {
      removeAttribute(DISPLAY);
    }
  }
  bool get visible => !hasAttribute(DISPLAY);

  bool get isDragging {
    if (_reflection != null && (_reflection as Node)._impl != null) {
      return ((_reflection as Node)._impl as SvgNode).isDragging;
    }
    return false;
  }

  void set scaleX(num x) {
    num oldValue = _transformMatrix.scaleX;
    _transformMatrix.scaleX = x;
    if (oldValue != x) {
      fire('scaledXChanged', oldValue, x);
    }
  }
  num get scaleX => _transformMatrix.scaleX;

  void set scaleY(num y) {
    num oldValue = _transformMatrix.scaleY;
    _transformMatrix.scaleY = y;
    if (oldValue != y) {
      fire('scaledYChanged', oldValue, y);
    }
  }
  num get scaleY => _transformMatrix.scaleY;

  void set translateX(num tx) {
    num oldValue = _transformMatrix.translateX;
    _transformMatrix.translateX = tx;
    if (oldValue != tx) {
      fire('translateXChanged', oldValue, tx);
    }
  }
  num get translateX => _transformMatrix.translateX;

  void set translateY(num ty) {
    num oldValue = _transformMatrix.translateY;
    _transformMatrix.translateY = ty;
    if (oldValue != ty) {
      fire('translateYChanged', oldValue, ty);
    }
  }
  num get translateY => _transformMatrix.translateY;

  void set rotation(num r) {
    num oldValue = _rotation;
    _rotation = r;
    if (oldValue != r) {
      fire('rotationChanged', oldValue, r);
    }
  }
  num get rotation => _rotation;

  TransformMatrix get transformMatrix => _transformMatrix;

  Position get position {
    return new Position(x: _x0 +  transformMatrix.translateX, y: _y0 + transformMatrix.translateY);
  }

  void set absolutePosition(Position pos) {
    Position position = new Position();
    Position posParent;
    var parent = _parent;
    while (parent != null && parent is! Stage) {
      posParent = (parent as Node).position;
      position.x += posParent.x;
      position.y += posParent.y;
      parent = parent.parent;
    }
    this.x = pos.x - position.x;
    this.y = pos.y - position.y;
  }

  Position get absolutePosition {
    Position pos = position;
    Position posParent;
    var parent = _parent;
    while (parent != null && parent is! Stage) {
      posParent = (parent as Node).position;
      pos += posParent;
      parent = parent.parent;
    }
    return pos;
  }

  bool get isReflection => this is I_Reflection;

  I_Reflection get reflection => _reflection;
}
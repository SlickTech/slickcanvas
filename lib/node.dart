part of smartcanvas;

enum CanvasType {
  svg,
  canvas
}

abstract class Node extends NodeBase {

  NodeImpl _impl;
  ContainerNode _parent;
  SvgNode _reflection;
  TransformMatrix _transformMatrix = new TransformMatrix();

  num _x0, _y0;
  bool _isListening = false;

  Node(Map<String, dynamic> config) : super(config) {
    _populateConfig();
  }

  void _populateConfig() {
    _x0 = getAttribute(X, 0);
    _y0 = getAttribute(Y, 0);

    if (hasAttribute(OFFSET_X)) {
      _transformMatrix.translateX -= getAttribute(OFFSET_X);
    }

    if (hasAttribute(OFFSET_Y)) {
      _transformMatrix.translateY -= getAttribute(OFFSET_Y);
    }

    _transformMatrix.scaleX = getAttribute(SCALE_X, 1);
    _transformMatrix.scaleY = getAttribute(SCALE_Y, 1);
  }

  void remove() {
    if (_parent != null) {
      if (_reflection != null) {
        _reflection.remove();
      }

      if (_impl != null) {
        _impl.remove();
      }

      _parent.children.remove(this);
      _parent = null;
    }
  }

  NodeImpl createImpl(CanvasType type) {
    switch (type) {
      case CanvasType.svg:
        return _createSvgImpl();
      default:
        return _createCanvasImpl();
    }
  }

  SvgNode _createReflection() => _createSvgImpl(true);

  NodeImpl _createSvgImpl([bool isReflection = false]);

  NodeImpl _createCanvasImpl();

  void moveTo(Container parent) {
    if (_parent != null) {
      _parent.removeChild(this);
    }
    parent.addChild(this);
  }

  void moveUp() {
    int index;
    ContainerNode container = _parent;
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
    ContainerNode container = _parent;
    if (container != null) {
      index = container.children.indexOf(this);
      if (index > 0) {
        remove();
        container.insertChild(index - 1, this);
      }
    }
  }

  void moveToTop() {
    ContainerNode container = _parent;
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
    ContainerNode container = _parent;
    if (container != null) {
      index = container.children.indexOf(this);
      if (index > 0) {
        this.remove();
        container.insertChild(0, this);
      }
    }
  }

  @override
  NodeBase on(String events, Function handler, [String id]) {
    List<String> ss = events.split(space);
    ss.forEach((event) {
      if (eventListeners[event] == null) {
        eventListeners[event] = new EventHandlers();
      }
      eventListeners[event].add(new EventHandler(id, handler));

      if (!_isListening) {
        _isListening = isDomEvent(event);
        if (_isListening && _parent != null) {
          (_parent as Group)._reflectChild(this);
        }
      }

      if (_impl != null) {
        _impl.on(event, handler, id);
      }

      if (_reflection != null) {
        _reflection.on(event, handler, id);
      }
    });
    // allow chaining
    return this;
  }

  Node clone([Map<String, dynamic> config]) {
    Map<String, dynamic> clonedConfig = merge(attrs, config);
    var copy = _clone(clonedConfig);
    copy._transformMatrix = _transformMatrix.clone();
    return copy;
//    ClassMirror cm = reflectClass(this.runtimeType);
//    Map<String, dynamic> cnfg;
//    if (config != null) {
//      cnfg = new Map<String, dynamic>.from(attrs);
//      cnfg.addAll(config);
//    } else {
//      cnfg = attrs;
//    }
//    Node clone = cm.newInstance(const Symbol(empty), [cnfg]).reflectee;
//    if (_impl != null) {
//      clone._impl = clone.createImpl(_impl.type);
//    }
//    clone._transformMatrix = this._transformMatrix.clone();
//    return clone;
  }

  Node _clone(Map<String, dynamic> config);

  BBox getBBox(bool isAbsolute) {
    var pos = isAbsolute ? this.absolutePosition : this.position;
    return new BBox(x: pos.x, y: pos.y, width: this.width, height: this.height);
  }

  Position getRelativePosition(Node referenceParent) {
    var pos = position;
    var posParent;
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
  bool get reflectable => draggable || _isListening;

  /**
   * Get the layer of the node
   */
  Layer get layer {
    var parent = this._parent;
    while (parent != null && parent is! Layer) {
      parent = parent._parent;
    }
    return parent != null ? parent as Layer : null;
  }

  /**
   * Get the stage
   */
  Stage get stage => layer == null ? null : layer.stage;

  NodeImpl get impl => _impl;

  void set id(String value) => setAttribute(ID, value);
  String get id => getAttribute(ID);

  void set className(String value) => setAttribute(CLASS, value);
  String get className => getAttribute(CLASS, '');

  void set x(num value) {
    translateX = value - _x0;
  }

  num get x => _x0 + _transformMatrix.translateX;

  void set y(num value) {
    translateY = value - _y0;
  }

  num get y => _y0 + _transformMatrix.translateY;

  void set offsetX(num value) {
    var oldValue = getAttribute(OFFSET_X, 0);
    if (oldValue != value) {
      attrs[OFFSET_X] = value;
      _transformMatrix.translateX += value - oldValue;
      fire('offsetXChanged', value, oldValue);
    }
  }

  num get offsetX => getAttribute(OFFSET_X, 0);

  void set offsetY(num value) {
    num oldValue = getAttribute(OFFSET_Y, 0);
    if (oldValue != value) {
      attrs[OFFSET_Y] = value;
      _transformMatrix.translateY += value - oldValue;
      fire('offsetYChanged', value, oldValue);
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

  bool get isListening => _isListening;

  void set visible(bool value) {
    if (!value) {
      setAttribute(DISPLAY, 'none');
    } else {
      removeAttribute(DISPLAY);
    }
  }

  bool get visible => !hasAttribute(DISPLAY);

  bool get isDragging {
    if (_reflection != null) {
      return _reflection.isDragging;
    }
    return false;
  }

  void set scaleX(num x) {
    var oldValue = _transformMatrix.scaleX;
    _transformMatrix.scaleX = x;
    if (oldValue != x) {
      fire('scaleXChanged', x, oldValue);
    }
  }

  num get scaleX => _transformMatrix.scaleX;

  void set scaleY(num y) {
    var oldValue = _transformMatrix.scaleY;
    _transformMatrix.scaleY = y;
    if (oldValue != y) {
      fire('scaleYChanged', y, oldValue);
    }
  }

  num get scaleY => _transformMatrix.scaleY;

  void set translateX(num tx) {
    var oldValue = _transformMatrix.translateX;
    _transformMatrix.translateX = tx;
    if (oldValue != tx) {
      fire('translateXChanged', tx, oldValue);
    }
  }

  num get translateX => _transformMatrix.translateX;

  void set translateY(num ty) {
    var oldValue = _transformMatrix.translateY;
    _transformMatrix.translateY = ty;
    if (oldValue != ty) {
      fire('translateYChanged', ty, oldValue);
    }
  }

  num get translateY => _transformMatrix.translateY;

  void set rotate(num r) {
    var oldValue = getAttribute(ROTATE, null);
    setAttribute(ROTATE, r);
    if (oldValue != r) {
      fire('rotationChanged', r, oldValue);
    }
  }

  num get rotate => getAttribute(ROTATE, null);

  void set rotateX(num r) {
    var oldValue = getAttribute(ROTATE_X, null);
    setAttribute(ROTATE_X, r);
    if (oldValue != r) {
      fire('rotationChanged', r, oldValue);
    }
  }

  num get rotateX => getAttribute(ROTATE_X, null);

  void set rotateY(num r) {
    var oldValue = getAttribute(ROTATE_Y, null);
    setAttribute(ROTATE_Y, r);
    if (oldValue != r) {
      fire('rotationChanged', r, oldValue);
    }
  }

  num get rotateY => getAttribute(ROTATE_Y, null);

  TransformMatrix get transformMatrix => _transformMatrix;

  Position get position => new Position(x: _x0 + transformMatrix.translateX,
    y: _y0 + transformMatrix.translateY);

  void set absolutePosition(Position pos) {
    var position = new Position();
    var posParent;
    var parent = _parent;
    while (parent != null && parent is! Layer) {
      posParent = (parent as Node).position;
      position.x += posParent.x;
      position.y += posParent.y;
      parent = parent.parent;
    }
    this.x = pos.x - position.x;
    this.y = pos.y - position.y;
  }

  Position get absolutePosition {
    var pos = position;
    var posParent;
    var parent = _parent;
    while (parent != null && parent is! Layer) {
      posParent = (parent as Node).position;
      pos += posParent;
      parent = parent.parent;
    }
    return pos;
  }

  SvgNode get reflection => _reflection;

  String get svgString {
    if (_impl != null && _impl.type == CanvasType.svg) {
      return (_impl as SvgNode).element.toString();
    }

    var dummyLayer = new Layer(CanvasType.svg, {});
    var copy = this.clone();
    dummyLayer.addChild(copy);
    return (copy.impl as SvgNode).element.toString();
  }

  String get dataUrl {
    throw 'not implemented';
  }
}

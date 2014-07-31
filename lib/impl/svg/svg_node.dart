part of smartcanvas.svg;

bool _isMobile = isMobile();

abstract class SvgNode extends NodeImpl {
  SVG.SvgElement _element;
  SVG.Matrix _elMatrix = new SVG.SvgSvgElement().createSvgMatrix();

  bool _dragstarting = false;
  bool _dragging = false;
  bool _dragStarted = false;
  num _dragOffsetX;
  num _dragOffsetY;

  Set<String> _classNames = new Set<String>();
  Set<String> _registeredDOMEvents = new Set<String>();
  var _dragMoveHandler;
  var _dragEndHandler;

  SvgNode(Node shell) : super(shell) {
    _setClassName();
    _element = _createElement();
    _element.dataset['scNode'] = '${shell.uid}';
    _setElementAttributes();
    _setElementStyles();
    translate();

    if (getAttribute(DRAGGABLE) == true) {
      _startDragHandling();
    }

    if(shell.listening) {
      this.eventListeners.forEach((k, v) {
        _registerDOMEvent(k, v);
      });
    }

    this.shell
    .on('draggableChanged', (oldValue, newValue) {
      if (newValue) {
        _startDragHandling();
      } else {
        _stopDragHandling();
      }
    })
    .on(ATTR_CHANGED, _handleAttrChange)
    .on('translateXChanged', (oldValue, newValue) { translate(); })
    .on('translateYChanged', (oldValue, newValue) { translate(); });
  }

  String get type => svg;

  SVG.SvgElement get element => _element;

  SVG.SvgElement _createElement();

  void _setClassName() {
    _classNames.add(_nodeName);
    if (hasAttribute(CLASS)) {
      _classNames.addAll(getAttribute(CLASS).split(SPACE));
    }
    setAttribute(CLASS, _classNames.join(SPACE));
  }

  void _startDragHandling() {
    _element.onMouseDown.listen(dragStart).resume();
  }

  void _stopDragHandling() {
    _element.onMouseDown.listen(dragStart).cancel();
    _dragEnd();
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([ID, CLASS]);
  }

  List<String> _getStyleNames() {
    return [STROKE, STROKE_WIDTH, STROKE_OPACITY,
            STROKE_LINECAP, STROKE_DASHARRAY,
            FILL, OPACITY, DISPLAY];
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        _element.attributes[attr] = '$value';
      }
    }
  }

  void _setElementStyles() {
    _getStyleNames().forEach((name) {
      _setElementStyle(name);
    });
  }

  void _setElementStyle(String name) {
    var value = getAttribute(name);
    if (value != null) {
      if (value is SCPattern ||
          value is Gradient) {
        _element.style.setProperty(name, 'url(#${value.id})');
        return;
      }
      _element.style.setProperty(name, '${value}');
    } else {
      _element.style.removeProperty(name);
    }
  }

  void remove() {
    _element.remove();
    _defs.forEach((def) {
      if (layer != null) {
        (layer as SvgLayer).removeDef(def);
      }
    });
    if (parent != null) {
      (parent as Container).children.remove(this);
    }
    parent = null;
  }

  void _registerDOMEvent(String event, EventHandlers handler) {
    Function eventHandler = fireEvent(handler);
    switch (event) {
      case MOUSEDOWN:
        _registeredDOMEvents.add(MOUSEDOWN);
        _element.onMouseDown.listen(eventHandler);
        break;
      case MOUSEUP:
        _registeredDOMEvents.add(MOUSEUP);
        _element.onMouseUp.listen(eventHandler);
        break;
      case MOUSEENTER:
        _registeredDOMEvents.add(MOUSEENTER);
        _element.onMouseEnter.listen(eventHandler);
        break;
      case MOUSELEAVE:
        _registeredDOMEvents.add(MOUSELEAVE);
        _element.onMouseLeave.listen(eventHandler);
        break;
      case MOUSEOVER:
        _registeredDOMEvents.add(MOUSEOVER);
        _element.onMouseOver.listen(eventHandler);
        break;
      case MOUSEOUT:
        _registeredDOMEvents.add(MOUSEOUT);
        _element.onMouseOut.listen(eventHandler);
        break;
      case MOUSEMOVE:
        _registeredDOMEvents.add(MOUSEMOVE);
        _element.onMouseMove.listen(_onMouseMove);
        break;
      case CLICK:
        _registeredDOMEvents.add(CLICK);
        _element.onClick.listen(eventHandler);
        break;
      case DBLCLICK:
        _registeredDOMEvents.add(DBLCLICK);
        _element.onDoubleClick.listen(eventHandler);
        break;
      default:
        _registeredDOMEvents.add(event);
        _element.on[event].listen(eventHandler);
     }
  }

  Function fireEvent(EventHandlers handlers) {
    return (e) => handlers(e);
  }

  void dragStart(DOM.MouseEvent e) {
    if (e.button != 0 ||
        (DOM.window.navigator.userAgent.contains('Mac OS') && e.ctrlKey) || // simulated right click on Mac
        stage.dragging ||
        _dragstarting) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();
    this._dragstarting = true;

    var pointerPosition = this.stage.pointerPosition;
    var m = (_element as SVG.GraphicsElement).getCtm();

    this._dragOffsetX = pointerPosition.x - m.e / m.a + stage.translateX; //* stage.scaleX;
    this._dragOffsetY = pointerPosition.y - m.f / m.d + stage.translateY; // * stage.scaleY;

    if (_dragMoveHandler == null) {
      if (_isMobile) {
        _dragMoveHandler = this.stage.element.onTouchMove.listen(_dragMove);
      } else {
        _dragMoveHandler = this.stage.element.onMouseMove.listen(_dragMove);
      }
    }
    _dragMoveHandler.resume();

    if (_dragEndHandler == null) {
      if (_isMobile) {
        _dragEndHandler = this.stage.element.onTouchEnd.listen(_dragEnd);
      } else {
        _dragEndHandler = this.stage.element.onMouseUp.listen(_dragEnd);
      }
    }
    _dragEndHandler.resume();
  }

  void _dragMove(e) {
    if (_dragstarting) {
      e.preventDefault();
      e.stopPropagation();

      if (!_dragStarted) {
        this._dragging = true;
        fire('dragstart', e);
        _dragStarted = true;
      }
      var pointerPosition = this.stage.pointerPosition;
      var m = (_element as SVG.GraphicsElement).getCtm();

      shell.translateX = (pointerPosition.x - this._dragOffsetX);
      shell.translateY = (pointerPosition.y - this._dragOffsetY);

      fire(DRAGMOVE, e);
    }
  }

  void _dragEnd([e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }

    _dragstarting = false;
    _dragging = false;

    if (_dragStarted) {
      fire(DRAGEND, e);
    }
    _dragStarted = false;

//    if (stage != null) {
      if (_dragMoveHandler != null) {
        _dragMoveHandler.pause();
      }

      if (_dragEndHandler != null) {
        _dragEndHandler.pause();
      }
//    }
  }

  void _onMouseMove(DOM.MouseEvent e) {
    if (!_dragging) {
      fire(MOUSEMOVE, e);
    }
  }

  NodeBase on(String event, Function handler, [String id]) {
    super.on(event, handler, id);
    if (!_registeredDOMEvents.contains(event)) {
      _registerDOMEvent(event, eventListeners[event]);
    }
    return this;
  }

  void _handleAttrChange(String attr, oldValue, newValue) {
    if (_isStyle(attr)) {
      _updateDef(attr, oldValue, remove: true);
      _updateDef(attr, newValue);
      _setElementStyle(attr);
    } else if (attr == CLASS) {
      _setClassName();
    } else {
      // apply attribute change to svg element
      var elementAttr = _mapToElementAttr(attr);
      if (elementAttr != null) {
        _setElementAttribute(elementAttr);
      }
    }
  }

  void _updateDef(String attr, value, {bool remove: false}) {
    if (value is SCPattern ||
        value is Gradient) {
      if (layer != null && remove) {
        (layer as SvgLayer).removeDef(value);
        _element.style.removeProperty(attr);
      } else if (layer != null) {
        var defImpl = value.createImpl(svg);
        (layer as SvgLayer).addDef(value, defImpl);
      }
    }
  }

  bool _isStyle(String attr) {
    return _getStyleNames().contains(attr);
  }

  String _mapToElementAttr(String attr) {
    if (_getElementAttributeNames().contains(attr)) {
      return attr;
    }
    return null;
  }

  void scale() {
    _elMatrix.a = shell.scaleX;
    _elMatrix.d = shell.scaleY;
    _setTransform();
  }

  void translate() {
    _elMatrix.e = shell.translateX;
    _elMatrix.f = shell.translateY;
    _setTransform();
  }

  void _setTransform() {
    try {
      if (_element is SVG.GraphicsElement) {
        SVG.GraphicsElement el = _element as SVG.GraphicsElement;
        SVG.Transform tr = el.transform.baseVal.createSvgTransformFromMatrix(_elMatrix);
        if (el.transform.baseVal.length == 0) {
          el.transform.baseVal.appendItem(tr);
        } else {
          el.transform.baseVal.replaceItem(tr, 0);
        }
//      print('translate: ${_elMatrix.e}, ${_elMatrix.f}');
//      print('shell: ${shell.x}, ${shell.y}');
//      print('shell abs: ${shell.absolutePosition.x}, ${shell.absolutePosition.y}');
      }
    } catch(e) {}
  }

  String get _nodeName;

  bool get isDragging => _dragging;

  List get _defs {
    List defs = [];
    if (fill is SCPattern ||
        fill is Gradient) {
        defs.add(fill);
    }

    if (stroke is SCPattern) {
      defs.add(stroke);
    }
    return defs;
  }
}
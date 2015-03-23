part of smartcanvas.svg;

bool _isMobile = isMobile();

abstract class SvgNode extends NodeImpl {
  SVG.SvgElement _element;

  bool _dragstarting = false;
  bool _dragging = false;
  bool _dragStarted = false;
  num _dragOffsetX;
  num _dragOffsetY;

  Set<String> _classNames = new Set<String>();
  Set<String> _registeredDOMEvents = new Set<String>();
  var _dragMoveHandler;
  var _dragEndHandler;
  bool _isReflection;
  Timer _locationCheckTimer;
  String _oldLocation;

  SvgNode(Node shell, this._isReflection) : super(shell) {
    _setClassName();
    _element = _createElement();
    _element.dataset['scNode'] = '${shell.uid}';
    _setElementAttributes();
    _setElementStyles();

    transform();

    if (shell.listening) {
      shell.eventListeners.forEach((k, v) {
        _registerEvent(k, v);
      });
    }

    // only handle dragging on a reflection node
    if (_isReflection) {
      if (getAttribute(DRAGGABLE) == true) {
        _startDragHandling();
      }

      this.shell.on('draggableChanged', (newValue) {
        if (newValue) {
          _startDragHandling();
        } else {
          _stopDragHandling();
        }
      });
    }

    this.shell
      ..on('translateXChanged', transform)
      ..on('translateYChanged', transform)
      ..on('scaleXChanged', transform)
      ..on('scaleYChanged', transform)
      ..on('rotationChanged', transform)
      ..on(ATTR_CHANGED, _handleAttrChange);
  }

  String get type => svg;

  SVG.SvgElement get element => _element;

  SVG.SvgElement _createElement();

  void _setClassName() {
    _classNames.add(_nodeName);
    if (shell.hasAttribute(CLASS)) {
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
    return [
      STROKE,
      STROKE_WIDTH,
      STROKE_OPACITY,
      STROKE_LINECAP,
      STROKE_DASHARRAY,
      FILL,
      FILL_OPACITY,
      OPACITY,
      DISPLAY
    ];
  }

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    attrs.forEach(_setElementAttribute);
  }

  void _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        element.attributes[attr] = '$value';
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
      if (value is SCPattern || value is Gradient) {
        if (_isReflection) {
          _element.style.setProperty(name, 'trasparent');
        } else {
          var baseTag = DOM.document.querySelector('base');
          if (baseTag == null) {
            _element.style.setProperty(name, 'url(#${value.id})');

            // On FireFox there is some strageness, the fill parrtern or gradient
            // is not always take effect. This is hack to force FireFox repaint the
            // the block so that pattern and gradient can show up.
            if (DOM.window.navigator.userAgent
                .toLowerCase()
                .contains('firefox')) {
              value.on(DEF_ADDED, () {
                _element.style.setProperty(name, 'transparent');
                new Future.delayed(new Duration(seconds: 0), () {
                  _element.style.setProperty(name, 'url(#${value.id})');
                });
              });
            }

            if (_locationCheckTimer != null) {
              _locationCheckTimer.cancel();
              _locationCheckTimer = null;
            }
          } else {
            void _setFillUrl(Timer t) {
              String newLocation = DOM.window.location.toString();
              if (newLocation == _oldLocation) {
                return;
              }

              _oldLocation = newLocation;

              if (newLocation.contains('#')) {
                newLocation =
                    newLocation.substring(0, newLocation.indexOf('#'));
              }

              _element.style.setProperty(
                  name, 'url(${newLocation}#${value.id})');

              // On FireFox there is some strageness, the fill parrtern or gradient
              // is not always take effect. This is hack to force FireFox repaint the
              // the block so that pattern and gradient can show up.
              if (DOM.window.navigator.userAgent
                  .toLowerCase()
                  .contains('firefox')) {
                value.on(DEF_ADDED, () {
                  _element.style.setProperty(name, 'transparent');
                  new Future.delayed(new Duration(seconds: 0), () {
                    _element.style.setProperty(
                        name, 'url(${newLocation}#${value.id})');
                  });
                });
              }
            }
            ;

            _setFillUrl(null);

            if (_locationCheckTimer == null) {
              _locationCheckTimer = new Timer.periodic(
                  new Duration(milliseconds: 100), _setFillUrl);
            }
          }
        }
        return;
      }
      _element.style.setProperty(name, '${value}');
    } else {
      _element.style.removeProperty(name);
    }
  }

  void remove() {
    if (_locationCheckTimer != null) {
      _locationCheckTimer.cancel();
    }

    _element.remove();
    _defs.forEach((def) {
      if (stage != null) {
        SvgDefLayer.impl(stage).removeDef(def);
      }
    });
    if (parent != null) {
      (parent as Container).children.remove(this);
    }
    parent = null;
  }

  void _registerEvent(String event, EventHandlers handler) {
    if (isDomEvent(event)) {
      if (_isReflection && !_registeredDOMEvents.contains(event)) {
        Function eventHandler = fireEvent(handler);
        _registeredDOMEvents.add(event);
        switch (event) {
          case MOUSEDOWN:
            _element.onMouseDown.listen(eventHandler);
            break;
          case MOUSEUP:
            _element.onMouseUp.listen(eventHandler);
            break;
          case MOUSEENTER:
            _element.onMouseEnter.listen(eventHandler);
            break;
          case MOUSELEAVE:
            _element.onMouseLeave.listen(eventHandler);
            break;
          case MOUSEOVER:
            _element.onMouseOver.listen(eventHandler);
            break;
          case MOUSEOUT:
            _element.onMouseOut.listen(eventHandler);
            break;
          case MOUSEMOVE:
            _element.onMouseMove.listen(_onMouseMove);
            break;
          case CLICK:
            _element.onClick.listen(eventHandler);
            break;
          case DBLCLICK:
            _element.onDoubleClick.listen(eventHandler);
            break;
        }
      }
    } else {
      Function eventHandler = fireEvent(handler);
      _element.on[event].listen(eventHandler);
    }
  }

  Function fireEvent(EventHandlers handlers) {
    return (e) => handlers(e);
  }

  void dragStart(DOM.MouseEvent e) {
    if (e.button != 0 ||
        (DOM.window.navigator.userAgent.contains('Mac OS') &&
            e.ctrlKey) || // simulated right click on Mac
        stage.dragging || _dragstarting) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();
    this._dragstarting = true;

    var pointerPosition = this.stage.pointerPosition;
    this._dragOffsetX = pointerPosition.x - shell.translateX / shell.scaleX;
    this._dragOffsetY = pointerPosition.y - shell.translateY / shell.scaleY;

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
        shell.fire('dragstart', e);
        _dragStarted = true;
      }
      var pointerPosition = this.stage.pointerPosition;
      shell.translateX = (pointerPosition.x - this._dragOffsetX);
      shell.translateY = (pointerPosition.y - this._dragOffsetY);

      shell.fire(DRAGMOVE, e);
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
      shell.fire(DRAGEND, e);
    }
    _dragStarted = false;

    if (_dragMoveHandler != null) {
      _dragMoveHandler.cancel();
      _dragMoveHandler = null;
    }

    if (_dragEndHandler != null) {
      _dragEndHandler.cancel();
      _dragEndHandler = null;
    }
  }

  void _onMouseMove(DOM.MouseEvent e) {
    if (!_dragging) {
      shell.fire(MOUSEMOVE, e);
    }
  }

  void on(String event, Function handler, [String id]) {
    if (!_registeredDOMEvents.contains(event)) {
      _registerEvent(event, shell.eventListeners[event]);
    }
  }

  void _handleAttrChange(String attr, newValue, oldValue) {
    if (_isStyle(attr)) {
      // only handle def changes on non-reflection node
      if (stage != null && !_isReflection) {
        _updateDef(attr, oldValue, remove: true);
        _updateDef(attr, newValue);
      }
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
    if (value is SCPattern || value is Gradient) {
      if (remove) {
        SvgDefLayer.impl(stage).removeDef(value);
        _element.style.removeProperty(attr);
      } else if (layer != null) {
        SvgDefLayer.impl(stage).addDef(value);
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

  void transform() {
    num r = shell.rotate;
    SVG.Matrix matrix = new SVG.SvgSvgElement().createSvgMatrix();

    if (r != null) {
      var pos = shell.absolutePosition;
      num rx = shell.x + shell.getAttribute(ROTATE_X, 0);
      num ry = shell.y + shell.getAttribute(ROTATE_Y, 0);
      if (rx != 0 || ry != 0) {
        matrix = matrix.translate(rx, ry);
        matrix = matrix.rotate(r);
        matrix = matrix.translate(-rx, -ry);
      } else {
        matrix = matrix.rotate(r);
      }
    }

    matrix = matrix.translate(shell.translateX, shell.translateY);
    matrix = matrix.scaleNonUniform(shell.scaleX, shell.scaleY);
    _setTransform(matrix);
  }

  void _setTransform(SVG.Matrix matrix) {
    try {
      if (_element is SVG.GraphicsElement) {
        SVG.GraphicsElement el = _element as SVG.GraphicsElement;
        SVG.Transform tr =
            el.transform.baseVal.createSvgTransformFromMatrix(matrix);
        if (el.transform.baseVal.numberOfItems == 0) {
          el.transform.baseVal.appendItem(tr);
        } else {
          el.transform.baseVal.replaceItem(tr, 0);
        }
      }
    } catch (e) {
      print('failed to set transform ${e}');
    }
  }

  String get _nodeName;

  bool get isDragging => _dragging;

  List get _defs {
    List defs = [];

    // don't add defs on reflecton layer
    if (_isReflection) {
      return defs;
    }

    if (fill is SCPattern || fill is Gradient) {
      defs.add(fill);
    }

    if (stroke is SCPattern) {
      defs.add(stroke);
    }
    return defs;
  }

  SvgLayer get layer => super.layer;
}

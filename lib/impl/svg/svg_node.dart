part of smartcanvas.svg;

abstract class SvgNode extends NodeImpl {

  static final bool _isMobile = isMobile();

  svg.SvgElement _element;

  bool _dragStarting = false;
  bool _dragging = false;
  bool _dragStarted = false;
  num _dragOffsetX;
  num _dragOffsetY;

  final Set<String> _classNames = new Set<String>();
  final Set<String> _registeredDOMEvents = new Set<String>();

  var _dragMoveHandler;
  var _dragEndHandler;
  bool _isReflection;
  Timer _locationCheckTimer;
  String _oldLocation;
  bool _fillChanged = false;

  SvgNode(Node shell, this._isReflection) : super(shell) {
    _setClassName();
    _element = _createElement();
    _element.dataset['scNode'] = '${shell.uid}';
    _setElementAttributes();
    _setElementStyles();

    transform();

    if (shell.isListening) {
      shell.eventListeners.forEach((k, v) {
        _registerEvent(k, v);
      });
    }

    // only handle dragging on a reflection node
    if (_isReflection) {
      if (getAttribute(DRAGGABLE) == true) {
        _startDragHandling();
      }

      shell.on('draggableChanged', (newValue) {
        if (newValue) {
          _startDragHandling();
        } else {
          _stopDragHandling();
        }
      });
    }

    shell
      ..on('translateXChanged', transform)
      ..on('translateYChanged', transform)
      ..on('scaleXChanged', transform)
      ..on('scaleYChanged', transform)
      ..on('rotationChanged', transform)
      ..on(attrChanged, _handleAttrChange);
  }

  @override
  CanvasType get type => CanvasType.svg;

  svg.SvgElement get element => _element;

  svg.SvgElement _createElement();

  void _setClassName() {
    _classNames.add(_nodeName);
    if (shell.hasAttribute(CLASS)) {
      _classNames.addAll(getAttribute(CLASS).split(space));
    }
    setAttribute(CLASS, _classNames.join(space));
  }

  void _startDragHandling() =>
    _element.onMouseDown.listen(dragStart).resume();

  void _stopDragHandling() {
    _element.onMouseDown.listen(dragStart).cancel();
    _dragEnd();
  }

  Set<String> _getElementAttributeNames() => new Set<String>.from([ID, CLASS]);

  List<String> _getStyleNames() => [
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
          var baseTag = dom.document.querySelector('base');
          if (baseTag == null) {
            _element.style.setProperty(name, 'url(#${value.id})');

            // On FireFox there is some strageness, the fill parrtern or gradient
            // is not always take effect. This is hack to force FireFox repaint the
            // the block so that pattern and gradient can show up.
            if (dom.window.navigator.userAgent
            .toLowerCase().contains('firefox')) {
              value.on(defAdded, () {
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
            _fillChanged = true;

            void _setFillUrl(Timer t) {
              var newLocation = dom.window.location.toString();

              if (newLocation == _oldLocation && _fillChanged == false) {
                return;
              }

              _oldLocation = newLocation;

              if (newLocation.contains('#')) {
                newLocation = newLocation.substring(0, newLocation.indexOf('#'));
              }

              _element.style.setProperty(
                  name, 'url(${newLocation}#${value.id})');

              // On FireFox there is some strageness, the fill parrtern or gradient
              // is not always take effect. This is hack to force FireFox repaint the
              // the block so that pattern and gradient can show up.
              if (dom.window.navigator.userAgent
              .toLowerCase().contains('firefox')) {
                value.on(defAdded, () {
                  _element.style.setProperty(name, 'transparent');
                  new Future.delayed(new Duration(seconds: 0), () {
                    _element.style.setProperty(
                        name, 'url(${newLocation}#${value.id})');
                  });
                });
              }
            }

            _setFillUrl(null);

            _fillChanged = false;

            // set a timer to detect location change
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

  @override
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

  void _registerEvent(String event, EventHandlers handlers) {
    if (isDomEvent(event)) {
      if (_isReflection && !_registeredDOMEvents.contains(event)) {
        _registeredDOMEvents.add(event);
        switch (event) {
          case mouseDown:
            _element.onMouseDown.listen((e) => handlers(e));
            break;
          case mouseUp:
            _element.onMouseUp.listen((e) => handlers(e));
            break;
          case mouseEnter:
            _element.onMouseEnter.listen((e) => handlers(e));
            break;
          case mouseLeave:
            _element.onMouseLeave.listen((e) => handlers(e));
            break;
          case mouseOver:
            _element.onMouseOver.listen((e) => handlers(e));
            break;
          case mouseOut:
            _element.onMouseOut.listen((e) => handlers(e));
            break;
          case mouseMove:
            _element.onMouseMove.listen(_onMouseMove);
            break;
          case click:
            _element.onClick.listen((e) => handlers(e));
            break;
          case dblClick:
            _element.onDoubleClick.listen((e) => handlers(e));
            break;
        }
      }
    } else {
      _element.on[event].listen((e) => handlers(e));
    }
  }

  void dragStart(dom.MouseEvent e) {
    if (e.button != 0 ||
    (dom.window.navigator.userAgent.contains('Mac OS') &&
    e.ctrlKey) || // simulated right click on Mac
    stage.isDragging || _dragStarting) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();
    _dragStarting = true;

    var pointerPosition = this.stage.pointerPosition;
    _dragOffsetX = pointerPosition.x - shell.translateX / shell.scaleX;
    _dragOffsetY = pointerPosition.y - shell.translateY / shell.scaleY;

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
    if (_dragStarting) {
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

      shell.fire(dragMove, e);
    }
  }

  void _dragEnd([e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }

    _dragStarting = false;
    _dragging = false;

    if (_dragStarted) {
      shell.fire(dragEnd, e);
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

  void _onMouseMove(dom.MouseEvent e) {
    if (!_dragging) {
      shell.fire(mouseMove, e);
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

  bool _isStyle(String attr) => _getStyleNames().contains(attr);

  String _mapToElementAttr(String attr) {
    if (_getElementAttributeNames().contains(attr)) {
      return attr;
    }
    return null;
  }

  void transform() {
    var r = shell.rotate;
    var matrix = new svg.SvgSvgElement().createSvgMatrix();

    if (r != null) {
      var rx = shell.x + shell.getAttribute(ROTATE_X, 0);
      var ry = shell.y + shell.getAttribute(ROTATE_Y, 0);
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

  void _setTransform(svg.Matrix matrix) {
    try {
      if (_element is svg.GraphicsElement) {
        var el = _element as svg.GraphicsElement;
        var tr = el.transform.baseVal.createSvgTransformFromMatrix(matrix);
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
    var defs = [];

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
}

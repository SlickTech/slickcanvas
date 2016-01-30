part of smartcanvas.svg;

abstract class SvgNode extends NodeImpl with SvgDraggable {

  svg.GElement _controlGroup;
  svg.SvgElement _implElement;

  final Set<String> _classNames = new Set<String>();
  final Set<String> _registeredDOMEvents = new Set<String>();

  static final List<ControlType> _resizableControlTypes = [
    ControlType.e, ControlType.w, ControlType.n, ControlType.s,
    ControlType.ne, ControlType.nw, ControlType.se, ControlType.sw
  ];

  final List<SvgControlPoint> _controlPoints = [];

  bool _isReflection;
  Timer _locationCheckTimer;
  String _oldLocation;
  bool _fillChanged = false;

  num _controlGroupX0 = 0;
  num _controlGroupY0 = 0;

  SvgNode(Node shell, this._isReflection) : super(shell) {

    _setClassName();

    _implElement = _createElement();

    if (shell.resizable) {
      _createControlGroup();
    } else {
      _implElement.dataset['scNode'] = '${shell.uid}';
    }

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

      if (this is! SvgContainerNode) {
        _implElement.style.setProperty(OPACITY, '0');
      }

      initDraggable(shell, _controlGroup != null ? _controlGroup : _implElement);

      if (getAttribute(DRAGGABLE) == true) {
        enableDragging();
      }

      shell
       ..on('reflection_complete', _onReflectionComplete)
       ..on('draggableChanged', (newValue) {
        if (newValue) {
           enableDragging();
        } else {
           disableDragging();
        }
      });
    }

    shell
      ..on([
        translateXChanged,
        translateYChanged,
        translateChanged,
        'offsetXChanged',
        'offsetYChanged',
        'rotationChanged'
      ], transform)
      ..on([
        scaleXChanged,
        scaleYChanged,
        scaleChanged,
        resize,
      ], _handleScaleChange)
      ..on(attrChanged, _handleAttrChange)
    ;
  }

  void _createControlGroup() {
    _controlGroup = new svg.GElement();
    _controlGroup.dataset['scNode'] = '${shell.uid}';

    _controlGroup.append(_implElement);

    if (_isReflection) {
      var types = getAttribute(CONTROLS);
      var controlTypes = [];
      if (types != null && types is List<String>) {
        for (String type in types) {
          switch(type) {
            case 'n':
              controlTypes.add(ControlType.n);
              break;
            case 's':
              controlTypes.add(ControlType.s);
              break;
            case 'w':
              controlTypes.add(ControlType.w);
              break;
            case 'e':
              controlTypes.add(ControlType.e);
              break;
            case 'nw':
              controlTypes.add(ControlType.nw);
              break;
            case 'ne':
              controlTypes.add(ControlType.ne);
              break;
            case 'sw':
              controlTypes.add(ControlType.sw);
              break;
            case 'se':
              controlTypes.add(ControlType.se);
              break;
          }
        }
      } else {
        controlTypes = _resizableControlTypes;
      }

      for(ControlType type in controlTypes) {
        SvgControlPoint.factory(_controlGroup, shell, type, this);
      }

      if (shell.getAttribute(SHOW_CONTROLS_ON_CLICK, false)) {
        _controlGroup.onMouseDown.listen(showControlPoints);
      }
    }
  }

  void _onReflectionComplete() {
    for (var controlPoint in _controlPoints) {
      controlPoint.updatePosition();
    }

    if (this is SvgGroup) {
      for (var child in children) {
        child._onReflectionComplete();
      }
    }
  }

  @override
  CanvasType get type => CanvasType.svg;

  svg.SvgElement get element => _controlGroup != null ? _controlGroup : _implElement;

  svg.SvgElement _createElement();

  void _setClassName() {
    _classNames.add(_nodeName);
    if (shell.hasAttribute(CLASS)) {
      _classNames.addAll(getAttribute(CLASS).split(space));
    }
    setAttribute(CLASS, _classNames.join(space));
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
    DISPLAY,
    CURSOR
  ];

  void _setElementAttributes() {
    var attrs = _getElementAttributeNames();
    bool needToTransform = false;
    attrs.forEach((String attr) {
      var b = _setElementAttribute(attr);
      if (needToTransform == false && b) {
        needToTransform = true;
      }
    });

    if (needToTransform) {
      transform();
    }
  }

  bool _setElementAttribute(String attr) {
    var value = getAttribute(attr);
    var needToTransform = false;
    if (value != null) {
      if (!(value is String) || !value.isEmpty) {
        if (_controlGroup != null) {
          if (_isPositionAttr(attr)) {
            if (value != null) {
              if (attr == X) {
                _controlGroupX0 = value;
                needToTransform = true;
              } else if (attr == Y) {
                _controlGroupY0 = value;
                needToTransform = true;
              }
            }
          } else if (_isSizeAttr(attr)) {
            _controlGroup.attributes[attr] = '$value';
            _implElement.attributes[attr] = '$value';
          } else {
            _implElement.attributes[attr] = '$value';
          }
        } else {
          _implElement.attributes[attr] = '$value';
        }
      }
    }
    return needToTransform;
  }

  bool _isPositionAttr(String attr) => attr == X || attr == Y;
  bool _isSizeAttr(String attr) => attr == WIDTH || attr == HEIGHT;

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
          _implElement.style.setProperty(name, 'trasparent');
        } else {
          var baseTag = dom.document.querySelector('base');
          if (baseTag == null) {
            _implElement.style.setProperty(name, 'url(#${value.id})');

            // On FireFox there is some strageness, the fill parrtern or gradient
            // is not always take effect. This is hack to force FireFox repaint the
            // the block so that pattern and gradient can show up.
            if (dom.window.navigator.userAgent
            .toLowerCase().contains('firefox')) {
              value.on(defAdded, () {
                _implElement.style.setProperty(name, 'transparent');
                new Future.delayed(new Duration(seconds: 0), () {
                  _implElement.style.setProperty(name, 'url(#${value.id})');
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

              _implElement.style.setProperty(
                  name, 'url(${newLocation}#${value.id})');

              // On FireFox there is some strageness, the fill pattern or gradient
              // is not always take effect. This is hack to force FireFox repaint the
              // the block so that pattern and gradient can show up.
              if (dom.window.navigator.userAgent.toLowerCase().contains('firefox')) {
                value.on(defAdded, () {
                  _implElement.style.setProperty(name, 'transparent');
                  new Future.delayed(new Duration(seconds: 0), () {
                    _implElement.style.setProperty(
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

      if (name == STROKE_WIDTH) {
        value /= max(shell.actualScaleX, shell.actualScaleY);
      }
      _implElement.style.setProperty(name, '${value}');
    } else {
      _implElement.style.removeProperty(name);
    }

    if (name == FILL && _locationCheckTimer != null) {
      // Fill no longer a pattern or gradient, stop location check timer
      _locationCheckTimer.cancel();
      _locationCheckTimer = null;
    }
  }

  @override
  void remove() {
    if (_locationCheckTimer != null) {
      _locationCheckTimer.cancel();
    }

    element.remove();
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
            element.onMouseDown.listen((e) => handlers(e));
            break;
          case mouseUp:
            element.onMouseUp.listen((e) => handlers(e));
            break;
          case mouseEnter:
            element.onMouseEnter.listen((e) => handlers(e));
            break;
          case mouseLeave:
            element.onMouseLeave.listen((e) => handlers(e));
            break;
          case mouseOver:
            element.onMouseOver.listen((e) => handlers(e));
            break;
          case mouseOut:
            element.onMouseOut.listen((e) => handlers(e));
            break;
          case mouseMove:
            element.onMouseMove.listen(_onMouseMove);
            break;
          case click:
            element.onClick.listen((e) => handlers(e));
            break;
          case dblClick:
            element.onDoubleClick.listen((e) => handlers(e));
            break;
        }
      }
    } else {
      element.on[event].listen((e) => handlers(e));
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
        if (_setElementAttribute(elementAttr)) {
          transform();
        }
      }
    }
  }

  void _updateDef(String attr, value, {bool remove: false}) {
    if (value is SCPattern || value is Gradient) {
      if (remove) {
        SvgDefLayer.impl(stage).removeDef(value);
        _implElement.style.removeProperty(attr);
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

  void _handleScaleChange() {
    // do not scale strokeWidth
    var strokeWidth = shell.strokeWidth / max(shell.actualScaleX, shell.actualScaleY);
    _implElement.style.setProperty(STROKE_WIDTH, strokeWidth.toString());
    transform();
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

    matrix = matrix.translate(
      _controlGroupX0 + shell.translateX,
      _controlGroupY0 + shell.translateY
    );

    matrix = _scale(matrix);
    if (element is svg.GraphicsElement) {
      _setTransform(element, matrix);
    }
  }

  void _setTransform(svg.GraphicsElement el, svg.Matrix matrix) {
    try {
      var tr = el.transform.baseVal.createSvgTransformFromMatrix(matrix);
      if (el.transform.baseVal.numberOfItems == 0) {
        el.transform.baseVal.appendItem(tr);
      } else {
        el.transform.baseVal.replaceItem(tr, 0);
      }
    } catch (e) {
      print('failed to set transform ${e}');
    }
  }

  svg.Matrix _scale(svg.Matrix matrix) {
    var sx = shell.scaleX * shell.getAttribute(RESIZE_SCALE_X, 1);
    var sy = shell.scaleY * shell.getAttribute(RESIZE_SCALE_Y, 1);

    // only scale node, not the control group
    if (_controlGroup != null) {
      svg.Matrix mtrx = new svg.SvgSvgElement().createSvgMatrix();
      mtrx = mtrx.scaleNonUniform(sx, sy);
      _setTransform(_implElement, mtrx);
    } else {
      // scale at note origin
      var cx = shell.x- translateX;
      var cy = shell.y - translateY;
      matrix = matrix.translate(-cx * (sx - 1), -cy * (sy - 1));

      matrix = matrix.scaleNonUniform(sx, sy);
    }
    return matrix;
  }

  void showControlPoints([dom.MouseEvent e]) {
    _controlGroup.children.forEach((svg.SvgElement el) {
      if (el.classes.contains(SvgControlPoint.csClassName)) {
        el.attributes.remove(DISPLAY);
      }
    });

    if (shell.getAttribute(SHOW_CONTROLS_ON_CLICK, false)) {
      this.layer.element.onMouseDown.listen(hideControlPoints);
    }
  }

  void hideControlPoints([dom.MouseEvent e]) {
    if (e != null && e.path.contains(_controlGroup)) {
      return;
    }

    _controlGroup.children.forEach((svg.SvgElement el) {
      if (el.classes.contains(SvgControlPoint.csClassName)) {
        el.setAttribute(DISPLAY, 'none');
      }
    });

    this.layer.element.onMouseDown.listen(hideControlPoints).cancel();
  }

  String get _nodeName;

  bool get isDragging => _dragging;

  List get _defs {
    var defs = [];

    // don't add defs on reflection layer
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

  bool get hasControls => _controlGroup != null && _controlGroup.children.length > 1;

  @override
  BBox getBBox(bool isAbsolute) {
    var bbx = hasControls ? _implElement.getBBox() : element.getBBox();

    if (isAbsolute) {
      var absPos = shell.absolutePosition;
      return new BBox(x: absPos.x, y: absPos.y, width: bbx.width, height: bbx.height);
    } else {
      return hasControls
        ? new BBox(x: shell.x, y: shell.y, width: bbx.width, height: bbx.height)
        : bbox;
    }
  }

  @override
  LayerImpl get layer => _isReflection ? stage.children.last.impl : shell.layer.impl;
}

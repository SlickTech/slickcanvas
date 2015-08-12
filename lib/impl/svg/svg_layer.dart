part of smartcanvas.svg;

class SvgLayer extends SvgContainerNode implements LayerImpl {

  num _suspendRefCount = 0;

  SvgLayer(Layer shell, bool isReflection) : super(shell, isReflection) {
    shell
      ..on('widthChanged', _onWidthChanged)
      ..on('heightChanged', _onHeightChanged)
      ..on('opacityChanged', _onOpacityChanged)
      ..on('stageSet', _onStageSet);
  }

  @override
  svg.SvgElement _createElement() => new svg.SvgSvgElement();

  @override
  Set<String> _getElementAttributeNames() =>
    new Set<String>.from([ID, CLASS, WIDTH, HEIGHT, VIEWBOX]);

  @override
  List<String> _getStyleNames() => [BACKGROUND, OPACITY, DISPLAY];

  @override
  bool _setElementAttribute(String attr) {
    if (attr == 'viewBox') {
      _setViewBox();
      _implElement.setAttribute('preserveAspectRatio', 'none');
      return false;
    }
    return super._setElementAttribute(attr);
  }

  void _setViewBox() {
    var w = getAttribute(WIDTH, 0) / this.getAttribute(SCALE_X, 1);
    var h = getAttribute(HEIGHT, 0) / this.getAttribute(SCALE_Y, 1);
    _implElement.setAttribute('viewBox', '0 0 $w $h');
  }

  @override
  void _setElementStyles() {
    super._setElementStyles();
    _implElement.style
      ..position = ABSOLUTE
      ..top = ZERO
      ..left = ZERO
      ..margin = ZERO
      ..padding = ZERO;
  }

  @override
  void resume() {
    if (_suspendRefCount > 0) {
      if (--_suspendRefCount == 0) {
        var idx = this.shell.stage.children.indexOf(this.shell);
        this.shell.stage.element.nodes[idx].replaceWith(this._implElement);

        this._defs.forEach((def) {
          SvgDefLayer.impl(stage).resumeDef(def);
        });
      }
    }
  }

  @override
  void suspend() {
    if (this._implElement.parent != null) {
      if (_suspendRefCount == 0) {
        svg.SvgElement dummy = this._implElement.clone(true);
        dummy.classes.add('dummy');
        this._implElement.replaceWith(dummy);

        this._defs.forEach((def) {
          SvgDefLayer.impl(stage).suspendDef(def);
        });
      }
      ++_suspendRefCount;
    }
  }

  @override
  void remove() {
    var sUid = shell.uid.toString();
    shell.stage
      ..off(scaleXChanged, sUid)
      ..off(scaleYChanged, sUid)
      ..off(scaleChanged, sUid)
      ..off(translateXChanged, sUid)
      ..off(translateYChanged, sUid)
      ..off(translateChanged, sUid);

    if (!_isReflection) {
      children.forEach((child) {
        child._defs.forEach((def) {
          SvgDefLayer.impl(stage).removeDef(def);
        });
      });
    }

    super.remove();
  }

  void _onStageSet() {
    _translateViewBoxX(shell.stage.translateX);
    _translateViewBoxY(shell.stage.translateY);
    _scaleViewBoxWidth(shell.stage.scaleX);
    _scaleViewBoxHeight(shell.stage.scaleY);

    var sUid = shell.uid.toString();
    shell.stage
      ..on(scaleXChanged, _scaleViewBoxWidth, sUid)
      ..on(scaleYChanged, _scaleViewBoxHeight, sUid)
      ..on(scaleChanged, _onScaleChanged, sUid)
      ..on(translateXChanged, _onTranslateXChanged, sUid)
      ..on(translateYChanged, _onTranslateYChanged, sUid)
      ..on(translateChanged, _onTranslateChanged, sUid);

    if (!_isReflection) {
      children.forEach((child) {
        _addDefs(child);
      });
    }
  }

  void _onWidthChanged(newValue) {
    _implElement.setAttribute(WIDTH, '$newValue');
    (_implElement as svg.SvgSvgElement).viewBox.baseVal
      ..width = newValue / (getAttribute(SCALE_X, 1) * shell.stage.scaleX);
  }

  void _onHeightChanged(newValue) {
    _implElement.setAttribute(HEIGHT, '$newValue');
    (_implElement as svg.SvgSvgElement).viewBox.baseVal
      ..height = newValue / (getAttribute(SCALE_Y, 1) * shell.stage.scaleY);
  }

  void _onOpacityChanged(num newValue) {
    _implElement.style.opacity = '$newValue';
  }

  void _onScaleChanged(num scaleX, num scaleY) {
    _scaleViewBoxWidth(scaleX);
    _scaleViewBoxHeight(scaleY);
  }

  void _scaleViewBoxWidth(num scaleX) {
    if (scaleX == 0) {
      scaleX = 0.0000001;
    }
    (_implElement as svg.SvgSvgElement).viewBox.baseVal.width =
      getAttribute(WIDTH, 0) / scaleX;
  }

  void _scaleViewBoxHeight(num scaleY) {
    if (scaleY == 0) {
      scaleY = 0.0000001;
    }
    (_implElement as svg.SvgSvgElement).viewBox.baseVal.height =
      getAttribute(HEIGHT, 0) / scaleY;
  }

  void _onTranslateChanged(num tx, num ty) {
    _translateViewBoxX(tx);
    _translateViewBoxY(ty);
  }

  void _onTranslateXChanged(num newValue) => _translateViewBoxX(newValue);

  void _onTranslateYChanged(num newValue) => _translateViewBoxY(newValue);

  void _translateViewBoxX(num translateX) {
    (_implElement as svg.SvgSvgElement).viewBox.baseVal.x = -translateX;
  }

  void _translateViewBoxY(num translateY) {
    (_implElement as svg.SvgSvgElement).viewBox.baseVal.y = -translateY;
  }

  static const String _scLayer = '__sc_layer';

  @override
  String get _nodeName => _scLayer;

  Position get position {
    var viewBox = (_implElement as svg.SvgSvgElement).viewBox;
    return new Position(x: -viewBox.baseVal.x, y: -viewBox.baseVal.y);
  }

  Position get absolutePosition => position;
}

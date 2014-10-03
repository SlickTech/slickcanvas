part of smartcanvas.svg;

class SvgLayer extends SvgNode implements LayerImpl {
  List<SvgNode> _children = new List<SvgNode>();

  SvgLayer(Layer shell, bool isReflection): super(shell, isReflection) {
    shell
      .on('widthChanged', _onWidthChanged)
      .on('heightChanged', _onHeightChanged)
      .on('opacityChanged', _onOpacityChanged)
      .on('stageSet', _onStageSet);
  }

  DOM.Element _createElement() {
    return new SVG.SvgSvgElement();
  }

  Set<String> _getElementAttributeNames() {
    return new Set<String>.from([ID, CLASS, WIDTH, HEIGHT, VIEWBOX]);
  }

  List<String> _getStyleNames() {
    return [BACKGROUND, OPACITY, DISPLAY];
  }

  void _setElementAttribute(String attr) {
    if (attr == 'viewBox') {
      _setViewBox();
      _element.setAttribute('preserveAspectRatio', 'none');
    } else {
      super._setElementAttribute(attr);
    }
  }

  void _setViewBox() {
    num w = getAttribute(WIDTH, 0) / this.getAttribute(SCALE_X, 1);
    num h = getAttribute(HEIGHT, 0) / this.getAttribute(SCALE_Y, 1);
    _element.setAttribute('viewBox', '0 0 $w $h');
  }

  void _setElementStyles() {
    super._setElementStyles();
    _element.style
    ..position = ABSOLUTE
    ..top = ZERO
    ..left = ZERO
    ..margin = ZERO
    ..padding = ZERO;
  }

  void addChild(SvgNode child) {
    _children.add(child);
    child.parent = this;
    this._element.append(child._element);

    if (stage != null && !_isReflection) {
      _addDefs(child);
    }
  }

  void _addDefs(SvgNode child) {
    child._defs.forEach((def) {
      SvgDefLayer.impl(this.stage).addDef(def);
    });
  }

  void removeChild(SvgNode node) {
    node.remove();
  }

  void clearChildren() {
    while(_children.isNotEmpty) {
      this.removeChild(_children.first);
    }
  }

  void insertChild(int index, SvgNode node) {
    node.parent = this;
    _children.insert(index, node);
    this._element.nodes.insert(index, node._element);
    _addDefs(node);
  }

  void resume() {
    var idx = this.shell.parent.children.indexOf(this.shell);
    this.shell.stage.element.nodes[idx].replaceWith(this._element);

    this._defs.forEach((def) {
      SvgDefLayer.impl(stage).resumeDef(def);
    });
  }

  void suspend() {
    if (this._element.parent != null) {
      var dummy = this._element.clone(true);
      dummy.classes.add('dummy');
      this._element.replaceWith(dummy);

      this._defs.forEach((def) {
        SvgDefLayer.impl(stage).suspendDef(def);
      });
    }
  }

  void remove() {
    String sUid = uid.toString();
    shell.stage
      .off('scaleXChanged', sUid)
      .off('scaleYChanged', sUid)
      .off('translateXChanged', sUid)
      .off('translateYChanged', sUid);

    if (!_isReflection) {
      children.forEach((child) {
        child._defs.forEach((def){
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

    String sUid = uid.toString();
    shell.stage
      .on('scaleXChanged', _onScaleXChanged, sUid)
      .on('scaleYChanged', _onScaleYChanged, sUid)
      .on('translateXChanged', _onTranslateXChanged, sUid)
      .on('translateYChanged', _onTranslateYChanged, sUid);

    if (!_isReflection) {
      _children.forEach((child) {
        _addDefs(child);
      });
    }
  }

  void _onWidthChanged(newValue) {
    _element.setAttribute(WIDTH, '$newValue');
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..width = newValue / (getAttribute(SCALE_X, 1) * shell.stage.scaleX);
  }

  void _onHeightChanged(newValue) {
    _element.setAttribute(HEIGHT, '$newValue');
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..height = newValue / (getAttribute(SCALE_Y, 1) * shell.stage.scaleY);
  }

  void _onOpacityChanged(num newValue) {
    _element.style.opacity = '$newValue';
  }

  void _onScaleXChanged(num newValue) {
    _scaleViewBoxWidth(newValue);
  }

  void _onScaleYChanged(num newValue) {
    _scaleViewBoxHeight(newValue);
  }

  void _scaleViewBoxWidth(num scaleX) {
    if (scaleX == 0) {
      scaleX = 0.0000001;
    }
    (_element as SVG.SvgSvgElement).viewBox.baseVal.width = getAttribute(WIDTH, 0) / scaleX;
  }

  void _scaleViewBoxHeight(num scaleY) {
    if (scaleY == 0) {
      scaleY = 0.0000001;
    }
    (_element as SVG.SvgSvgElement).viewBox.baseVal.height = getAttribute(HEIGHT, 0) / scaleY;
  }

  void _onTranslateXChanged(newValue) {
    _translateViewBoxX(newValue);
  }

  void _onTranslateYChanged(newValue) {
    _translateViewBoxY(newValue);
  }

  void _translateViewBoxX(num translateX) {
    (_element as SVG.SvgSvgElement).viewBox.baseVal.x = -translateX;
  }

  void _translateViewBoxY(num translateY) {
    (_element as SVG.SvgSvgElement).viewBox.baseVal.y = -translateY;
  }

  List get _defs {
    List defs = [];
    if (fill is SCPattern ||
        fill is Gradient) {
        defs.add(fill);
    }

    if (stroke is SCPattern) {
      defs.add(stroke);
    }

    _children.forEach((child) {
      defs.addAll(child._defs);
    });
    return defs;
  }

  List<SvgNode> get children => _children;

  String get _nodeName => SC_LAYER;

  LayerImpl get layer => this;

  Position get position {
    var viewBox = (_element as SVG.SvgSvgElement).viewBox;
    return new Position(x: -viewBox.baseVal.x, y: -viewBox.baseVal.y);
  }
  Position get absolutePosition => position;
}
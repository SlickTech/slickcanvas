part of smartcanvas.svg;

class SvgLayer extends SvgNode implements LayerImpl {
  List<SvgNode> _children = new List<SvgNode>();
  Map<Node, SvgNode> _defNodes = {};
  SVG.DefsElement _defsEl;

  SvgLayer(shell): super(shell) {
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

  void _setElementAttribute(String attr) {
    if (attr == 'viewBox') {
      _setViewBox();
      _element.setAttribute('preserveAspectRatio', 'none');
    } else {
      super._setElementAttribute(attr);
    }
  }

  void _setViewBox() {
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..x = getAttribute(X, 0)
    ..y = getAttribute(Y, 0)
    ..width = getAttribute(WIDTH, 0) / getAttribute(SCALE_X, 1)
    ..height = getAttribute(HEIGHT, 0) / getAttribute(SCALE_Y, 1);
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

  void addDef(Node defNode, SvgNode defImpl) {
    _defNodes[defNode] = defImpl;
    if (_defNodes.length == 1 && _defsEl == null) {
      _defsEl = new SVG.DefsElement();
      _element.nodes.insert(0, _defsEl);
    }
    _defsEl.append(defImpl.element);
  }

  void removeDef(Node defNode) {
    SvgNode defImpl = _defNodes[defNode];
    if (defImpl != null) {
      defImpl.element.remove();
      _defNodes.remove(defNode);
      if (_defsEl.nodes.isEmpty) {
        _defsEl.remove();
        _defsEl = null;
      }
    }
  }

  void add(SvgNode child) {
    _children.add(child);
    child.parent = this;
    this._element.append(child._element);

    _addDefs(child);
  }

  void _addDefs(SvgNode child) {
      child._defs.forEach((def) {
        SvgNode defImpl = def.createImpl(svg);
        this.addDef(def, defImpl);
      });
  }

  void removeChild(SvgNode node) {
    node.parent = null;
    node.remove();
  }

  void removeChildren() {
    _children.forEach((child) => child.remove());
  }

  void insert(int index, SvgNode node) {
    node.parent = this;
    _children.insert(index, node);
    this._element.nodes.insert(index, node._element);
    _addDefs(node);
  }

  void resume() {}
  void suspend() {}

  void _onStageSet() {
    shell.stage
      .on('scaleXChanged', _onScaleXChanged)
      .on('scaleYChanged', _onScaleYChanged)
      .on('translateXChanged', _onTranslateXChanged)
      .on('translateYChanged', _onTranslateYChanged);
  }

  void _onWidthChanged(oldValue, newValue) {
    _element.setAttribute(WIDTH, '$newValue');
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..width = newValue / getAttribute(SCALE_Y, 1);
  }

  void _onHeightChanged(oldValue, newValue) {
    _element.setAttribute(HEIGHT, '$newValue');
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..height = newValue / getAttribute(SCALE_Y, 1);
  }

  void _onOpacityChanged(num oldValue, num newValue) {
    _element.style.opacity = '$newValue';
  }

  void _onScaleXChanged(num oldValue, num newValue) {
    if (newValue == 0) {
      newValue = 0.0000001;
    }
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..width = getAttribute(WIDTH, 0) / newValue;
  }

  void _onScaleYChanged(num oldValue, num newValue) {
    if (newValue == 0) {
      newValue = 0.0000001;
    }
    (_element as SVG.SvgSvgElement).viewBox.baseVal
    ..height = getAttribute(HEIGHT, 0) / newValue;
  }

  void _onTranslateXChanged(oldValue, newValue) {
    (_element as SVG.SvgSvgElement).viewBox.baseVal.x = -newValue;
  }

  void _onTranslateYChanged(oldValue, newValue) {
    (_element as SVG.SvgSvgElement).viewBox.baseVal.y = -newValue;
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
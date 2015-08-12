part of smartcanvas.svg;

enum ControlType {
  e, w, n, s, ne, nw, se, sw, r
}

abstract class SvgControlPoint extends Object with SvgDraggable {
  final svg.GElement _controlGroup;
  final Node _node;
  final svg.RectElement _element = new svg.RectElement();
  final ControlType _type;

  Position _dragPositionCache;

  static const size = 8;
  static const csClassName = '__svg_control_point';

  static SvgControlPoint factory(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection) {
    switch (type) {
      case ControlType.n:
        return new SvgNControlPoint(controlGroup, node, type, reflection);
      case ControlType.s:
        return new SvgSControlPoint(controlGroup, node, type, reflection);
      case ControlType.w:
        return new SvgWControlPoint(controlGroup, node, type, reflection);
      case ControlType.e:
        return new SvgEControlPoint(controlGroup, node, type, reflection);
      case ControlType.nw:
        return new SvgNWControlPoint(controlGroup, node, type, reflection);
      case ControlType.ne:
        return new SvgNEControlPoint(controlGroup, node, type, reflection);
      case ControlType.sw:
        return new SvgSWControlPoint(controlGroup, node, type, reflection);
      case ControlType.se:
        return new SvgSEControlPoint(controlGroup, node, type, reflection);
      case ControlType.r:
        throw new Exception('not implemented');
    }
  }

  SvgControlPoint(this._controlGroup, this._node, this._type, SvgNode reflection) {

    _element.attributes.addAll({
      WIDTH: '$size',
      HEIGHT: '$size',
      DISPLAY: 'none'
    });

    _element.style.setProperty('fill', 'black');
    _element.classes.add(csClassName);

    _controlGroup.append(_element);
    reflection._controlPoints.add(this);

    _element
      ..onMouseOver.listen(_onMouseOver)
      ..onMouseOut.listen(_onMouseOut)
    ;

    initDraggable(_node, _element);
    enableDragging();

    _node.on([scaleXChanged, scaleYChanged, scaleChanged, resize], updatePosition);
  }

  void  updatePosition() {
    var bbx = nodeBBox;
    var pos = getPosition(bbx);

    var matrix = new svg.SvgSvgElement().createSvgMatrix();
    matrix = matrix.translate(
      pos.x + bbx.x * resizeScaleX,
      pos.y + bbx.y * resizeScaleY
    );

    var tr = _element.transform.baseVal.createSvgTransformFromMatrix(matrix);
    if (_element.transform.baseVal.numberOfItems == 0) {
      _element.transform.baseVal.appendItem(tr);
    } else {
      _element.transform.baseVal.replaceItem(tr, 0);
    }
  }

  void _onMouseOver(dom.MouseEvent e) {
    dom.document.body.style.cursor = cursor;
    e.stopPropagation();
  }

  void _onMouseOut(dom.MouseEvent e) {
    dom.document.body.style.cursor = 'default';
    e.stopPropagation();
  }

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {
    _calculateDragOffset();
    e.preventDefault();
    e.stopImmediatePropagation();
    e.stopPropagation();
    return false;
  }

  num _getNewWidth(num w, num diffX, int factor) {
    var w1 = w + factor * diffX;

    var minW = _node.getAttribute(MIN_WIDTH);
    if (minW != null) {
      w1 = max(minW, w1);
    }

    var maxW  = _node.getAttribute(MAX_WIDTH);
    if (maxW != null) {
      w1 = min(maxW, w1);
    }

    return w1;
  }

  num _getNewHeight(num h, num diffY, int factor) {
    var h1 = h + factor * diffY;

    var minH = _node.getAttribute(MIN_HEIGHT);
    if (minH != null) {
      h1 = max(minH, h1);
    }

    var maxH = _node.getAttribute(MAX_HEIGHT);
    if (maxH != null) {
      h1 = min(maxH, h1);
    }
    return h1;
  }

  num get resizeScaleX => _node.getAttribute(RESIZE_SCALE_X, 1);
  num get resizeScaleY => _node.getAttribute(RESIZE_SCALE_Y, 1);
  int get negativeScaleXAdjustment => resizeScaleX > 0 ? 0 : -size;
  int get negativeScaleYAdjustment => resizeScaleY > 0 ? 0 : -size;

  BBox get nodeBBox {
    var bbox = (_controlGroup.children[0] as svg.GraphicsElement).getBBox();
    return new BBox(
      x: bbox.x,
      y: bbox.y,
      width: bbox.width * _node.scaleX * _node.getAttribute(RESIZE_SCALE_X, 1),
      height: bbox.height * _node.scaleY * _node.getAttribute(RESIZE_SCALE_Y, 1)
    );
  }

  Position getPosition(BBox bbox);

  String get cursor;

}

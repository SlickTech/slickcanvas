part of smartcanvas.svg;

class SvgNEControlPoint extends SvgControlPoint {

  SvgNEControlPoint(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection)
    :super(controlGroup, node, type, reflection);

  @override
  Position getPosition(BBox bbox) {
    return new Position(
      x: bbox.width + negativeScaleXAdjustment,
      y: -SvgControlPoint.size - negativeScaleYAdjustment
    );
  }

  @override
  String get cursor => 'nesw-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var bbox = nodeBBox;
    var w = bbox.width;
    var w1 = _getNewWidth(w, diffX, 1);

    var h = bbox.height;
    var h1 = _getNewHeight(h, diffY, -1);
    if (h != h1) {
      _node.y += diffY;
    }

    _node.setAttribute(RESIZE_SCALE_X, resizeScaleX * w1 / w);
    _node.setAttribute(RESIZE_SCALE_Y, resizeScaleY * h1 / h);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}

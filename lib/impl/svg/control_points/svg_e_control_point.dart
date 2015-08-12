part of smartcanvas.svg;

class SvgEControlPoint extends SvgControlPoint {

  SvgEControlPoint(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection)
    :super(controlGroup, node, type, reflection) {
  }

  @override
  Position getPosition(BBox bbox) {
    var middleY = (bbox.height - SvgControlPoint.size) / 2;
    return new Position(
      x: (bbox.width + negativeScaleXAdjustment + _node.strokeWidth / 2).ceil(),
      y: middleY);
  }

  @override
  String get cursor => 'ew-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var w = nodeBBox.width;
    var w1 = _getNewWidth(w, diffX, 1);
    _node.setAttribute(RESIZE_SCALE_X, resizeScaleX * w1 / w);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}

part of smartcanvas.svg;

class SvgNControlPoint extends SvgControlPoint {

  SvgNControlPoint(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection)
    :super(controlGroup, node, type, reflection);

  @override
  Position getPosition(BBox bbox) {
    var middleX = (bbox.width - SvgControlPoint.size) / 2;
    return new Position(
      x: middleX,
      y: (-SvgControlPoint.size - negativeScaleYAdjustment - _node.strokeWidth / 2).floor()
    );
  }

  @override
  String get cursor => 'ns-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var h = nodeBBox.height;
    var h1 = _getNewHeight(h, diffY, -1);

    if (h != h1) {
      _node.y += diffY;
    }
    _node.setAttribute(RESIZE_SCALE_Y, resizeScaleY * h1 / h);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}

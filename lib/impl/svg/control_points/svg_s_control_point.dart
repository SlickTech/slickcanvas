part of smartcanvas.svg;

class SvgSControlPoint extends SvgControlPoint {

  SvgSControlPoint(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection)
    :super(controlGroup, node, type, reflection);

  @override
  Position getPosition(BBox bbox) {
    var middleX = (bbox.width - SvgControlPoint.size) / 2;
    return new Position(
      x: middleX,
      y: (bbox.height + negativeScaleYAdjustment + _node.strokeWidth / 2).ceil()
    );
  }

  @override
  String get cursor => 'ns-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var h = nodeBBox.height;
    var h1 = _getNewHeight(h, diffY, 1);
    _node.setAttribute(RESIZE_SCALE_Y, resizeScaleY * h1 / h);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}

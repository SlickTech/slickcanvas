part of smartcanvas.svg;

class SvgWControlPoint extends SvgControlPoint {

  SvgWControlPoint(svg.GElement controlGroup, Node node, ControlType type, SvgNode reflection)
    :super(controlGroup, node, type, reflection);

  @override
  Position getPosition(BBox bbox) {
    var middleY = (bbox.height - SvgControlPoint.size) /2 ;
    return new Position(
      x: (-SvgControlPoint.size - negativeScaleXAdjustment - _node.strokeWidth / 2).floor(),
      y: middleY
    );
  }

  @override
  String get cursor => 'ew-resize';

  @override
  bool handleDragMove(dom.MouseEvent e, num diffX, num diffY) {

    var w = nodeBBox.width;
    var w1 = _getNewWidth(w, diffX, -1);
    if (w != w1) {
      _node.x += diffX;
    }

    _node.setAttribute(RESIZE_SCALE_X, resizeScaleX * w1 / w);
    _node.fire(resize);

    return super.handleDragMove(e, diffX, diffY);
  }
}

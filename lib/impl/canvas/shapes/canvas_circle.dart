part of smartcanvas.canvas;

class CanvasCircle extends CanvasGraphNode {

  CanvasCircle(Circle shell): super(shell);

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    var r = getAttribute(R, 0);
    context.beginPath();
    context.arc(0, 0, r, 0, PI * 2, false);
    context.closePath();
  }

  @override
  num get width => (getAttribute(R, 0) + getAttribute(STROKE_WIDTH, 0)) * 2;

  @override
  num get height => (getAttribute(R, 0) + getAttribute(STROKE_WIDTH, 0)) * 2;
}

part of smartcanvas.canvas;

class CanvasPolygon extends CanvasPolyShape {
  CanvasPolygon(Polygon shell):super(shell);

  @override
  Polygon get shell => super.shell;
}

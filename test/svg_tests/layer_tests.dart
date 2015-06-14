part of smartcanvas.test.svg;

Layer _layer = new Layer(CanvasType.svg, {CLASS: '__svg_layer'});

class SvgLayerTests {
  static void run() {
    test('element', layerElementTest);
  }

  static void layerElementTest() {
    stage.addChild(_layer);

    var svgEl = stage.element.querySelector('.__svg_layer');
    expect(svgEl, isNotNull);
  }
}

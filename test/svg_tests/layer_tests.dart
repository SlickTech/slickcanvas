part of smartcanvas.test.svg;

Layer _layer = new Layer(svg, {CLASS: '__svg_layer'});

class SvgLayerTests {
  static void run() {
    test('element', layerElementTest);
  }

  static void layerElementTest() {
    stage.add(_layer);

    var svgEl = stage.element.querySelector('.__svg_layer');
    expect(svgEl, isNotNull);
  }
}
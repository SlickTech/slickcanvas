part of smartcanvas.test.canvas;

class LayerTests {
  static void run() {
    test('element', _elementTest);
  }

  static void _elementTest() {
    Layer layer = new Layer('canvas', {
      ID: '__canvas_layer',
      CLASS: '__my_canvas'
    });

    var canvas = stage.element.querySelector('#__canvas_layer');
    expect(canvas, isNotNull);
  }
}
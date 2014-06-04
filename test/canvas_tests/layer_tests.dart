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

    stage.addChild(layer);

    var layerEl = stage.element.querySelector('.__my_canvas');
    expect(layerEl, isNotNull);
    expect(layerEl.style.width, equals('${stage.width}px'));
    expect(layerEl.style.height, equals('${stage.height}px'));
    expect(layerEl.style.getPropertyValue(OPACITY), equals(''));

    layer.opacity = 0.5;
    expect(layerEl.style.getPropertyValue(OPACITY), equals('0.5'));

    var canvas = stage.element.querySelectorAll('canvas');
    expect(canvas, isNotNull);
    expect(canvas.length, equals((stage.width / CanvasTile.MAX_WIDTH).ceil() * (stage.height / CanvasTile.MAX_HEIGHT).ceil()));

//    throw 'assert';
    layer.width = 300;
    layer.height = 300;
    expect(layerEl.style.width, equals('300px'));
    expect(layerEl.style.width, equals('300px'));

    canvas = stage.element.querySelectorAll('canvas');
    expect(canvas.length, equals((layer.width / CanvasTile.MAX_WIDTH).ceil() * (layer.height / CanvasTile.MAX_HEIGHT).ceil()));

//    throw 'assert';
    layer.remove();
    canvas = stage.element.querySelector('.__my_canvas');
    expect(canvas, isNull);
  }
}
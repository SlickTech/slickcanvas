import 'dart:html' show CanvasElement;

class TextMeasure {
  var _context;

  TextMeasure() {
    var canvas = new CanvasElement(width: 0, height: 0);
    _context = canvas.context2D;
  }

  num measureText(String font, String text) {
    _context.font = font;
    return _context.measureText(text).width;
  }
}

part of smartcanvas.test.canvas;

class TextTests {
  static void run() {
      test('textBasic', testTextBasic);
      test('textWrapping', textWrappingTest);
  }

  static void testTextBasic() {
    Text text = new Text({
      X: 50,
      Y: 50,
      TEXT: '我爱北京天安门，天安门上太阳升。',
      WORD_SPLITER: EMPTY
    });
    stage.addChild(text);
  }

  static void textWrappingTest() {
    Text text = new Text({
      X: 50,
      Y: 50,
      TEXT: '我爱北京天安门，天安门上太阳升。',
      WIDTH: 50,
      NO_WRAP: false,
      WORD_SPLITER: EMPTY
    });
    stage.addChild(text);
  }
}
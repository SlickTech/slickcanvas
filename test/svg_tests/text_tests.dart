part of smartcanvas.test.svg;

class SvgTextTests {
  static void run() {
      test('textBasic', testTextBasic);
      test('textWrapping', textWrappingTest);
  }

  static void testTextBasic() {
    Text text = new Text({
      ID: 'basic_text',
      X: 50,
      Y: 50,
      TEXT: 'Learning SmartCanvas is fun.',
    });
    stage.addChild(text);

    var el = stage.element.querySelector('#basic_text');
    expect(el, isNotNull);
    expect(el.className, equals('__sc_text'));
    expect(el.nodes.length, equals(1));
    expect(el.text, equals('Learning SmartCanvas is fun.'));
    text.remove();
  }

  static void textWrappingTest() {
    Text text = new Text({
      ID: 'wrapped_text',
      X: 50,
      Y: 50,
      TEXT: 'Learning SmartCanvas is fun.',
      WIDTH: 80,
      WRAP: true,
    });
    stage.addChild(text);

    var el = stage.element.querySelector('#wrapped_text');
    expect(el, isNotNull);
    expect(el.className, equals('__sc_text'));
    expect(el.nodes.length, equals(3));
    expect(el.text, equals('Learning SmartCanvas is fun.'));

    var els = stage.element.querySelectorAll('tspan');
    expect(els.length, equals(2));
    expect(els[0].text, equals('SmartCanvas '));

    text.remove();
  }
}

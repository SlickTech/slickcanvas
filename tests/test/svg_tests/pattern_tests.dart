part of smartcanvas.test.svg;

class SvgPatternTests {
  static void run() {
    test('pattern', _patternTest);
    test('pattern set after node added to canvas', _patternSetAfter);
    test('pattern without specified id attribute', _patternWithoutAttr);
  }

  static void _patternTest() {
    SCPattern pattern = new SCPattern({
      ID: 'testPattern',
      WIDTH: 20,
      HEIGHT: 20,
      PATTERN_UNITS: "userSpaceOnUse"
    });
    pattern.addChild(new Path({
      D: "M 0 0 Q 5 20 10 10 T 20 20",
      STROKE: 'black',
      FILL: 'none'
    }));

    Rect rect = new Rect({
      WIDTH: 100,
      HEIGHT: 100
    });

    stage.addChild(rect);
    rect.fill =pattern;
    var elRect = stage.element.querySelector('.__sc_rect');
    var elPattern = stage.element.querySelector('#${pattern.id}');
    expect(elRect, isNotNull);
    expect(elPattern, isNotNull);
    expect(elRect.style.getPropertyValue(FILL), equals('url(#${pattern.id})'));
    rect.remove();
  }

  static void _patternSetAfter() {
    SCPattern pattern = new SCPattern({
      ID: 'testPattern',
      WIDTH: 20,
      HEIGHT: 20,
      PATTERN_UNITS: "userSpaceOnUse"
    });
    pattern.addChild(new Path({
      D: "M 0 0 Q 5 20 10 10 T 20 20",
      STROKE: 'black',
      FILL: 'none'
    }));

    Rect rect = new Rect({
      WIDTH: 100,
      HEIGHT: 100
    });

    stage.addChild(rect);
    rect.fill =pattern;

    var elRect = stage.element.querySelector('.__sc_rect');
    var elPattern = stage.element.querySelector('#${pattern.id}');
    expect(elRect, isNotNull);
    expect(elPattern, isNotNull);
    expect(elRect.style.getPropertyValue(FILL), equals('url(#${pattern.id})'));
    rect.remove();
  }

  static void _patternWithoutAttr() {
    SCPattern pattern = new SCPattern({
      WIDTH: 20,
      HEIGHT: 20,
      PATTERN_UNITS: "userSpaceOnUse"
    });
    pattern.addChild(new Path({
      D: "M 0 0 Q 5 20 10 10 T 20 20",
      STROKE: 'black',
      FILL: 'none'
    }));

    Rect rect = new Rect({
      WIDTH: 100,
      HEIGHT: 100
    });

    stage.addChild(rect);
    rect.fill =pattern;

    var elRect = stage.element.querySelector('.__sc_rect');
    var elPattern = stage.element.querySelector('#${pattern.id}');
    expect(elRect, isNotNull);
    expect(elPattern, isNotNull);
    expect(elRect.style.getPropertyValue(FILL), equals('url(#${pattern.id})'));
    rect.remove();
  }
}
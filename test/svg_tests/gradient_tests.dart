part of smartcanvas.test.svg;

class SvgGradientTests {
  static void run() {
      test('linearGradient', linearGradientTest);
      test('linearGroupInsideGroup', linearGradientInsideGroupTest);
      test('radialGradient', radialGradientTest);
      test('radialGradientInsideGroup', radialGradientInsideGroupTest);
      test('set gradient after node added into a layer', _gradientSetAfter);
  }

  static void linearGradientTest() {
    LinearGradient gradient = new LinearGradient({
      ID:'linear_gradient',
      STOPS: [
        {
          OFFSET: '0%',
          COLOR: 'green'
        },
        {
          OFFSET: '95%',
          COLOR: 'gold'
        }
      ]
    });
    Rect rect = new Rect({
      X: 50,
      Y: 50,
      WIDTH: 200,
      HEIGHT: 200,
      FILL: gradient
    });

    stage.add(rect);

    var defs = stage.element.querySelector('defs');
    expect(defs, isNotNull);

    var grad = defs.querySelector('#linear_gradient');
    expect(grad, isNotNull);
    expect(grad.nodes.length, equals(2));
    for(int i = 0; i < 2; i++) {
      expect(grad.nodes[i].tagName, equals('stop'));
      var stop = grad.nodes[i];
      switch (i) {
        case 0:
          expect(stop.getAttribute(OFFSET), equals('0%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(0, 128, 0);'));
          break;
        case 1:
          expect(stop.getAttribute(OFFSET), equals('95%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(255, 215, 0);'));
          break;
      }
    }

    var rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNotNull);
    expect(rectEl.getAttribute('fill'), equals('url(#linear_gradient)'));

    rect.remove();

    // make sure gradient and rect are removed
    defs = stage.element.querySelector('defs');
    expect(defs, isNull);
    rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNull);
  }

  static void linearGradientInsideGroupTest() {
    LinearGradient gradient = new LinearGradient({
      ID:'linear_gradient',
      STOPS: [
        {
          OFFSET: '0%',
          COLOR: 'green'
        },
        {
          OFFSET: '95%',
          COLOR: 'gold'
        }
      ]
    });
    Rect rect = new Rect({
      X: 50,
      Y: 50,
      WIDTH: 200,
      HEIGHT: 200,
      FILL: gradient
    });

    Group g = new Group();
    g.add(rect);
    stage.add(g);

    var defs = stage.element.querySelector('defs');
    expect(defs, isNotNull);

    var grad = defs.querySelector('#linear_gradient');
    expect(grad, isNotNull);
    expect(grad.nodes.length, equals(2));
    for(int i = 0; i < 2; i++) {
      expect(grad.nodes[i].tagName, equals('stop'));
      var stop = grad.nodes[i];
      switch (i) {
        case 0:
          expect(stop.getAttribute(OFFSET), equals('0%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(0, 128, 0);'));
          break;
        case 1:
          expect(stop.getAttribute(OFFSET), equals('95%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(255, 215, 0);'));
          break;
      }
    }

    var gEl = stage.element.querySelector('g');
    expect(gEl, isNotNull);

    var rectEl = gEl.querySelector('.__sc_rect');
    expect(rectEl, isNotNull);
    expect(rectEl.getAttribute('fill'), equals('url(#linear_gradient)'));

    g.remove();

    defs = stage.element.querySelector('defs');
    expect(defs, isNull);

    gEl = stage.element.querySelector('g');
    expect(gEl, isNull);

    rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNull);
  }

  static void radialGradientTest() {
    RadialGradient gradient = new RadialGradient({
      ID:'radial_gradient',
      STOPS: [
        {
          OFFSET: '0%',
          COLOR: 'green'
        },
        {
          OFFSET: '95%',
          COLOR: 'gold'
        }
      ]
    });
    Rect rect = new Rect({
      X: 50,
      Y: 50,
      WIDTH: 200,
      HEIGHT: 200,
      FILL: gradient
    });

    stage.add(rect);

    var defs = stage.element.querySelector('defs');
    expect(defs, isNotNull);

    var grad = defs.querySelector('#radial_gradient');
    expect(grad, isNotNull);
    expect(grad.nodes.length, equals(2));
    for(int i = 0; i < 2; i++) {
      expect(grad.nodes[i].tagName, equals('stop'));
      var stop = grad.nodes[i];
      switch (i) {
        case 0:
          expect(stop.getAttribute(OFFSET), equals('0%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(0, 128, 0);'));
          break;
        case 1:
          expect(stop.getAttribute(OFFSET), equals('95%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(255, 215, 0);'));
          break;
      }
    }

    var rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNotNull);
    expect(rectEl.getAttribute('fill'), equals('url(#radial_gradient)'));

    rect.remove();

    defs = stage.element.querySelector('defs');
    expect(defs, isNull);
    rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNull);
  }

  static void radialGradientInsideGroupTest() {
    RadialGradient gradient = new RadialGradient({
      ID:'radial_gradient',
      STOPS: [
        {
          OFFSET: '0%',
          COLOR: 'green'
        },
        {
          OFFSET: '95%',
          COLOR: 'gold'
        }
      ]
    });
    Rect rect = new Rect({
      X: 50,
      Y: 50,
      WIDTH: 200,
      HEIGHT: 200,
      FILL: gradient
    });

    Group g = new Group();
    stage.add(g);

    g.add(rect);

    var defs = stage.element.querySelector('defs');
    expect(defs, isNotNull);

    var grad = defs.querySelector('#radial_gradient');
    expect(grad, isNotNull);
    expect(grad.nodes.length, equals(2));
    for(int i = 0; i < 2; i++) {
      expect(grad.nodes[i].tagName, equals('stop'));
      var stop = grad.nodes[i];
      switch (i) {
        case 0:
          expect(stop.getAttribute(OFFSET), equals('0%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(0, 128, 0);'));
          break;
        case 1:
          expect(stop.getAttribute(OFFSET), equals('95%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(255, 215, 0);'));
          break;
      }
    }

    var gEl = stage.element.querySelector('g');
    expect (gEl, isNotNull);

    var rectEl = gEl.querySelector('.__sc_rect');
    expect(rectEl, isNotNull);
    expect(rectEl.getAttribute('fill'), equals('url(#radial_gradient)'));

    g.remove();

    defs = stage.element.querySelector('defs');
    expect(defs, isNull);
    gEl = stage.element.querySelector('g');
    expect (gEl, isNull);
    rectEl = stage.element.querySelector('.__sc_rect');
    expect(rectEl, isNull);
  }

  static void _gradientSetAfter() {
    RadialGradient gradient = new RadialGradient({
      ID:'radial_gradient',
      STOPS: [
        {
          OFFSET: '0%',
          COLOR: 'green'
        },
        {
          OFFSET: '95%',
          COLOR: 'gold'
        }
      ]
    });
    Rect rect = new Rect({
      X: 50,
      Y: 50,
      WIDTH: 200,
      HEIGHT: 200,
    });

    stage.add(rect);
    rect.fill = gradient;

    var grad = stage.element.querySelector('#radial_gradient');
    var rectEl = stage.element.querySelector('.__sc_rect');
    expect(grad, isNotNull);
    expect(grad.nodes.length, equals(2));
    for(int i = 0; i < 2; i++) {
      expect(grad.nodes[i].tagName, equals('stop'));
      var stop = grad.nodes[i];
      switch (i) {
        case 0:
          expect(stop.getAttribute(OFFSET), equals('0%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(0, 128, 0);'));
          break;
        case 1:
          expect(stop.getAttribute(OFFSET), equals('95%'));
          expect(stop.getAttribute(STYLE), equals('stop-color: rgb(255, 215, 0);'));
          break;
      }
    }
    expect(rectEl, isNotNull);
    expect(rectEl.getAttribute('fill'), equals('url(#radial_gradient)'));

    rect.fill = 'none';
    expect((rect.impl as SvgNode).element.attributes['fill'], isNull);
    expect((rect.impl as SvgNode).element.style.getPropertyValue('fill'), equals('none'));

    rect.remove();

  }
}
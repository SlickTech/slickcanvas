part of smartcanvas.test;

class GradientTests {
  static void run() {
      test('linearGradient', linearGradientTest);
      test('linearGroupInsideGroup', linearGradientInsideGroupTest);
      test('radialGradient', radialGradientTest);
      test('radialGradient', radialGradientInsideGroupTest);
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

    _stage.add(rect);

    var grad = _stage.element.querySelector('#linear_gradient');
    var rectEl = _stage.element.querySelector('.__sc_rect');
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
    expect(rectEl.getAttribute('fill'), equals('url(#linear_gradient)'));

    rect.remove();
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
    _stage.add(g);

    var grad = _stage.element.querySelector('#linear_gradient');
    var rectEl = _stage.element.querySelector('.__sc_rect');
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
    expect(rectEl.getAttribute('fill'), equals('url(#linear_gradient)'));

    g.remove();
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

    _stage.add(rect);

    var grad = _stage.element.querySelector('#radial_gradient');
    var rectEl = _stage.element.querySelector('.__sc_rect');
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

    rect.remove();
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

      _stage.add(rect);

      var grad = _stage.element.querySelector('#radial_gradient');
      var rectEl = _stage.element.querySelector('.__sc_rect');
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

      rect.remove();
    }
}
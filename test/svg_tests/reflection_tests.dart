part of smartcanvas.test.svg;

class SvgReflectionTests {
  static void run() {
    test('add reflectable not to group on unstaged layer', () {

      // Add layer
      Layer layer = new Layer(svg, {ID: 'unstaged_layer'});
      stage.add(layer);

      // Add group block with a reflectable node
      Group group = new Group({ID: '_containerGroup'});
      Rect rect = new Rect({ID: 'reflectableNode1', X: 100, Y:100, WIDTH: 100, HEIGHT: 100, DRAGGABLE: true});
      group.add(rect);

      layer.add(group);

      var reflectionLayerEl = stage.element.querySelector('#__reflection_layer');
      expect(reflectionLayerEl, isNotNull);

      var reflectRect1El = reflectionLayerEl.querySelector('#reflectableNode1');
      expect(reflectRect1El, isNotNull);

      // remvoe layer
      layer.remove();

      expect(stage.element.children.length, equals(1));

      // add another reflectable node to group
      Rect rect2 = new Rect({ID: 'reflectableNode2', X: 200, Y:100, WIDTH: 100, HEIGHT: 100});
      group.add(rect2);
      rect2.on(CLICK, (){print('reflectableNode2 clicked');});

      stage.add(layer);

      var reflectRect2El = reflectionLayerEl.querySelector('#reflectableNode2');
      expect(reflectRect2El, isNotNull);

      layer.remove();
    });
  }
}
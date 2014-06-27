import 'dart:html' as dom hide Text;
import 'package:smartcanvas/smartcanvas.dart';

void main() {
  dom.Element container = dom.document.querySelector('#smartCanvas');


  Stage stage = new Stage(container, svg, {
      WIDTH: container.clientWidth,
      HEIGHT: 900,
      DRAGGABLE: true
    });

  Layer layer = new Layer(canvas, {});

  Rect rect = new Rect({
    X: 50,
    Y: 50,
    WIDTH: 100,
    HEIGHT: 100,
    FILL: 'red',
    DRAGGABLE: true
  });

  layer.addChild(rect);
  stage.addChild(layer);

//    Circle circle = new Circle({
//      X: 50,
//      Y: 50,
//      R: 40,
//      STROKE: 'green',
//      FILL: 'yellow',
//      LISTENING: true
//    });
//
//    Rect rect = new Rect({
//      'x': 30,
//      'y': 30,
//      'width': 40,
//      'height': 40,
//      'stroke': 'red',
//      'strokeWidth': 2,
////      'draggable': true,
//    });
//
//    Ellipse ellipse = new Ellipse({
//      'x': 300,
//      'y': 200,
//      'rx': 100,
//      'ry': 50,
//      'fill': 'green',
//      'stroke': 'purple',
//      'listening': true,
//      'draggable': true
//    });
//    ellipse.on(MOUSEDOWN, (e){
//      ellipse.moveToTop();
//    });
//
//    Line line = new Line({
//      'x1': 100,
//      'y1': 100,
//      'x2': 150,
//      'y2': 150,
//      'stroke': 'powderblue',
//      'stroke-width': 20,
//      'fill': 'none'
//    });
//
//    Group g = new Group({
//      'draggable': true,
//      'listening': true,
//      'name': 'group'
//    });
//    g.add(circle);
//    g.add(rect);
//
//    print('pos g - ${g.position.x}, ${g.position.y}');
//    print('pos rect - ${rect.position.x}, ${rect.position.y}');
//    print('abs g rect - ${g.absolutePosition.x}, ${g.absolutePosition.y}');
//    print('abs pos rect - ${rect.absolutePosition.x}, ${rect.absolutePosition.y}');
//    print('rect: ${rect.x}, ${rect.y}');
//
//    stage.add(g);
//
//    g.x = 100;
//    g.y = 100;
//
//    print('pos: g - ${g.position.x}, ${g.position.y}');
//    print('pos rect - ${rect.position.x}, ${rect.position.y}');
//    print('abs g rect - ${g.absolutePosition.x}, ${g.absolutePosition.y}');
//    print('abs pos rect - ${rect.absolutePosition.x}, ${rect.absolutePosition.y}');


//    stage.add(new Circle({
//      X: 130,
//      Y: 130,
//      FILL: 'blue',
//      R: 2
//    }));

//    g.on('mousedown', (e) {
//      print('group mousedown');}
//    );
//    circle.on('click', (e) {
//      print ("circle clicked");
//    });
//    circle.on(MOUSEOVER, (e) {print('***** Circle MouseEnter *****');});
//    circle.on(MOUSEOUT, (e) {print('***** Circle MouseOut *****'); });
//    g.on(mousemove, (e) => print('....'));
//    g.on(click, (e) => print('group clicked'));
//    g.on(dblclick, (e) => print('group double clicked'));

//  canvas.add(circle);
//    g.on('mousedown', (e) {
//      print('group mousedown');}
//    );
//    int i = 0;
//    g.on('mousedown', (e){
//      if (i < 2) {
//        g.moveUp();
//        ++i;
//      } else {
//        g.moveDown();
//        --i;
//      }
//
//    });
//    g.on(CLICK, (e) => print('group clicked'));
//    g.on(dblclick, (e) => print('group double clicked'));

//  canvas.add(rect);
//    stage.add(ellipse);
//    stage.add(line);

//    g.add(line);
//    g.add(circle);
//    circle.moveToBottom();

//    Group g1 = new Group();
//    Circle c2 = new Circle({
//      'x': 100,
//      'y': 100,
//      'r': 50,
//      'fill': 'red',
//      'draggable': true
//    });
//
//    Layer layer2 = new Layer(svg, {
//      'id': 'two'
//    });

//    c2.on(MOUSEDOWN, (e) => print('c2 mousedown'));
//    c2.on(DBLCLICK, (e) => print('c2 double click'));

//    g1.addChild(c2);
//    stage.addChild(g1);
//    stage.addChild(layer2);
//
//    Group g2 = new Group({
//    });
//    layer2.addChild(g2);
//
//    c2.moveTo(g2);
//
//    stage.add(ellipse);
//
//    var txt = new Text({
//      'text': 'A',
//      'x': 100,
//      'y': 100,
//      'fill': 'red',
//      'font-size': 32
//    });
//
//    stage.add(txt);

//    Polygon p = new Polygon({
//      'points': "220,10 300,210 170,250 123,234",
//      'fill': 'lime',
//      'draggable': true
//    });
//    layer2.add(p);
//
//    Path path = new Path({
//      'd': "M150 0 L75 200 L225 200 Z",
//      'draggable': true
//    });
//    stage.add(path);
//
//    p.x = p.x + 200;
//    p.y = p.y + 100;

//    g.x = 100;

//    var c = c2.clone({'fill': 'red'});
//    canvas2.add(c);
//    Layer layer = new Layer({
//      'id': 'addOnLayer',
//    });
//    layer.add(c2);
//    canvas.add(layer);
//    canvas.defaultLayer.moveUp();
////    c2.moveTo(canvas.defaultLayer);
//    layer.draggalbe = true;

//    var polyline = new Polyline({
//      'points': [200, 200, -100, -100], // 200, 200, 300, 200],
//      'stroke': 'red',
//      'stroke-width': 5,
//      'fill': 'none'
//    });
//    stage.add(polyline);

    // test scale
//    stage.scaleX = 1.67;
//    stage.scaleX = 0.5;
//    stage.scaleY = 0.5;
//
//    // test pattern
//    SCPattern fillPattern = new SCPattern({
//      ID: 'grid',
//      WIDTH: 8,
//      HEIGHT: 8,
//      PATTERN_UNITS: "userSpaceOnUse"
//    });
//    fillPattern.add(new Path({
//      D: 'M8 0 L0 0 0 8',
//      FILL: 'none',
//      STROKE: 'red',
//      STROKE_WIDTH: 0.5
//    }));
//    Rect grid = new Rect({
//       WIDTH: stage.width,
//       HEIGHT: stage.height,
//       FILL: fillPattern
//    });
//    stage.add(grid);
//
////    grid.remove();
////
//    dom.window.onResize.listen((e) {
//      stage.width = container.clientWidth;
//      grid.width = stage.width;
//    });
}

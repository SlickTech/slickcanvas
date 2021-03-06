import 'dart:html' as dom hide Text;
import 'package:smartcanvas/smartcanvas.dart';

void main() {
  Rect rect = new Rect({
    X: 200,
    Y: 100,
    WIDTH: 100,
    HEIGHT: 100,
    FILL: 'red',
    MIN_WIDTH: 50,
    MIN_HEIGHT: 50,
    MAX_WIDTH: 200,
    MAX_HEIGHT: 200
//    OFFSET_X: -100,
//    OFFSET_Y: -100
  });

  Circle circle = new Circle({
    R: 50,
    FILL: 'yellow',
    OFFSET_X: -100,
    OFFSET_Y: -100,
  });

  Ellipse ellipse = new Ellipse({
    RX: 100,
    RY: 50,
    FILL: 'blue'
  });

  Line line = new Line({
    X1: -150, Y1: 50,
    X2: 150, Y2: 150,
    STROKE_WIDTH: 5,
    STROKE: 'red'
  });

  Text text = new Text({
    X: 100, Y:100,
    TEXT: 'Hello World',
    FILL: 'orange',
    FONT_SIZE: 20
  });

  Path path = new Path({
    D: //'M150 0 L75 200 L225 200 Z',
    //'M100,200 C100,100 250,100 250,200 S400,300 400,200',
//    'M200,300 Q400,50 600,300 t1000,300',
//      'M300,200 h-150 a150,150 0 1,0 150,-150 z' +
//      ' M275,175 v-150 a150,150 0 0,0 -150,150 z',
      'M10,350 l 50,-25 ' +
           'a25,25 -30 0,1 50,-25 l 50,-25 ' +
           'a25,50 -30 0,1 50,-25 l 50,-25 ' +
           'a25,75 -30 0,1 50,-25 l 50,-25 ' +
           'a25,100 -30 0,1 50,-25 l 50,-25',
    STROKE: 'purple',
    STROKE_WIDTH: 10,
    FILL: 'none'
  });

  Polygon polygon = new Polygon({
    'points': "220,10,300,210,170,250,-123,234",
    'fill': 'lime',
    X: 200
  });

  Polyline polyline = new Polyline({
    'points': [200, 200, -100, -100, 100, 0],
    'stroke': 'red',
    'stroke-width': 5,
    X: 100,
    Y: 100
  });

  Image image = new Image({
    WIDTH: 100,
    HEIGHT: 100,
    HREF: 'logo.png'
  });

  dom.Element svgContainer = dom.document.querySelector('.svg-canvas');
  Stage svgStage = new Stage(svgContainer);

  dom.Element canvasContainer = dom.document.querySelector('.canvas-canvas');
  Stage canvasStage = new Stage(canvasContainer, defaultLayerType:CanvasType.canvas);

  dom.Element nodes = dom.document.querySelector('.node-list');

  dom.Element addBtn = dom.document.querySelector('.btn-add');
  addBtn.onClick.listen((e) {
    var shapes = dom.document.querySelectorAll('input[type=checkbox]:checked');

    shapes.forEach((shape) {
      var node, svgNode, canvasNode;

      switch(shape.className) {
        case 'rect':
          node = rect;
          break;
        case 'circle':
          node = circle;
          break;
        case 'ellipse':
          node = ellipse;
          break;
        case 'line':
          node = line;
          break;
        case 'text':
          node = text;
          break;
        case 'path':
          node = path;
          break;
        case 'polygon':
          node = polygon;
          break;
        case 'polyline':
          node = polyline;
          break;
        case 'image':
          node = image;
          break;
      }

      svgNode = node.clone({DRAGGABLE: true, RESIZABLE: true});
      svgNode.on(mouseDown, (e){ svgNode.moveToTop(); });
      svgStage.addChild(svgNode);
      svgNode.showControls();

//      var t = node.clone({DRAGGABLE: true});
//      t.scaleX = 2;
//      t.scaleY = 2;
//      svgStage.addChild(t);


//      svgNode = node.clone({DRAGGABLE: true, ROTATE: 45, ROTATE_X: 50, ROTATE_Y: 50});
//      svgNode.on(MOUSEDOWN, (e){ svgNode.moveToTop(); });
//      svgStage.addChild(svgNode);

      canvasNode = node.clone({DRAGGABLE: true, RESIZABLE: true});
      canvasNode.on(mouseDown, (e){ canvasNode.moveToTop(); });
      canvasStage.addChild(canvasNode);

//      canvasNode = node.clone({DRAGGABLE: true, ROTATE: 45, ROTATE_X: 50, ROTATE_Y: 50});
//      canvasNode.on(MOUSEDOWN, (e){ canvasNode.moveToTop(); });
//      canvasStage.addChild(canvasNode);
    });
  });

  //  dom.Element circleBtn = dom.document.querySelector('.circle-btn');
//  circleBtn.onClick.listen((e) {
//    svgStage.addChild(circle.clone());
//    canvasStage.addChild(circle.clone());
//  });

//  Stage stage = new Stage(container, svg, {
//      WIDTH: container.clientWidth,
//      HEIGHT: 900,
////      DRAGGABLE: true
//    });
//
//  Layer layer = new Layer(canvas, {});
//
//  Rect rect = new Rect({
//    X: 100,
//    Y: 0,
//    WIDTH: 100,
//    HEIGHT: 100,
//    FILL: 'red',
//    DRAGGABLE: true
//  });
//
//  layer.addChild(rect);
//  stage.addChild(layer);

//  new Timer(new Duration(seconds: 5), (){
//    rect
//    ..x = 100
//    ..y = 100;
//  });

//    Circle circle = new Circle({
//      X: 50,
//      Y: 50,
//      R: 40,
//      STROKE: 'green',
//      FILL: 'yellow',
//    });
//
//    Rect rect = new Rect({
//      'x': 30,
//      'y': 30,
//      'width': 40,
//      'height': 40,
//      'stroke': 'red',
//      'strokeWidth': 2,
////      'draggable': true
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
//      'name': 'group'
//    });
//    g.addChild(circle);
//    g.addChild(rect);
//
//    print('pos g - ${g.position.x}, ${g.position.y}');
//    print('pos rect - ${rect.position.x}, ${rect.position.y}');
//    print('abs g rect - ${g.absolutePosition.x}, ${g.absolutePosition.y}');
//    print('abs pos rect - ${rect.absolutePosition.x}, ${rect.absolutePosition.y}');
//    print('rect: ${rect.x}, ${rect.y}');
//
//    stage.addChild(g);
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

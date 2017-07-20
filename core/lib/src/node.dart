import 'package:svgpath/svgpath.dart';
export 'package:svgpath/src/bounding_box.dart';

import 'package:dart_ext/collection_ext.dart' as ext;

import 'model.dart';
export 'package:observable/observable.dart';

import 'container_node.dart';

import 'position.dart';
export 'position.dart';

abstract class Node extends Model {
  ContainerNode parent;

  final matrix = new Matrix();

  int _x0, _y0;
//  bool _isListening;

  Node(Map<String, dynamic> props) {
    properties.addAll(ext.clone(props));

    _x0 = getProperty('x', 0).toInt();
    _y0 = getProperty('y', 0).toInt();

    matrix.translate(getProperty('offsetX', 0), getProperty('offsetY', 0));
    matrix.scale(getProperty('scaleX', 1), getProperty('scaleY', 1));

//    if (getProperty('visible', defaultValue: true) == false) {
//      visible = false;
//    }

//    property.changes.listen(_handlePropertyChanges);
  }

  clone([Map<String, dynamic> propertiesOverride = const {}]);

  void remove() {
    if (parent != null) {
      parent.children.remove(this);
      parent = null;
    }
  }

  void moveTo(ContainerNode newParent) {
    if (parent != null) {
      parent.removeChild(this);
    }
    newParent.addChild(this);
  }

  void moveUp() {
    if (parent != null) {
      var index = parent.children.indexOf(this);
      if (index != parent.children.length - 1) {
        remove();
        parent.insertChild(index + 1, this);
      }
    }
  }

  void moveDown() {
    if (parent != null) {
      var index = parent.children.indexOf(this);
      if (index > 0) {
        remove();
        parent.insertChild(index - 1, this);
      }
    }
  }

  void moveToTop() {
    if (parent != null) {
      var index = parent.children.indexOf(this);
      if (index != parent.children.length - 1) {
        remove();
        parent.addChild(this);
      }
    }
  }

  void moveToBottom() {
    if (parent != null) {
      var index = parent.children.indexOf(this);
      if (index > 0) {
        remove();
        parent.insertChild(0, this);
      }
    }
  }

//  @override
//  void on(events, Function handler, [String id]) {
//    if (events is List) {
//      events.forEach((String event) {
//        _on(event, handler, id);
//      });
//    } else if (events is String) {
//      List<String> ss = events.split(space);
//      ss.forEach((String event) {
//        _on(event, handler, id);
//      });
//    }
//  }

//  void _on(String event, Function handler, [String id]) {
//    if (eventListeners[event] == null) {
//      eventListeners[event] = new EventHandlers();
//    }
//    eventListeners[event].add(new EventHandler(id, handler));
//
//    if (!_isListening) {
//      _isListening = isDomEvent(event);
//
//      // Reflect the node if a dom event added
//      // and the node hasn't been reflected yet
//      if (_isListening && parent != null && _reflection == null) {
//        (parent as Group)._reflectChild(this);
//      }
//    }
//
//    if (_impl != null) {
//      _impl.on(event, handler, id);
//    }
//
//    if (_reflection != null) {
//      _reflection.on(event, handler, id);
//    }
//  }

  BoundingBox get bbox;

  Position getRelativePosition(Node referenceParent) {
    var pos = position;
    var posParent;
    var p = parent;
    while (p != null) {
      posParent = p.position;
      pos += posParent;
      if (p == referenceParent) {
        return pos;
      }
      p = p.parent;
    }
    return null;
  }

//  /**
//   * Show the node
//   */
//  void show() {
//    visible = true;
//  }
//
//  /**
//   * Hide the node
//   */
//  void hide() {
//    visible = false;
//  }

  /**
   * Where or not the node if reflectable
   *
   * A node is reflectable if the node was draggable or listening
   */
//  bool get reflectable =>
//      getProperty('reflectable', defaultValue: true) &&
//      (draggable || _isListening || resizable);
//
//  void set reflectable(bool value) => setProperty('reflectable', value);

  /**
   * Get the layer of the node
   */
//  Layer get layer {
//    var p = parent;
//    while (p != null && p is! Layer) {
//      p = p.parent;
//    }
//    return p as Layer;
//  }

  /**
   * Get the stage
   */
//  Stage get stage => layer == null ? null : layer.stage;

  void set x(int value) => matrix.translate(value - _x0, 0);

  int get x => matrix.calc(_x0, _y0)[0];

  void set y(int value) => matrix.translate(0, value - _y0);

  int get y => matrix.calc(_x0, _y0)[1];

  num get width => bbox.width;

  num get height => bbox.height;

//  void set width(num value) => setProperty('width', value);
//  num get width => getProperty('width', defaultValue: 0);
//  num get actualWidth =>
//      width * scaleX * getProperty('resizeScaleX', defaultValue: 1);
//
//  void set height(num value) => setProperty('height', value);
//  num get height => getProperty('height', defaultValue: 0);
//  num get actualHeight =>
//      height * scaleY * getProperty('resizeScaleY', defaultValue: 1);

  void set fill(dynamic value) => setProperty('fill', value);
  dynamic get fill => getProperty('fill');

  void set fillOpacity(num value) => setProperty('fill-opacity', value);
  num get fillOpacity => getProperty('fill-opacity');

  void set opacity(num value) => setProperty('opacity', value);
  num get opacity => getProperty('opacity', 1);

  void set cursor(String value) => setProperty('cursor', value);
  String get cursor => getProperty('cursor', 'default');

  void set draggable(bool value) => setProperty('draggable', value);
  bool get draggable => getProperty('draggable', false);

  void set resizable(bool value) => setProperty('resizable', value);
  bool get resizable => getProperty('resizable', false);

//  bool get isListening => _isListening;

  void set visible(bool value) {
    if (!value) {
      setProperty('display', 'none');
    } else {
      removeProperty('display');
    }
  }

  bool get visible => !hasProperty('display');

//  bool get isDragging {
//    if (_reflection != null) {
//      return _reflection.isDragging;
//    }
//    return false;
//  }

  void set scaleX(num sx) {
    if (sx != 1 && sx != matrix.scaleXValue) {
      matrix.scale(sx, 1);
      setProperty('matrix', matrix.toString());
    }
  }

  num get scaleX => matrix.scaleXValue;
//  num get actualScaleX =>
//      matrix.scaleX * getProperty('resizeScaleX', defaultValue: 1);

  void set scaleY(num sy) {
    if (sy != 1) {
      matrix.scale(1, sy);
//      fire(scaleYChanged, y, oldValue);
    }
  }

  num get scaleY => matrix.scaleYValue;
//  num get actualScaleY =>
//      matrix.scaleY * getProperty('resizeScaleY', defaultValue: 1);

  void scale({num sx: 1, num sy: 1}) {
    if (sx != 1 || sy != 1) {
      matrix.scale(sx, sy);
//      fire(scaleChanged, sx, sy, oldSx, oldSy);
    }
  }

  void set translateX(num tx) {
    if (tx != 0) {
      matrix.translate(tx, 0);
//      fire(translateXChanged, tx, oldValue);
    }
  }

  num get translateX => matrix.translateXValue;

  void set translateY(num ty) {
    if (ty != 0) {
      matrix.translate(0, ty);
//      fire(translateYChanged, ty, oldValue);
    }
  }

  num get translateY => matrix.translateYValue;

  void translate({num tx: 0, num ty: 0}) {
    if (tx != 0 || ty != 0) {
      matrix.translate(tx, ty);
//      fire(translateChanged, tx, ty, oldTx, oldTy);
    }
  }

  void rotate(num angle, {num rx: 0, num ry: 0}) {
    if (angle != 0) {
      matrix.rotate(angle, rx, ry);
//      fire('rotationChanged', r, oldValue);
    }
  }

  Position get position => new Position.fromPoints(matrix.calc(_x0, _y0));

  void set absolutePosition(Position pos) {
    var position = new Position();
    var posParent;
    var p = parent;
    while (p != null /*&& parent is! Layer*/) {
      posParent = p.position;
      position.x += posParent.x;
      position.y += posParent.y;
      p = p.parent;
    }
    this.x = pos.x - position.x;
    this.y = pos.y - position.y;
  }

  Position get absolutePosition {
    var pos = position;
    var posParent;
    var p = parent;
    while (p != null /*&& parent is! Layer*/) {
      posParent = p.position;
      pos += posParent;
      p = p.parent;
    }
    return pos;
  }

//  SvgNode get reflection => _reflection;
}

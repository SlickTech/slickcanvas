import 'dart:html';
import 'dart:async';
import 'package:slickcanvas_core/core.dart' as core show Position, Matrix;
import 'package:slickcanvas_core/src/model.dart';
import 'package:dart_ext/collection_ext.dart' as ext;
import 'animation_frame.dart';
import 'pannable.dart';
import 'layer.dart';
import 'change_info.dart';

class Stage extends Model with Pannable {
  final Element container;
  final Element element = new DivElement();

//  svg.SvgSvgElement _reflectionLayer = new svg.SvgSvgElement();

  core.Position _pointerPosition = new core.Position();
  final _pointerScreenPosition = new core.Position();

  final animationFrame = new AnimationFrame();
  final matrix = new core.Matrix();

  final _layers = <Layer>[];
  final _elStreamSubscriptions = <StreamSubscription>[];

  final _scaleChangedStreamController =
      new StreamController<PointChangeInfo>.broadcast();

  final _translateChangedStreamController =
      new StreamController<PointChangeInfo>.broadcast();

  Stage(this.container,
      {Map<String, dynamic> props: const {}, bool createShadowRoot: false})
      : super() {
    if (container == null) {
      throw "container doesn't exit";
    }

    properties.addAll(ext.clone(props));
    _populateConfig(props);
    _initElement();

    if (createShadowRoot) {
      container.createShadowRoot().append(element);
    } else {
      container.append(element);
    }

//    if (isStatic == false) {
//      _reflectionLayer =
//          new svg.SvgSvgElement({'width': this.width, 'height': this.height});
//
//      element.nodes.add(_reflectionLayer);
//    }

    _elStreamSubscriptions.add(element.onMouseDown.listen(_onMouseDown));
    _elStreamSubscriptions.add(element.onMouseMove.listen(_onMouseMove));
    _elStreamSubscriptions.add(element.onMouseUp.listen(_onMouseUp));
    _elStreamSubscriptions
        .add(element.onMouseEnter.listen(_setPointerPosition));
    _elStreamSubscriptions
        .add(element.onMouseLeave.listen(_setPointerPosition));
    _elStreamSubscriptions.add(element.onMouseOver.listen(_setPointerPosition));
    _elStreamSubscriptions.add(element.onMouseOut.listen(_setPointerPosition));
    _elStreamSubscriptions
        .add(element.onMouseOver.listen((e) => _setPointerPosition(e)));

    properties.changes.listen((changes) {
      for (MapChangeRecord<String, dynamic> change in changes) {
        if (change.key == 'pannable') {
          if (!change.newValue) {
            endPan();
          }
        }
      }
    });
  }

  void _populateConfig(Map<String, dynamic> props) {
    getProperty('width') ?? setProperty('width', container.clientWidth);
    getProperty('height') ?? setProperty('height', container.clientHeight);

    var s = getProperty('scale');
    if (s != null) {
      scale(s, s);
    } else {
      var sx = getProperty('scaleX', 1);
      var sy = getProperty('scaleY', 1);
      scale(sx, sy);
    }
  }

  void _initElement() {
    if (id != null && id.isNotEmpty) {
      element.id = id;
    }
    element.classes.add('slickcanvas-stage');
    element.classes.addAll(classNames);
    element.setAttribute('role', 'presentation');
    element.style
      ..display = 'inline-block'
      ..position = 'relative'
      ..width = '${getProperty('width')}px'
      ..height = '${getProperty('height')}px'
      ..margin = '0'
      ..padding = '0';
  }

  void remove() {
    for (var sub in _elStreamSubscriptions) {
      sub.cancel();
    }
    element.remove();
  }

  void _onMouseDown(e) {
    _setPointerPosition(e);
    onMouseDown(e);
  }

  void _onMouseMove(e) {
    _setPointerPosition(e);
    onMouseMove(e);
  }

  void _onMouseUp(e) {
    _setPointerPosition(e);
    onMouseUp(e);
  }

  void _setPointerPosition(e) {
    var elementClientRect = element.getBoundingClientRect();
    var p = matrix.calc(e.client.x - elementClientRect.left,
        e.client.y - elementClientRect.top);
//    var x = (e.client.x - elementClientRect.left) / matrix.scaleXValue -
//        matrix.translateXValue;
//    var y = (e.client.y - elementClientRect.top) / _transformMatrix.scaleY -
//        _transformMatrix.translateY;
    _pointerPosition = new core.Position(x: p[0], y: p[1]);
  }

  void _updatePointerPositionXFromScaleXChange(num newScaleX, num oldScaleX) {
    if (_pointerPosition != null) {
      var factor = oldScaleX / newScaleX;
      _pointerPosition.x =
          _pointerPosition.x * factor + matrix.translateXValue * (factor - 1);
    }
  }

  void _updatePointerPositionYFromScaleYChange(num newScaleY, num oldScaleY) {
    if (_pointerPosition != null) {
      var factor = oldScaleY / newScaleY;
      _pointerPosition.y =
          _pointerPosition.y * factor + matrix.translateYValue * (factor - 1);
    }
  }

  void _updatePointerPositionXFromTranslateXChange(
      num newTransX, num oldTransX) {
    if (_pointerPosition != null) {
      _pointerPosition.x += oldTransX - newTransX;
    }
  }

  void _updatePointerPositionYFromTranslateYChange(
      num newTransY, num oldTransY) {
    if (_pointerPosition != null) {
      _pointerPosition.y += oldTransY - newTransY;
    }
  }

  core.Position get pointerPosition => _pointerPosition;

  void addLayer(Layer layer) {
    layer.stage = this;
//    layer._reflection = _reflectionLayer.impl as SvgLayer;

//    if (layer.width == null) {
//      layer.width = width;
//      layer.height = height;
//    }

//    if (_reflectionLayer != null) {
//      int index = _element.nodes.indexOf(_reflectionLayer.impl.element);
//      _element.nodes.insert(index, node.impl.element);
//      children.insert(index, node);
//
//      node.children.forEach((child) {
//        _reflectionLayer.reflectNode(child);
//      });
//    } else {
    element.append(layer.element);
    _layers.add(layer);
//    }
  }

  void removeLayer(Layer layer) {
    element.children.remove(layer.element);
    _layers.remove(layer);
    layer.stage = null;
//    node._reflection = null;
  }

  void clearChildren() {
    while (_layers.isNotEmpty) {
      removeLayer(_layers.first);
    }
  }

  void insertLayer(int index, Layer layer) {
    layer.stage = this;

    _layers.insert(index, layer);
//    if (layer.width == null) {
//      layer.width = width;
//      layer.height = height;
//    }
    element.nodes.insert(index, layer.element);

//    if (_reflectionLayer != null) {
//      node._reflection = _reflectionLayer.impl as SvgLayer;
//      node.children.forEach((child) {
//        _reflectionLayer.reflectNode(child);
//      });
//    }
  }

//  void getSvg(SvgNode defNode) {
//    if (_svgDefLayer == null) {
//      _svgDefLayer = new Layer(svg, {});
//      _svgDefLayer.stage = this;
//      _children.add(_svgDefLayer);
//      _element.nodes.add(_svgDefLayer._impl.element);
//    }
//  }

  void set id(String value) => setProperty('id', value);
  String get id => getProperty('id');

//  num get x => getProperty('x', 0);
//  num get y => getProperty('y', 0);
//
//  void set width(num value) => setProperty('width', value);
//  num get width => getProperty('width');
//
//  void set height(num value) => setProperty('height', value);
//  num get height => getProperty('height');

  num get width => element.clientWidth;
  num get height => element.clientHeight;

  void scale(num sx, num sy) {
    var oldSx = matrix.scaleXValue;
    var oldSy = matrix.scaleYValue;

    if (sx != oldSx || sy != oldSy) {
      matrix.scale(sx, sy);

      _updatePointerPositionXFromScaleXChange(sx, oldSx);
      _updatePointerPositionYFromScaleYChange(sy, oldSy);

      _scaleChangedStreamController
          .add(new PointChangeInfo(oldSx, oldSy, sx, sy));
    }
  }

  void translate(num tx, num ty) {
    var oldTx = matrix.translateXValue;
    var oldTy = matrix.translateYValue;

    if (tx != oldTx || ty != oldTy) {
      matrix.translate(tx, ty);

      _updatePointerPositionXFromTranslateXChange(tx, oldTx);
      _updatePointerPositionYFromTranslateYChange(ty, oldTy);

      _translateChangedStreamController
          .add(new PointChangeInfo(oldTx, oldTy, tx, ty));
    }
  }

  bool get isStatic => getProperty('isStatic', false);
}

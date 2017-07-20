import 'dart:html';
import 'dart:async';
import 'package:dart_ext/collection_ext.dart' as ext;
import 'package:slickcanvas_core/core.dart' as core show Matrix, Position;

abstract class Pannable {
  core.Matrix matrix;

  bool _panStarting = false;
  bool _inPanning = false;
  bool _panStarted = false;

  core.Position _preDragPointerPosition;
  core.Position _pointerPosition;

  final _panStartController = new StreamController<MouseEvent>.broadcast();
  final _panningController = new StreamController<MouseEvent>.broadcast();
  final _panEndController = new StreamController<bool>.broadcast();

  get properties;

  void startPan(MouseEvent e) {
    if (_panStarting) {
      return;
    }

    e.preventDefault();
    e.stopPropagation();

    _panStarting = true;
    _preDragPointerPosition = _pointerPosition;
  }

  void endPan([MouseEvent e]) {
    if (e != null) {
      e.preventDefault();
      e.stopPropagation();
    }
    _panStarting = false;
    _inPanning = false;
    if (_panStarted && _panEndController.hasListener) {
      _panEndController.add(true);
    }
    _panStarted = false;
  }

  void panning(MouseEvent e) {
    e.preventDefault();
    e.stopPropagation();

    if (!_panStarted) {
      _inPanning = true;
      _panStarted = true;
      if (_panStartController.hasListener) {
        _panStartController.add(e);
      }
    }

    matrix.translate(
        ext.getValue(properties, 'translateX', 0) +
            _pointerPosition.x -
            _preDragPointerPosition.x,
        ext.getValue(properties, 'translateY', 0) +
            _pointerPosition.y -
            _preDragPointerPosition.y);

    _preDragPointerPosition = _pointerPosition;

    if (_panningController.hasListener) {
      _panningController.add(e);
    }
  }

  void onMouseDown(MouseEvent e) {
    if (pannalbe) {
      new Future.delayed(new Duration(seconds: 0), () => startPan(e));
    }
  }

  void onMouseMove(MouseEvent e) {
    if (_panStarting) {
      new Future.delayed(new Duration(seconds: 0), () => panning(e));
    }
  }

  void onMouseUp(MouseEvent e) {
    if (_inPanning) {
      new Future.delayed(new Duration(seconds: 0), () => endPan(e));
    }
  }

  bool get pannalbe => ext.getValue(properties, 'pannable', false);
  void set pannable (bool value) => ext.setValue(properties, 'pannalbe', value);

  bool get isPanning => _inPanning;

  Stream<MouseEvent> get onPanStart => _panStartController.stream;
  Stream<MouseEvent> get onPanning => _panningController.stream;
  Stream<MouseEvent> get onPanEnd => _panningController.stream;
}

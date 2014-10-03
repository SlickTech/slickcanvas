import 'dart:html' as dom hide Text;
import 'package:smartcanvas/smartcanvas.dart';

class GridLayer extends Layer {
  Rect _grid;
  Line _axisX;
  Line _axisY;
  num _deltaX = 0, _deltaY = 0;

  SCPattern _gridPattern = new SCPattern({
    ID: '_grid_pattern',
    WIDTH: gridSize,
    HEIGHT: gridSize,
    PATTERN_UNITS: "userSpaceOnUse"
  });

  Path _gridPatternLine = new Path({
    D: 'M${gridSize} 0L0 0 0 ${gridSize}',
    FILL: 'none',
    STROKE: 'gray',
    STROKE_WIDTH: 0.5
  });

  GridLayer(Map<String, dynamic> config): super(svg, config) {
    _gridPattern.addChild(_gridPatternLine);

    _grid = new Rect({
      WIDTH: width,
      HEIGHT: height,
      FILL: _gridPattern
    });

    this.addChild(_grid);

    this.on('widthChanged', (newValue) {
      _grid.width = newValue;
    });

    this.on('heightChanged', (newValue) {
      _grid.height = newValue;
    });

    this.on('stageSet', _onStageSet);
  }

  void _onStageSet() {
    _axisX = new Line({
      X1: 0,
      Y1: 0,
      X2: stage.width,
      Y2: 0,
      STROKE: 'gray',
      STROKE_WIDTH: 1
    });

    _axisY = new Line({
      X1: 0,
      Y1: 0,
      X2: 0,
      Y2: stage.height,
      STROKE: 'gray',
      STROKE_WIDTH: 1
    });

    this.addChild(_axisX);
    this.addChild(_axisY);

    this.stage
      .on('widthChanged', (newValue){ _axisX.x2 = newValue; })
      .on('heightChanged', (newValue) { _axisY.y2 = newValue; })
      .on('translateXChanged', _onStageTranslateXChanged)
      .on('translateYChanged', _onStageTranslateYChanged)
      .on('scaleXChanged', _onStageScaleXChanged)
      .on('scaleYChanged', _onStageScaleYChanged);
  }

  void _onStageTranslateXChanged(newValue) {
    _grid.x = -newValue;
    _deltaX = newValue % gridSize;
    _gridPatternLine.d = 'M0 ${_deltaY}L${gridSize} ${_deltaY}M${_deltaX} 0L${_deltaX} ${gridSize}';
    _axisX.x = -newValue;
  }

  void _onStageTranslateYChanged(newValue) {
    _grid.y = -newValue;
    _deltaY = newValue % gridSize;
    _gridPatternLine.d = 'M0 ${_deltaY}L${gridSize} ${_deltaY}M${_deltaX} 0L${_deltaX} ${gridSize}';
    _axisY.y = -newValue;
  }

  void _onStageScaleXChanged(newValue) {
    num newWidth = this.width / newValue;
    _grid.width = newWidth;
    _axisX.x2 = newWidth;
  }

  void _onStageScaleYChanged(newValue) {
    num newHeight = this.height / newValue;
    _grid.height = newHeight;
    _axisY.y2 = newHeight;
  }

  static const int gridSize = 25;
}

void main() {
  dom.Element container = dom.document.querySelector("#smart_canvas");
  Stage stage = new Stage(container, svg, {});
  bool _drawing = false;
  Position _lastPosition;
  bool _panning = false;

  stage.addChild(new GridLayer({}));
  Layer _drawingLayer = new Layer(svg, {});
  stage.addChild(_drawingLayer);

  stage.on('stageMouseDown', (e) {
    if (_panning == false) {
      _drawing = true;
    }
  });

  stage.on('stageMouseUp', (e) {
    _drawing = false;
    _lastPosition = null;
  });

  stage.on('stageMouseMove', (e) {
    if (_drawing) {
      if (_lastPosition != null) {
        var line = new Line({
          X1: _lastPosition.x,
          Y1: _lastPosition.y,
          X2: stage.pointerPosition.x,
          Y2: stage.pointerPosition.y,
          STROKE: 'black',
          STROKE_WIDTH: 2
        });
        _drawingLayer.addChild(line);
      }
      _lastPosition = new Position(
        x: stage.pointerPosition.x,
        y: stage.pointerPosition.y
      );
    }
  });

  dom.document.onKeyDown.listen((e) {
    if (e.keyCode == 32 && _drawing == false) {
      _panning = true;
      stage.draggable = true;
    }
  });

  dom.document.onKeyUp.listen((e) {
    if(e.keyCode == 32) {
      _panning = false;
      stage.draggable = false;
    }
  });

  Function _zoom = (num zoomAmount) {
    num oldScale = stage.scaleX,
    newScale = ((oldScale + zoomAmount) * 100).round() / 100;

    if ((zoomAmount > 0 && oldScale == 1) ||
        (zoomAmount < 0 && oldScale == 0.15) ||
        newScale == oldScale) {
        return;
    }

    if (newScale > 1) {
        newScale = 1;
    } else if (newScale < 0.15) {
        newScale = 0.15;
    }

    var x = stage.pointerPosition.x;
    var y = stage.pointerPosition.y;
    print("${stage.translateX}, ${stage.translateY} : ${stage.pointerPosition.x}, ${stage.pointerPosition.y}");
    stage.scale = newScale;
    print("** ${stage.translateX}, ${stage.translateY} : ${stage.pointerPosition.x}, ${stage.pointerPosition.y}");

    stage.translateX += stage.pointerPosition.x - x;
    stage.translateY += stage.pointerPosition.y - y;

    print("*** ${stage.translateX}, ${stage.translateY} : ${stage.pointerPosition.x}, ${stage.pointerPosition.y}");
    //    stage.translateX = stage.pointerPosition.x - stage.pointerPosition.x * newScale;
//    stage.translateY = stage.pointerPosition.y - stage.pointerPosition.y * newScale;

//    stage.translateX = stage.translateX * (2 - newScale) / (2 - oldScale);
//    stage.translateY = stage.translateY * (2 - newScale) / (2 - oldScale);
  };

  dom.document.onMouseWheel.listen((e) {
    var zoomAmount = -e.deltaY * 0.001;
    _zoom(zoomAmount);
  });
}

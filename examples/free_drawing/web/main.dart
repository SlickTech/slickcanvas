// Copyright (c) 2017, kzhdev. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' as dom hide Text;
import 'package:slickcanvas_view/view.dart';
import 'package:slickcanvas_svg/svg.dart';

//class GridLayer extends Layer {
//  Rect _grid;
//  Line _axisX;
//  Line _axisY;
//  num _deltaX = 0, _deltaY = 0;
//
//  SCPattern _gridPattern = new SCPattern({
//    ID: '_grid_pattern',
//    WIDTH: gridSize,
//    HEIGHT: gridSize,
//    PATTERN_UNITS: "userSpaceOnUse"
//  });
//
//  Path _gridPatternLine = new Path({
//    D: 'M${gridSize} 0L0 0 0 ${gridSize}',
//    FILL: 'none',
//    STROKE: 'gray',
//    STROKE_WIDTH: 0.5
//  });
//
//  GridLayer(Map<String, dynamic> config): super(CanvasType.svg, config) {
//    _gridPattern.addChild(_gridPatternLine);
//
//    _grid = new Rect({
//      WIDTH: width,
//      HEIGHT: height,
//      FILL: _gridPattern
//    });
//
//    this.addChild(_grid);
//
//    this.on('widthChanged', (newValue) {
//      _grid.width = newValue;
//    });
//
//    this.on('heightChanged', (newValue) {
//      _grid.height = newValue;
//    });
//
//    this.on('stageSet', _onStageSet);
//  }
//
//  void _onStageSet() {
//    _axisX = new Line({
//      X1: 0,
//      Y1: 0,
//      X2: stage.width,
//      Y2: 0,
//      STROKE: 'gray',
//      STROKE_WIDTH: 1
//    });
//
//    _axisY = new Line({
//      X1: 0,
//      Y1: 0,
//      X2: 0,
//      Y2: stage.height,
//      STROKE: 'gray',
//      STROKE_WIDTH: 1
//    });
//
//    this.addChild(_axisX);
//    this.addChild(_axisY);
//
//    this.stage
//      ..on('widthChanged', (newValue){ _axisX.x2 = newValue; })
//      ..on('heightChanged', (newValue) { _axisY.y2 = newValue; })
//      ..on(translateChanged, _onStageTranslateChanged)
//      ..on(scaleXChanged, _onStageScaleXChanged)
//      ..on(scaleYChanged, _onStageScaleYChanged)
//      ..on(scaleChanged, _onStageScaleChange);
//  }
//
//  void _onStageTranslateChanged(num newTx, num newTy) {
//    _grid.x = -newTx;
//    _grid.y = -newTy;
//
//    _deltaX = newTx % gridSize;
//    _deltaY = newTy % gridSize;
//
//    _gridPatternLine.d = 'M0 ${_deltaY}L${gridSize} ${_deltaY}M${_deltaX} 0L${_deltaX} ${gridSize}';
//
//    _axisX.x = -newTx;
//    _axisY.y = -newTy;
//  }
//
//  void _onStageScaleChange(num newScaleX, num newScaleY) {
//    _onStageScaleXChanged(newScaleX);
//    _onStageScaleYChanged(newScaleY);
//  }
//
//  void _onStageScaleXChanged(num newValue) {
//    num newWidth = this.width / newValue;
//    _grid.width = newWidth;
//    _axisX.x2 = newWidth;
//  }
//
//  void _onStageScaleYChanged(num newValue) {
//    num newHeight = this.height / newValue;
//    _grid.height = newHeight;
//    _axisY.y2 = newHeight;
//  }
//
//  static const int gridSize = 25;
//}

void main() {
  dom.Element container = dom.document.querySelector("#canvas_container");
  Stage stage = new Stage(container);
  bool _drawing = false;
  Position _lastPosition;
  bool _panning = false;

//  Layer _gridLayer = new GridLayer({});
  Layer _drawingLayer = new SvgLayer();

//  stage.addChild(_gridLayer);
  stage.addLayer(_drawingLayer);

//  stage.on('stageMouseDown', (e) {
//    if (_panning == false) {
//      _drawing = true;
//    }
//  });
//
//  stage.on('stageMouseUp', (e) {
//    _drawing = false;
//    _lastPosition = null;
//  });
//
//  stage.on('stageMouseMove', (e) {
//    if (_drawing) {
//      if (_lastPosition != null) {
//        var line = new Line({
//          X1: _lastPosition.x,
//          Y1: _lastPosition.y,
//          X2: stage.pointerPosition.x,
//          Y2: stage.pointerPosition.y,
//          STROKE: 'black',
//          STROKE_WIDTH: 2
//        });
//        _drawingLayer.addChild(line);
//      }
//      _lastPosition = new Position(
//        x: stage.pointerPosition.x,
//        y: stage.pointerPosition.y
//      );
//    }
//  });

  dom.document.onKeyDown.listen((e) {
    if (e.keyCode == 32 && _drawing == false) {
      _panning = true;
      stage.pannable = true;
    }
  });

  dom.document.onKeyUp.listen((e) {
    if(e.keyCode == 32) {
      _panning = false;
      stage.pannable = false;
    }
  });

//  Function _zoom = (num zoomAmount) {
//    num oldScale = stage.scaleX,
//    newScale = ((oldScale + zoomAmount) * 100).round() / 100;
//
//    if ((zoomAmount > 0 && oldScale == 1) ||
//        (zoomAmount < 0 && oldScale == 0.15) ||
//        newScale == oldScale) {
//        return;
//    }
//
//    if (newScale > 2) {
//        newScale = 1;
//    } else if (newScale < 0.15) {
//        newScale = 0.15;
//    }
//
//    // cache current pointer position
//    var x = stage.pointerPosition.x;
//    var y = stage.pointerPosition.y;
//
//    _gridLayer.suspend();
//    _drawingLayer.suspend();
//
//    stage.scale(newScale, newScale);
//
//    // scale at pointer position;
//    stage.translate(
//      stage.translateX + stage.pointerPosition.x - x,
//      stage.translateY + stage.pointerPosition.y - y
//    );
//
//    _gridLayer.resume();
//    _drawingLayer.resume();
//  };

//  dom.document.onMouseWheel.listen((e) {
//    var zoomAmount = -e.deltaY * 0.001;
//    _zoom(zoomAmount);
//  });
}


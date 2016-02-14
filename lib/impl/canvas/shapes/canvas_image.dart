part of smartcanvas.canvas;

class CanvasImage extends CanvasGraphNode {
  dom.ImageElement _image;
  bool _imageReady = false;

  final List<Function> _pendingDrawings = [];

  CanvasImage(Image shell)
    : super(shell)
    , _image = new dom.ImageElement(src: shell.href) {

    _image.onLoad.listen((e) {
      _imageReady = true;
      _pendingDrawings.forEach((func) => func());
      _pendingDrawings.clear();
    });
  }

  @override
  void _drawGraph(dom.CanvasRenderingContext2D context) {
    if (_imageReady) {
      context.drawImage(_image, 0, 0);
//      context.drawImage(_image, _image.clientWidth, _image.clientHeight);
//      context.drawImageScaled(_image, 0, 0, _image.clientWidth / dom.window.devicePixelRatio,
//          _image.clientHeight / dom.window.devicePixelRatio);
    } else {
      _pendingDrawings.add(() {
        context.drawImage(_image, 0, 0);
//        context.drawImage(_image, _image.clientWidth, _image.clientHeight);
//        context.drawImageScaled(_image, 0, 0, _image.clientWidth / dom.window.devicePixelRatio,
//          _image.clientHeight / dom.window.devicePixelRatio);
      });
    }
  }
}

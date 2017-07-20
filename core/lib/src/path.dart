import 'graph_node.dart';
import 'package:svgpath/svgpath.dart';

class Path extends GraphNode {
  BoundingBox _bbox;

  Path([Map<String, dynamic> prop = const {}]) : super(prop) {
    properties.changes.listen((changes) {
      for (MapChangeRecord<String, dynamic> change in changes) {
        if (change.key == 'd' || change.key == 'matrix') {
          _bbox = null;
          break;
        }
      }
    });
  }

  @override
  Path clone([Map<String, dynamic> propertiesOverride]) =>
      new Path(cloneProperties(propertiesOverride));

//  @override
//  NodeImpl _createSvgImpl([bool isReflection = false]) {
//    if (isReflection) {
//      return new SvgPath(this, isReflection);
//    } else if (_svgImpl == null) {
//      _svgImpl = new SvgPath(this, isReflection);
//    }
//    return _svgImpl;
//  }
//
//  @override
//  NodeImpl _createCanvasImpl() => new CanvasPath(this);

  @override
  BoundingBox get bbox {
    if (_bbox != null) {
      return _bbox;
    }

    _bbox = new SvgPath(d).transform(matrix.toString()).boundingBox;
    return _bbox;
  }

  void set d(String value) => setProperty('d', value);
  String get d => getProperty('d');
}

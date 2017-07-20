library slickcanvs.core;


export 'package:observable/observable.dart';
export 'package:svgpath/src/matrix.dart';

export 'src/position.dart';
export 'src/group.dart';

export 'src/circle.dart';
export 'src/ellipse.dart';
export 'src/rect.dart';

typedef num MeasureText(String font, String text);

MeasureText measureText;

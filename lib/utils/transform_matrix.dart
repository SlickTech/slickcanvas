part of smartcanvas;

class TransformMatrix {
  List<num> matrix = [1, 0, 0, 0, 1, 0, 0, 0, 1];
  TransformMatrix({num scale_x: 1, num scale_y: 1, num skew_x: 0, num skew_y: 0, num translate_x: 0, num translate_y: 0}) {
    matrix[0] = scale_x;
    matrix[4] = scale_y;
    matrix[3] = skew_x;
    matrix[1] = skew_y;
    matrix[2] = translate_x;
    matrix[5] = translate_y;
  }

  void set scaleX(num value) { matrix[0] = value; }
  num get scaleX => matrix[0];

  void set scaleY(num value) { matrix[4] = value; }
  num get scaleY => matrix[4];

  void set skewX(num value) { matrix[3] = value; }
  num get skewX => matrix[3];

  void set skewY(num value) { matrix[1] = value; }
  num get skewY => matrix[1];

  void set translateX(num value) { matrix[2] = value; }
  num get translateX => matrix[2];

  void set translateY(num value) { matrix[5] = value; }
  num get translateY => matrix[5];

  void set m11(num value) { matrix[0] = value; }
  num get m11 => matrix[0];

  void set m12(num value) { matrix[3] = value; }
  num get m12 => matrix[3];

  void set m21(num value) { matrix[1] = value; }
  num get m21 => matrix[3];

  void set m22(num value) { matrix[4] = value; }
  num get m22 => matrix[4];

  void set dx(num value) { matrix[2] = value; }
  num get dx => matrix[2];

  void set dy(num value) { matrix[5] = value; }
  num get dy => matrix[5];

  void set a(num value) { matrix[0] = value; }
  num get a => matrix[0];

  void set b(num value) { matrix[3] = value; }
  num get b => matrix[3];

  void set c(num value) { matrix[1] = value; }
  num get c => matrix[1];

  void set d(num value) { matrix[4] = value; }
  num get d => matrix[4];

  void set e(num value) { matrix[2] = value; }
  num get e => matrix[2];

  void set f(num value) { matrix[5] = value; }
  num get f => matrix[5];
}
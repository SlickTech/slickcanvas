class ChangeInfo {
  final dynamic oldValue;
  final dynamic newValue;

  ChangeInfo(this.oldValue, this.newValue);
}

class PointChangeInfo {
  final num oldX;
  final num oldY;
  final num newX;
  final num newY;

  PointChangeInfo(
      this.oldX, this.oldY, this.newX, this.newY);
}

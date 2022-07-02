import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  double value;
  bool isTemp;
  CircleProgress(this.value, this.isTemp);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    int max = isTemp ? 50 : 100;

    Paint outerCircle = Paint()
      ..strokeWidth = 14
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    Paint tempArc = Paint()
      ..strokeWidth = 14
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint HumidityArc = Paint()
      ..strokeWidth = 14
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 14;
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (value / max);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, isTemp ? tempArc : HumidityArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
  }
}

import 'package:flutter/material.dart';

class CustomTrackShape extends RenderBox {
  final TextPainter textPainter = TextPainter();

  @override
  void paint(PaintingContext context, Offset offset) {
    _drawText(context, offset, false);
  }

  void _drawText(PaintingContext context, Offset center, bool isInactive) {
    final TextSpan textSpan = TextSpan(
        text: 'text',
        style: TextStyle(
          fontSize: 14,
          color: Colors.red,
        ) /*isInactive
          ? themeData.inactiveLabelStyle
          : themeData.activeLabelStyle,*/
        );
    textPainter.text = textSpan;
    textPainter.layout();
    textPainter.paint(
        context.canvas, Offset(center.dx - textPainter.width / 2, center.dy));
  }
}

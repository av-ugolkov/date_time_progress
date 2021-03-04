import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomThumbShape extends SliderComponentShape {
  const CustomThumbShape();

  static const double _thumbSize = 4;
  static const double _disabledThumbSize = 3;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final size = _thumbSize * sizeTween.evaluate(enableAnimation);
    final thumbPath = _downTriangle(size, thumbCenter + Offset(0, -5));
    canvas.drawPath(
      thumbPath,
      Paint()..color = colorTween.evaluate(enableAnimation),
    );

    final slideUpTween = Tween<double>(
      begin: 0,
      end: 0,
    );
    final slideUpOffset =
        Offset(0, -slideUpTween.evaluate(activationAnimation));
    labelPainter.paint(
      canvas,
      thumbCenter +
          slideUpOffset +
          Offset(-labelPainter.width / 2, -labelPainter.height - 16),
    );
  }

  Path _triangle(double size, Offset thumbCenter, {bool invert = false}) {
    final thumbPath = Path();
    final height = math.sqrt(3) / 2;
    final centerHeight = size * height / 3;
    final halfSize = size / 2;
    final sign = invert ? -1 : 1;
    thumbPath.moveTo(
        thumbCenter.dx - halfSize, thumbCenter.dy + 2 * sign * centerHeight);
    thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - sign * centerHeight);
    thumbPath.lineTo(
        thumbCenter.dx + halfSize, thumbCenter.dy + 2 * sign * centerHeight);
    thumbPath.close();
    return thumbPath;
  }

  Path _downTriangle(double size, Offset thumbCenter) {
    return _triangle(size, thumbCenter, invert: true);
  }
}

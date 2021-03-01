import 'dart:math' as math;
import 'package:flutter/material.dart';

Path _triangle(double size, Offset thumbCenter, {bool invert = false}) {
  final thumbPath = Path();
  final height = math.sqrt(3) / 2;
  final centerHeight = size * height / 3;
  final halfSize = size / 2;
  final sign = invert ? -1 : 1;
  thumbPath.moveTo(
      thumbCenter.dx - halfSize, thumbCenter.dy + sign * centerHeight);
  thumbPath.lineTo(thumbCenter.dx, thumbCenter.dy - 2 * sign * centerHeight);
  thumbPath.lineTo(
      thumbCenter.dx + halfSize, thumbCenter.dy + sign * centerHeight);
  thumbPath.close();
  return thumbPath;
}

Path _downTriangle(double size, Offset thumbCenter) {
  return _triangle(size, thumbCenter, invert: false);
}

Path _upTriangle(double size, Offset thumbCenter) {
  return _triangle(size, thumbCenter, invert: true);
}

class CustomProgress extends StatefulWidget {
  @override
  _CustomProgressState createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgress> with RestorationMixin {
  final RestorableDouble _continuousStartCustomValue = RestorableDouble(0);
  final RestorableDouble _continuousEndCustomValue = RestorableDouble(160);
  final RestorableDouble _discreteCustomValue = RestorableDouble(20);

  @override
  String get restorationId => 'custom_sliders_demo';

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    registerForRestoration(
        _continuousStartCustomValue, 'continuous_start_custom_value');
    registerForRestoration(
        _continuousEndCustomValue, 'continuous_end_custom_value');
    registerForRestoration(_discreteCustomValue, 'discrete_custom_value');
  }

  @override
  void dispose() {
    _continuousStartCustomValue.dispose();
    _continuousEndCustomValue.dispose();
    _discreteCustomValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SliderTheme(
        data: theme.sliderTheme.copyWith(
          trackHeight: 2,
          activeTrackColor: Colors.deepPurple,
          inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.5),
          activeTickMarkColor: theme.colorScheme.onSurface.withOpacity(0.7),
          inactiveTickMarkColor: theme.colorScheme.surface.withOpacity(0.7),
          overlayColor: theme.colorScheme.onSurface.withOpacity(0.12),
          thumbColor: Colors.deepPurple,
          valueIndicatorColor: Colors.deepPurpleAccent,
          thumbShape: const _CustomThumbShape(),
          valueIndicatorShape: const _CustomValueIndicatorShape(),
          valueIndicatorTextStyle: theme.accentTextTheme.bodyText1
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        child: Slider(
          value: _discreteCustomValue.value,
          min: 0,
          max: 200,
          divisions: 5,
          semanticFormatterCallback: (value) => value.round().toString(),
          label: '${_discreteCustomValue.value.round()}',
          onChanged: (value) {
            setState(() {
              _discreteCustomValue.value = value;
            });
          },
        ),
      ),
    );
  }
}

class _CustomThumbShape extends SliderComponentShape {
  const _CustomThumbShape();

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
    final thumbPath = _downTriangle(size, thumbCenter);
    canvas.drawPath(
      thumbPath,
      Paint()..color = colorTween.evaluate(enableAnimation),
    );
  }
}

class _CustomValueIndicatorShape extends SliderComponentShape {
  const _CustomValueIndicatorShape();

  static const double _indicatorSize = 4;
  static const double _disabledIndicatorSize = 3;
  static const double _slideUpHeight = 20;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled ? _indicatorSize : _disabledIndicatorSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledIndicatorSize,
    end: _indicatorSize,
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
    final enableColor = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.valueIndicatorColor,
    );
    final slideUpTween = Tween<double>(
      begin: 0,
      end: _slideUpHeight,
    );
    final size = _indicatorSize * sizeTween.evaluate(enableAnimation);
    final slideUpOffset =
        Offset(0, -slideUpTween.evaluate(activationAnimation));
    final thumbPath = _upTriangle(size, thumbCenter + slideUpOffset);
    final paintColor = enableColor
        .evaluate(enableAnimation)
        .withAlpha((255 * activationAnimation.value).round());
    canvas.drawPath(
      thumbPath,
      Paint()..color = paintColor,
    );
    canvas.drawLine(
        thumbCenter,
        thumbCenter + slideUpOffset,
        Paint()
          ..color = paintColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    labelPainter.paint(
      canvas,
      thumbCenter +
          slideUpOffset +
          Offset(-labelPainter.width / 2, -labelPainter.height - 4),
    );
  }
}

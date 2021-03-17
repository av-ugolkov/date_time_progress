import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

enum TimeLabelLocation {
  below,
  sides,
}

class DateTimeProgress extends LeafRenderObjectWidget {
  final DateTime start;
  final DateTime finish;
  final DateTime current;
  final double barHeight;
  final Color? thumbColor;
  final Color? baseBarColor;
  final Color? progressBarColor;
  final Color? disableBarColor;
  final TextStyle? textStyle;
  final String locale;
  final String typeDateFormate;

  DateTimeProgress({
    Key? key,
    required this.start,
    required this.finish,
    required this.current,
    this.barHeight = 4,
    this.thumbColor,
    this.baseBarColor,
    this.progressBarColor,
    this.disableBarColor,
    this.textStyle,
    this.locale = 'en_US',
    this.typeDateFormate = DateFormat.YEAR_NUM_MONTH_DAY,
  }) : super(key: key);

  @override
  _RenderDateTimeProgress createRenderObject(BuildContext context) {
    final theme = Theme.of(context);
    final themeThumbColor = theme.colorScheme.primary;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final bodyText1 = theme.textTheme.bodyText1;

    return _RenderDateTimeProgress(
        start: start,
        finish: finish,
        current: current,
        barHeight: barHeight,
        thumbColor: thumbColor ?? themeThumbColor,
        baseBarColor: baseBarColor ?? primaryColor.withOpacity(.5),
        progressBarColor: progressBarColor ?? primaryColor,
        disableBarColor: disableBarColor ?? secondaryColor,
        timeLabelTextStyle: textStyle ?? bodyText1);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDateTimeProgress renderObject) {
    final theme = Theme.of(context);
    final themeThumbColor = theme.colorScheme.primary;
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final bodyText1 = theme.textTheme.bodyText1;

    renderObject
      ..start = start
      ..finish = finish
      ..current = current
      ..barHeight = barHeight
      ..thumbColor = thumbColor ?? themeThumbColor
      ..baseBarColor = baseBarColor ?? primaryColor.withOpacity(.5)
      ..progressBarColor = progressBarColor ?? primaryColor
      ..disableBarColor = disableBarColor ?? secondaryColor
      ..timeLabelTextStyle = textStyle ?? bodyText1;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

class _RenderDateTimeProgress extends RenderBox {
  DateTime _start;
  DateTime get start => _start;
  set start(DateTime value) {
    if (_start == value) return;
    _start = value;
    markNeedsPaint();
  }

  DateTime _finish;
  DateTime get finish => _finish;
  set finish(DateTime value) {
    if (_finish == value) return;
    _finish = value;
    markNeedsPaint();
  }

  DateTime _current;
  DateTime get current => _current;
  set current(DateTime value) {
    if (_current == value) return;
    _current = value;
    markNeedsPaint();
  }

  TextStyle? get timeLabelTextStyle => _timeLabelTextStyle;
  TextStyle? _timeLabelTextStyle;
  set timeLabelTextStyle(TextStyle? value) {
    if (_timeLabelTextStyle == value) return;
    _timeLabelTextStyle = value;
    markNeedsLayout();
  }

  Color _thumbColor;
  Color get thumbColor => _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double _barHeight;
  double get barHeight => _barHeight;
  set barHeight(double value) {
    if (_barHeight == value) return;
    _barHeight = value;
    markNeedsLayout();
  }

  Color _baseBarColor;
  Color get baseBarColor => _baseBarColor;
  set baseBarColor(Color value) {
    if (_baseBarColor == value) return;
    _baseBarColor = value;
    markNeedsPaint();
  }

  Color _progressBarColor;
  Color get progressBarColor => _progressBarColor;
  set progressBarColor(Color value) {
    if (_progressBarColor == value) return;
    _progressBarColor = value;
    markNeedsPaint();
  }

  Color _disableBarColor;
  Color get disableBarColor => _disableBarColor;
  set disableBarColor(Color value) {
    if (_disableBarColor == value) return;
    _disableBarColor = value;
    markNeedsPaint();
  }

  _RenderDateTimeProgress(
      {required DateTime start,
      required DateTime finish,
      required DateTime current,
      required Color thumbColor,
      required double barHeight,
      required Color baseBarColor,
      required Color progressBarColor,
      required Color disableBarColor,
      TextStyle? timeLabelTextStyle})
      : _start = start,
        _finish = finish,
        _current = current,
        _thumbColor = thumbColor,
        _barHeight = barHeight,
        _baseBarColor = baseBarColor,
        _progressBarColor = progressBarColor,
        _disableBarColor = disableBarColor,
        _timeLabelTextStyle = timeLabelTextStyle;

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = 10.0;
    final size = Size(width, height);
    return constraints.constrain(size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    _paintLine(canvas);
    _paintThumb(canvas);
    _paintLabel(canvas);

    canvas.restore();
  }

  void _paintLine(Canvas canvas) {
    final linePaint = Paint()
      ..color = _baseBarColor
      ..strokeWidth = _barHeight;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);

    canvas.drawLine(point1, point2, linePaint);
  }

  void _paintThumb(Canvas canvas) {
    final triPaint = Paint()..color = _thumbColor;

    final sizeTri = 20.0;
    canvas.drawPath(
        _triangle(
            sizeTri, Offset(size.width / 2, size.height / 2 - sizeTri / 3.5),
            invert: true),
        triPaint);
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

  void _paintLabel(Canvas canvas) {
    var labelPainter = _layoutText('canvas');
    labelPainter.paint(canvas,
        Offset(size.width / 2 - labelPainter.width / 2, size.height / 2));
  }

  TextPainter _layoutText(String text) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: _timeLabelTextStyle),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter;
  }
}

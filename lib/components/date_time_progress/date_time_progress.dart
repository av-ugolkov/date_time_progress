import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_components/settings.dart';
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
  final Function? onChangeStart;
  final Function? onChangeFinish;
  final double barHeight;
  final Color? thumbColor;
  final Color? baseBarColor;
  final Color? progressBarColor;
  final TextStyle? textStyle;
  final String dateFormatePattern;

  DateTimeProgress({
    Key? key,
    required this.start,
    required this.finish,
    required this.current,
    this.onChangeStart,
    this.onChangeFinish,
    this.barHeight = 4,
    this.thumbColor,
    this.baseBarColor,
    this.progressBarColor,
    this.textStyle,
    this.dateFormatePattern = DateFormat.YEAR_NUM_MONTH_DAY,
  }) : super(key: key);

  @override
  _RenderDateTimeProgress createRenderObject(BuildContext context) {
    final theme = Theme.of(context);

    final themeThumbColor = theme.colorScheme.primary;
    final primaryColor = theme.colorScheme.primary;
    final bodyText1 = theme.textTheme.bodyText1;
    return _RenderDateTimeProgress(
        start: start,
        finish: finish,
        onChangeStart: onChangeStart,
        onChangeFinish: onChangeFinish,
        current: current,
        barHeight: barHeight,
        thumbColor: thumbColor ?? themeThumbColor,
        baseBarColor: baseBarColor ?? primaryColor.withOpacity(.5),
        progressBarColor: progressBarColor ?? primaryColor,
        timeLabelTextStyle: textStyle ?? bodyText1,
        dateFormatePattern: dateFormatePattern);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDateTimeProgress renderObject) {
    final theme = Theme.of(context);
    final themeThumbColor = theme.colorScheme.primary;
    final primaryColor = theme.colorScheme.primary;
    final bodyText1 = theme.textTheme.bodyText1;

    renderObject
      ..start = start
      ..finish = finish
      ..current = current
      ..barHeight = barHeight
      ..thumbColor = thumbColor ?? themeThumbColor
      ..baseBarColor = baseBarColor ?? primaryColor.withOpacity(.5)
      ..progressBarColor = progressBarColor ?? primaryColor
      ..timeLabelTextStyle = textStyle ?? bodyText1
      ..dateFormatePattern = dateFormatePattern;
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

  double get _valueProgress {
    final duration =
        finish.microsecondsSinceEpoch - start.microsecondsSinceEpoch;
    final progress =
        current.microsecondsSinceEpoch - start.microsecondsSinceEpoch;
    final value = progress / duration;
    return value;
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

  late DateFormat _dateFormat;

  String _dateFormatePattern;
  String get dateFormatePattern => _dateFormatePattern;
  set dateFormatePattern(String value) {
    if (_dateFormatePattern == value) return;
    _dateFormatePattern = value;
    _dateFormat = DateFormat(_dateFormatePattern, appLocale.toString());
    markNeedsLayout();
  }

  late TapGestureRecognizer _tap;
  Function? _onChangeStart;
  Function? _onChangeFinish;

  _RenderDateTimeProgress(
      {required DateTime start,
      required DateTime finish,
      Function? onChangeStart,
      Function? onChangeFinish,
      required DateTime current,
      required Color thumbColor,
      required double barHeight,
      required Color baseBarColor,
      required Color progressBarColor,
      TextStyle? timeLabelTextStyle,
      required String dateFormatePattern})
      : _start = start,
        _finish = finish,
        _current = current,
        _onChangeStart = onChangeStart,
        _onChangeFinish = onChangeFinish,
        _thumbColor = thumbColor,
        _barHeight = barHeight,
        _baseBarColor = baseBarColor,
        _progressBarColor = progressBarColor,
        _timeLabelTextStyle = timeLabelTextStyle,
        _dateFormatePattern = dateFormatePattern {
    _dateFormat = DateFormat(_dateFormatePattern, appLocale.toString());

    _tap = TapGestureRecognizer()..onTap = _onTap;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _tap.addPointer(event);
    }
  }

  void _onTap() {
    Offset startPos = Offset(0, 0);
    Offset finishPos = Offset(100, 50);
    var initPos = _tap.initialPosition;
    if (initPos != null &&
        startPos.dx < initPos.local.dx &&
        finishPos.dx > initPos.local.dx &&
        startPos.dy < initPos.local.dy &&
        finishPos.dy > initPos.local.dy) {
      _onChangeStart?.call();
    } else {
      _onChangeFinish?.call();
    }
  }

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

    _paintBar(canvas);
    _paintBarProgress(canvas);
    _paintThumb(canvas);
    _paintStartLabel(canvas);
    _paintFinishLabel(canvas);

    canvas.restore();
  }

  void _paintBar(Canvas canvas) {
    final linePaint = Paint()
      ..color = _baseBarColor
      ..strokeWidth = _barHeight;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);

    canvas.drawLine(point1, point2, linePaint);
  }

  void _paintBarProgress(Canvas canvas) {
    final linePaint = Paint()
      ..color = _progressBarColor
      ..strokeWidth = _barHeight;

    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width * _valueProgress, size.height / 2);

    canvas.drawLine(point1, point2, linePaint);
  }

  void _paintThumb(Canvas canvas) {
    final triPaint = Paint()..color = _thumbColor;

    final sizeTri = 20.0;
    canvas.drawPath(
        _triangle(
            sizeTri,
            Offset(
                size.width * _valueProgress, size.height / 2 - sizeTri / 3.5),
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

  void _paintStartLabel(Canvas canvas) {
    var labelPainter = _layoutText(_dateFormat.format(start));
    labelPainter.paint(
        canvas, Offset(0 - labelPainter.width / 2, size.height / 2));
  }

  void _paintFinishLabel(Canvas canvas) {
    var labelPainter = _layoutText(_dateFormat.format(finish));
    labelPainter.paint(
        canvas, Offset(size.width - labelPainter.width / 2, size.height / 2));
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

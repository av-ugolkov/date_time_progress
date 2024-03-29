import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import '/util/animation_ticker.dart';
import '/util/extension.dart';
import 'package:intl/intl.dart';

class DateTimeProgress extends LeafRenderObjectWidget {
  final DateTime start;
  final DateTime finish;
  final DateTime current;
  final Function(DateTime)? onChange;
  final Function(DateTime)? onChanged;
  final Function(DateTime)? onChangeStart;
  final Function(DateTime)? onChangeFinish;
  final double barHeight;
  final Color? thumbColor;
  final bool showAlwaysThumb;
  final Color? baseBarColor;
  final Color? progressBarColor;
  final TextStyle? textStyle;
  final String dateFormatePattern;
  final bool roundingDate;

  const DateTimeProgress({
    Key? key,
    required this.start,
    required this.finish,
    required this.current,
    this.onChange,
    this.onChanged,
    this.onChangeStart,
    this.onChangeFinish,
    this.barHeight = 4,
    this.thumbColor,
    this.showAlwaysThumb = false,
    this.baseBarColor,
    this.progressBarColor,
    this.textStyle,
    this.dateFormatePattern = DateFormat.YEAR_NUM_MONTH_DAY,
    this.roundingDate = false,
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
        onChange: onChange,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeFinish: onChangeFinish,
        current: current,
        barHeight: barHeight,
        thumbColor: onChange != null || onChanged != null
            ? thumbColor ?? themeThumbColor
            : theme.disabledColor,
        showAlwaysThumb: showAlwaysThumb,
        baseBarColor: onChange != null || onChanged != null
            ? baseBarColor ?? primaryColor.withOpacity(.5)
            : theme.disabledColor.withOpacity(.5),
        progressBarColor: onChange != null || onChanged != null
            ? progressBarColor ?? primaryColor
            : theme.disabledColor,
        timeLabelTextStyle: textStyle ?? bodyText1!,
        dateFormatePattern: dateFormatePattern,
        roundingDate: roundingDate);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDateTimeProgress renderObject) {
    final theme = Theme.of(context);
    final themeThumbColor = theme.colorScheme.primary;
    final primaryColor = theme.colorScheme.primary;
    final bodyText1 = theme.textTheme.bodyText1;

    renderObject
      ..start = start.getDate()
      ..finish = finish.getDate()
      ..current = current
      ..onChange = onChange
      ..onChanged = onChanged
      ..onChangeStart = onChangeStart
      ..onChangeFinish = onChangeFinish
      ..barHeight = barHeight
      ..thumbColor = onChange != null || onChanged != null
          ? thumbColor ?? themeThumbColor
          : theme.disabledColor
      ..showAlwaysThumb = showAlwaysThumb
      ..baseBarColor = onChange != null || onChanged != null
          ? baseBarColor ?? primaryColor.withOpacity(.5)
          : theme.disabledColor.withOpacity(.5)
      ..progressBarColor = onChange != null || onChanged != null
          ? progressBarColor ?? primaryColor
          : theme.disabledColor
      ..timeLabelTextStyle = textStyle ?? bodyText1!
      ..dateFormatePattern = dateFormatePattern
      ..roundingDate = roundingDate;
  }
}

class _RenderDateTimeProgress extends RenderBox {
  static const double _heightBox = 55;
  static const double _offsetCentrHeight = 5;
  static const double _halfHeightBox = _heightBox / 2 + _offsetCentrHeight;
  static const double _sizeTri = 15;
  static const double _halfSizeTri = _sizeTri / 2;

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
    if (current.isBefore(start)) return 0;
    if (current.isAfter(finish)) return 1;
    final duration = finish.difference(start).inSeconds;
    final progress = current.difference(start).inSeconds;
    var value = progress / duration;
    return value;
  }

  double get _sizeProgressBar => size.width - _sizeTri;

  TextStyle _timeLabelTextStyle;
  TextStyle get timeLabelTextStyle => _timeLabelTextStyle;
  set timeLabelTextStyle(TextStyle value) {
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

  bool _showThumb = false;
  bool _showAlwaysThumb;
  bool get showAlwaysThumb => _showAlwaysThumb;
  set showAlwaysThumb(bool value) {
    if (_showAlwaysThumb == value) return;
    _showAlwaysThumb = value;
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

  bool _roundingDate;
  bool get roundingDate => _roundingDate;
  set roundingDate(bool value) {
    if (_roundingDate == value) return;
    _roundingDate = value;
    markNeedsPaint();
  }

  late DateFormat _dateFormat;

  String _dateFormatePattern;
  String get dateFormatePattern => _dateFormatePattern;
  set dateFormatePattern(String value) {
    if (_dateFormatePattern == value) return;
    _dateFormatePattern = value;
    _dateFormat = DateFormat(_dateFormatePattern);
    markNeedsLayout();
  }

  bool _startDrag = false;
  late HorizontalDragGestureRecognizer _drag;
  late TapGestureRecognizer _tap;

  Function(DateTime)? _onChange;
  Function(DateTime)? get onChange => _onChange;
  set onChange(Function(DateTime)? value) {
    if (_onChange == value) return;
    _onChange = value;
  }

  Function(DateTime)? _onChanged;
  Function(DateTime)? get onChanged => _onChanged;
  set onChanged(Function(DateTime)? value) {
    if (_onChanged == value) return;
    _onChanged = value;
  }

  Function(DateTime)? _onChangeStart;
  Function(DateTime)? get onChangeStart => _onChangeStart;
  set onChangeStart(Function(DateTime)? value) {
    if (_onChangeStart == value) return;
    _onChangeStart = value;
  }

  Function(DateTime)? _onChangeFinish;
  Function(DateTime)? get onChangeFinish => _onChangeFinish;
  set onChangeFinish(Function(DateTime)? value) {
    if (_onChangeFinish == value) return;
    _onChangeFinish = value;
  }

  late Rect _startLabel;
  late Rect _finishLabel;

  late AnimationTicker _animationTicker;
  late DateTime _animateDate;

  _RenderDateTimeProgress({
    required DateTime start,
    required DateTime finish,
    Function(DateTime)? onChange,
    Function(DateTime)? onChanged,
    Function(DateTime)? onChangeStart,
    Function(DateTime)? onChangeFinish,
    required DateTime current,
    required Color thumbColor,
    required bool showAlwaysThumb,
    required double barHeight,
    required Color baseBarColor,
    required Color progressBarColor,
    required TextStyle timeLabelTextStyle,
    required String dateFormatePattern,
    required bool roundingDate,
  })  : _start = start.getDate(),
        _finish = finish.getDate(),
        _current = current,
        _onChange = onChange,
        _onChanged = onChanged,
        _onChangeStart = onChangeStart,
        _onChangeFinish = onChangeFinish,
        _thumbColor = thumbColor,
        _showAlwaysThumb = showAlwaysThumb,
        _barHeight = barHeight,
        _baseBarColor = baseBarColor,
        _progressBarColor = progressBarColor,
        _timeLabelTextStyle = timeLabelTextStyle,
        _dateFormatePattern = dateFormatePattern,
        _roundingDate = roundingDate {
    _dateFormat = DateFormat(_dateFormatePattern);

    _animationTicker = AnimationTicker(
        durationAnimation: const Duration(milliseconds: 200),
        onChange: _animated,
        onEnd: _endAnimated);
    _tap = TapGestureRecognizer()..onTapUp = _onTapUp;
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _onDragStart
      ..onUpdate = _onDragUpdate
      ..onEnd = _onDragEnd;
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));

    if (event is PointerDownEvent) {
      _tap.addPointer(event);
      if (onChange != null || _onChanged != null) {
        _drag.addPointer(event);
      }
    }
  }

  void _onTapUp(TapUpDetails? tapUpDetails) {
    var local = tapUpDetails?.localPosition;
    if (local != null) {
      if (local.containedRect(_startLabel)) {
        _onChangeStart?.call(_start);
      } else if (local.containedRect(_finishLabel)) {
        _onChangeFinish?.call(_finish);
      }
    }
  }

  void _onDragStart(DragStartDetails details) {
    if (details.localPosition.dy < _halfHeightBox) {
      _startDrag = true;
      _showThumb = true;
      _onChangedCurrentValue(details.localPosition);
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_startDrag) {
      _onChangedCurrentValue(details.localPosition);
    }
  }

  void _onDragEnd(DragEndDetails details) {
    _animationTicker.startAnimation();
    _animateDate = current.hour > 12
        ? current.add(const Duration(days: 1)).getDate()
        : current.getDate();
  }

  void _animated(double progress) {
    final duration = _animateDate.difference(current).inSeconds;
    var changeDate =
        current.add(Duration(seconds: (duration * progress).round()));
    current = changeDate;
    _onChange?.call(_current);
  }

  void _endAnimated() {
    _showThumb = false;
    current = _animateDate.getDate();
    _onChanged?.call(_current);
    markNeedsLayout();
  }

  void _onChangedCurrentValue(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    final duration = finish.difference(start);
    final procent = dx / size.width;
    var changeDate = start.add(duration * procent);
    current = changeDate;
    _onChange?.call(roundingDate ? current.getDate() : current);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final size = Size(width, _heightBox);
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
    if (showAlwaysThumb || _showThumb) {
      _paintCurrentLabel(canvas);
    }
    canvas.restore();
  }

  void _paintBar(Canvas canvas) {
    final linePaint = Paint()
      ..color = _baseBarColor
      ..strokeWidth = _barHeight;
    const point1 = Offset(_sizeTri / 2, _halfHeightBox);
    final point2 = point1 + Offset(_sizeProgressBar, 0);

    canvas.drawLine(point1, point2, linePaint);
  }

  void _paintBarProgress(Canvas canvas) {
    final linePaint = Paint()
      ..color = _progressBarColor
      ..strokeWidth = _barHeight;

    const point1 = Offset(_sizeTri / 2, _halfHeightBox);
    final point2 = point1 + Offset(_sizeProgressBar * _valueProgress, 0);

    canvas.drawLine(point1, point2, linePaint);
  }

  void _paintThumb(Canvas canvas) {
    final triPaint = Paint()..color = _thumbColor;

    canvas.drawPath(
        _triangle(
            _sizeTri,
            Offset(_halfSizeTri + _sizeProgressBar * _valueProgress,
                _halfHeightBox)),
        triPaint);
  }

  Path _triangle(double sizeTri, Offset thumbCenter,
      {double scaleHeight = 1, bool inverse = false}) {
    final thumbPath = Path();
    final revers = inverse ? -1 : 1;
    thumbPath.moveTo(thumbCenter.dx, thumbCenter.dy);
    thumbPath.lineTo(thumbCenter.dx - _halfSizeTri,
        thumbCenter.dy - revers * sizeTri * scaleHeight);
    thumbPath.lineTo(thumbCenter.dx + _halfSizeTri,
        thumbCenter.dy - revers * sizeTri * scaleHeight);
    thumbPath.close();
    return thumbPath;
  }

  void _paintStartLabel(Canvas canvas) {
    var labelPainter = _layoutText(
        _dateFormat.format(start), _onChangeStart != null ? Colors.blue : null);
    _startLabel = _calcRect(labelPainter, const Offset(_halfSizeTri, 5));
    labelPainter.paint(canvas, _startLabel.topLeft);
  }

  void _paintFinishLabel(Canvas canvas) {
    var labelPainter = _layoutText(_dateFormat.format(finish),
        _onChangeFinish != null ? Colors.blue : null);
    _finishLabel = _calcRect(labelPainter,
        Offset(_halfSizeTri + _sizeProgressBar - labelPainter.width, 5));
    labelPainter.paint(canvas, _finishLabel.topLeft);
  }

  void _paintCurrentLabel(Canvas canvas) {
    final label =
        current.hour > 12 ? current.add(const Duration(days: 1)) : current;
    var labelPainter = _layoutText(_dateFormat.format(label), null);
    var posX = (_halfSizeTri + _sizeProgressBar * _valueProgress) -
        labelPainter.width / 2;
    if (posX < _halfSizeTri) {
      posX = _halfSizeTri;
    }
    if (posX + labelPainter.width + _halfSizeTri > size.width) {
      posX = size.width - _halfSizeTri - labelPainter.width;
    }
    _finishLabel = _calcRect(
      labelPainter,
      Offset(posX, -_sizeTri - labelPainter.height),
    );
    labelPainter.paint(canvas, _finishLabel.topLeft);
  }

  Rect _calcRect(TextPainter painter, Offset leftUp) {
    var offset = Offset(leftUp.dx, _halfHeightBox + leftUp.dy);
    return Rect.fromPoints(
        offset, offset + Offset(painter.width, painter.height));
  }

  TextPainter _layoutText(String text, Color? color) {
    TextPainter textPainter = TextPainter(
      text:
          TextSpan(text: text, style: _timeLabelTextStyle.apply(color: color)),
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter;
  }
}

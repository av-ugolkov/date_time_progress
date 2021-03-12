import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class DateTimeProgress extends LeafRenderObjectWidget {
  final DateTime start;
  final DateTime finish;
  final DateTime current;
  final double lineHeight;
  final String locale;
  final String typeDateFormate;

  DateTimeProgress({
    Key? key,
    required this.start,
    required this.finish,
    required this.current,
    this.lineHeight = 4,
    this.locale = 'en_US',
    this.typeDateFormate = DateFormat.YEAR_NUM_MONTH_DAY,
  }) : super(key: key);

  @override
  _RenderDateTimeProgress createRenderObject(BuildContext context) {
    return _RenderDateTimeProgress(
        start: start, finish: finish, current: current, lineHeight: lineHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDateTimeProgress renderObject) {}

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

  final double lineHeight;

  _RenderDateTimeProgress({
    required DateTime start,
    required DateTime finish,
    required DateTime current,
    required this.lineHeight,
  })   : _start = start,
        _finish = finish,
        _current = current;

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

    canvas.restore();
  }

  void _paintLine(Canvas canvas) {
    final line = Paint()
      ..color = Colors.blue
      ..strokeWidth = lineHeight;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);

    canvas.drawLine(point1, point2, line);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class ProgressBar extends LeafRenderObjectWidget {
  final Color barColor;
  final Color thumbColor;
  final double thumbSize;

  const ProgressBar(
      {Key? key,
      required this.barColor,
      required this.thumbColor,
      this.thumbSize = 20})
      : super(key: key);

  @override
  RenderProgressBar createRenderObject(BuildContext context) {
    return RenderProgressBar(
      barColor: barColor,
      thumbColor: thumbColor,
      thumbSize: thumbSize,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderProgressBar renderObject) {
    renderObject
      ..barColor = barColor
      ..thumbColor = thumbColor
      ..thumbSize = thumbSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('barColor', barColor));
    properties.add(ColorProperty('thumbColor', thumbColor));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}

class RenderProgressBar extends RenderBox {
  static const _minDesiredWidth = 100.0;
  static const double _semanticActionUnit = 0.05;

  double _currentThumbValue = .5;
  late HorizontalDragGestureRecognizer _drag;

  Color _barColor;
  Color get barColor => _barColor;
  set barColor(Color value) {
    if (_barColor == value) return;
    _barColor = value;
    markNeedsPaint();
  }

  Color _thumbColor;
  Color get thumbColor => _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) return;
    _thumbColor = value;
    markNeedsPaint();
  }

  double _thumbSize;
  double get thumbSize => _thumbSize;
  set thumbSize(double value) {
    if (_thumbSize == value) return;
    _thumbSize = value;
    markNeedsLayout();
  }

  RenderProgressBar({
    required Color barColor,
    required Color thumbColor,
    required double thumbSize,
  })   : _barColor = barColor,
        _thumbColor = thumbColor,
        _thumbSize = thumbSize {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final barPaint = Paint()
      ..color = barColor
      ..strokeWidth = 5;
    final point1 = Offset(0, size.height / 2);
    final point2 = Offset(size.width, size.height / 2);
    canvas.drawLine(point1, point2, barPaint);

    final thumbPaint = Paint()..color = thumbColor;
    final thumbDx = _currentThumbValue * size.width;
    final center = Offset(thumbDx, size.height / 2);
    canvas.drawCircle(center, thumbSize / 2, thumbPaint);

    canvas.restore();
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = thumbSize;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.textDirection = TextDirection.ltr;
    config.label = 'Progress bar';
    config.value = '${(_currentThumbValue * 100).round()}%';

    config.onIncrease = increaseAction;
    final increased = _currentThumbValue + _semanticActionUnit;
    config.increasedValue = '${((increased).clamp(0.0, 1.0) * 100).round()}%';

    // descrease action
    config.onDecrease = decreaseAction;
    final decreased = _currentThumbValue - _semanticActionUnit;
    config.decreasedValue = '${((decreased).clamp(0.0, 1.0) * 100).round()}%';
  }

  void increaseAction() {
    final newValue = _currentThumbValue + _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  void decreaseAction() {
    final newValue = _currentThumbValue - _semanticActionUnit;
    _currentThumbValue = (newValue).clamp(0.0, 1.0);
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _minDesiredWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _minDesiredWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return thumbSize;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return thumbSize;
  }

  @override
  bool get isRepaintBoundary => true;

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    _currentThumbValue = dx / size.width;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }
}

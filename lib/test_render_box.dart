import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_components/util/extension.dart';

class TestRenderBox extends LeafRenderObjectWidget {
  final Function(DateTime)? onChange;

  TestRenderBox({
    Key? key,
    this.onChange,
  }) : super(key: key);

  @override
  _RenderDateTimeProgress createRenderObject(BuildContext context) {
    return _RenderDateTimeProgress(onChange: onChange);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderDateTimeProgress renderObject) {
    renderObject..onChange = onChange;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
  }
}

class _RenderDateTimeProgress extends RenderBox {
  late TapGestureRecognizer _tap;
  late HorizontalDragGestureRecognizer _drag;

  bool _startDrag = false;

  Function(DateTime)? _onChange;
  Function(DateTime)? get onChange => _onChange;
  set onChange(Function(DateTime)? value) {
    if (_onChange == value) return;
    _onChange = value;
  }

  _RenderDateTimeProgress({
    Function(DateTime)? onChange,
  }) : _onChange = onChange {
    _tap = TapGestureRecognizer()..onTap = _onTap;
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
      if (onChange != null) {
        _drag.addPointer(event);
      }
    }
  }

  void _onTap() {
    var initPos = _tap.initialPosition;
    print(initPos);
    if (initPos != null) {
      if (initPos.local.containedRect(Rect.fromPoints(Offset(0, 0), Offset(200, 200)))) {
        _onChange?.call(DateTime.now());
      }
    }
  }

  void _onDragStart(DragStartDetails details) {
    if (details.localPosition.dy < 200) {
      _startDrag = true;
      print('_onDragStart');
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_startDrag) {
      print('_onDragUpdate');
    }
  }

  void _onDragEnd(DragEndDetails details) {
    print('_onDragEnd');
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final height = 100.0;
    final size = Size(width, height);
    return constraints.constrain(size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    print('Test: $offset');

    _paintThumb(canvas);
    canvas.restore();
  }

  void _paintThumb(Canvas canvas) {
    final triPaint = Paint()..color = Colors.red;

    canvas.drawPath(_square(200, Offset(0, 0)), triPaint);
  }

  Path _square(double halfSizeSquare, Offset center, {double scale = 1}) {
    final thumbPath = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx + halfSizeSquare, center.dy)
      ..lineTo(center.dx + halfSizeSquare, center.dy + halfSizeSquare)
      ..lineTo(center.dx, center.dy + halfSizeSquare)
      ..close();
    return thumbPath;
  }
}

import 'package:flutter/cupertino.dart';

extension ExtenSionOffset on Offset {
  bool containedRectOffset(Offset leftUp, Offset rightDown) {
    return leftUp.dx <= dx &&
        rightDown.dx >= dx &&
        leftUp.dy <= dy &&
        rightDown.dy >= dy;
  }

  bool containedRect(Rect rect) {
    return containedRectOffset(rect.topLeft, rect.bottomRight);
  }
}

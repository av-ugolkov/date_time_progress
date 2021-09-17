import 'package:flutter/cupertino.dart';

extension ExtensionOffset on Offset {
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

extension ExtensionDateTime on DateTime {
  DateTime getDate() {
    return DateTime(year, month, day);
  }
}

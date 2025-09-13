import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class MyCustomScroller extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.mouse, PointerDeviceKind.touch};
}

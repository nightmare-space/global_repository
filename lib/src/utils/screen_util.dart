import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:global_repository/global_repository.dart';

class ScreenAdapter {
  factory ScreenAdapter() => _getInstance();

  ScreenAdapter._internal();
  static ScreenAdapter get instance => _getInstance();
  static ScreenAdapter _instance;
  static ScreenAdapter _getInstance() {
    _instance ??= ScreenAdapter._internal();
    return _instance;
  }

  double uiWidth;
  double scale = 1.0;
  static void init(double width) {
    double widthDp = window.physicalSize.width / window.devicePixelRatio;
    if (kIsWeb || PlatformUtil.isDesktop() || widthDp >= 600) {
      width = widthDp / 1.2;
    }
    print(' -> ${window.physicalSize.width}');
    instance.uiWidth = width;
    instance.scale = widthDp / width;
  }

  static double setWidth(num width) {
    return width.w;
  }
}

extension ScreenExt on num {
  double get w => ScreenAdapter().scale * this;
}

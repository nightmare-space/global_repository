import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    Size dpSize = window.physicalSize / window.devicePixelRatio;
    if (dpSize == Size.zero) {
      return;
    }
    // Log.e('ScreenAdapter init -> $width');
    if (kIsWeb || PlatformUtil.isDesktop()) {
      // 桌面端直接不适配
      width = dpSize.width;
    } else if (dpSize.longestSide > 1000) {
      // 长边的dp大于1000，适配平板，就不能在对组件进行比例缩放
      // 小米10的长边是800多一点
      width = dpSize.width / 1;
    }
    // Log.i('ScreenAdapter init -> ${window.physicalSize.width} $width');
    instance.uiWidth = width;
    instance.scale = dpSize.width / width;
  }

  static double setWidth(num width) {
    return width.w;
  }
}

extension ScreenExt on num {
  double get w => ScreenAdapter().scale * this;
}

extension ScreenInitExt on BuildContext {
  void init(double width) {
    ScreenAdapter.init(width);
  }
}

import 'dart:ui';

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
  double scale;
  static void init(double width) {
    print(' -> ${window.physicalSize.width}');
    instance.uiWidth = width;
    double widthDp = window.physicalSize.width / window.devicePixelRatio;
    instance.scale = widthDp / width;
  }
}

extension ScreenExt on num {
  double get w => ScreenAdapter().scale * this;
}

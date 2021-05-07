import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({this.delay});

  final Duration? delay;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay!, action);
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}

enum ScreenType {
  Phone,
  Tablet,
  Desktop,
}

typedef ResponsiveBuilder = Widget Function(
    BuildContext context, ScreenType screenType);

class Responsive extends StatefulWidget {
  const Responsive({Key? key, required this.builder}) : super(key: key);

  final ResponsiveBuilder? builder;

  @override
  _ResponsiveState createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDesktop() {
    Size size = window.physicalSize;
    return size.width / size.height > 4 / 3;
  }

  bool isTablet() {
    Size size = window.physicalSize;
    return size.height / size.width < 1.6;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, Orientation orientation) {
        switch (orientation) {
          case Orientation.landscape:
            if (isDesktop()) {
              return widget.builder!(_, ScreenType.Desktop);
            } else {
              return widget.builder!(_, ScreenType.Tablet);
            }
          case Orientation.portrait:
            if (isTablet()) {
              return widget.builder!(_, ScreenType.Tablet);
            }
            return widget.builder!(_, ScreenType.Phone);
        }
      },
    );
  }
}

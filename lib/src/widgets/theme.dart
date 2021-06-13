import 'package:flutter/material.dart';

class ToastTheme extends InheritedWidget {
  final TextStyle textStyle;

  final Color backgroundColor;

  final double radius;

  final bool dismissOtherOnShow;

  final bool movingOnWindowChange;

  final TextDirection textDirection;

  final EdgeInsets textPadding;

  final TextAlign textAlign;

  final bool handleTouch;

  final Duration animationDuration;

  final Curve animationCurve;

  final Duration duration;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  const ToastTheme({
    this.animationDuration,
    this.duration,
    this.textStyle,
    this.backgroundColor = Colors.black,
    this.radius,
    this.dismissOtherOnShow = true,
    this.movingOnWindowChange = true,
    this.textPadding,
    this.textAlign,
    this.textDirection,
    this.handleTouch,
    Widget child,
    this.animationCurve = Curves.easeIn,
  }) : super(child: child);
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:global_repository/src/utils/screen_util.dart';

void showToast(
  String message, {
  Duration duration = const Duration(milliseconds: 1000),
}) {
  //创建一个OverlayEntry对象
  // final EdgeInsets padding = MediaQuery.of(toastContext).viewInsets;
  if (contexts.isEmpty) {
    throw '使用祖先节点兄弟';
  }
  final OverlayEntry overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      double deviceWidth = window.physicalSize.width / window.devicePixelRatio;
      double horizontal = (deviceWidth - 400.w) / 2;
      return Positioned(
        top: 0,
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 24.w,
              ),
              child: SizedBox(
                width: 400.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    12.w,
                  ),
                  child: Material(
                    color: Color(0xffeeeeee).withOpacity(0.8),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.w,
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  //往Overlay中插入插入OverlayEntry
  Overlay.of(contexts.last).insert(overlayEntry);
  //两秒后，移除Toast
  Future<void>.delayed(duration).then((_) {
    // ExplosionWidget.bang();
    Future<void>.delayed(
        const Duration(
          milliseconds: 800,
        ), () {
      overlayEntry.remove();
    });
  });
}

Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates sync* {
  yield DefaultMaterialLocalizations.delegate;
  yield DefaultWidgetsLocalizations.delegate;
}

List<BuildContext> contexts = [];

class NiToastNew extends StatefulWidget {
  const NiToastNew({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _NiToastState createState() => _NiToastState();
}

class _NiToastState extends State<NiToastNew> {
  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext ctx) {
            contexts.add(ctx);
            return widget.child;
          },
        ),
      ],
    );
    return Directionality(
      child: MediaQuery(
        data: MediaQueryData.fromWindow(window),
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: _localizationsDelegates.toList(),
          child: overlay,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}

class ToastApp extends StatefulWidget {
  const ToastApp({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _ToastAppState createState() => _ToastAppState();
}

class _ToastAppState extends State<ToastApp> {
  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext ctx) {
            contexts.add(ctx);
            return widget.child;
          },
        ),
      ],
    );
    return Directionality(
      child: MediaQuery(
        data: MediaQueryData.fromWindow(window),
        child: Localizations(
          locale: const Locale('en', 'US'),
          delegates: _localizationsDelegates.toList(),
          child: overlay,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}

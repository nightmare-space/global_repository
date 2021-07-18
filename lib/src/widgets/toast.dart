import 'dart:ui';

import 'package:flutter/material.dart';

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
      return Positioned(
        top: 0,
        child: SizedBox(
          width: window.physicalSize.width / window.devicePixelRatio,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                16,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 3.0,
                      sigmaY: 3.0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        color: const Color(0xfff0f0f0).withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

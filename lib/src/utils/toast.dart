import 'dart:ui';

import 'package:flutter/material.dart';

void showToast(
  String message, {
  Duration duration = const Duration(milliseconds: 1000),
}) {
  //创建一个OverlayEntry对象
  // final EdgeInsets padding = MediaQuery.of(toastContext).viewInsets;
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
            child: Material(
              color: Colors.transparent,
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

List<BuildContext> contexts = [];

class NiToast extends NiToastNew {}

class NiToastNew extends StatefulWidget {
  const NiToastNew({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _NiToastState createState() => _NiToastState();
}

class _NiToastState extends State<NiToastNew> {
  @override
  Widget build(BuildContext context) {
    TextDirection direction = TextDirection.ltr;
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            contexts.add(context);
            return widget.child;
          },
        ),
      ],
    );

    Widget w = Directionality(
      child: overlay,
      textDirection: direction,
    );
    return w;
  }
}

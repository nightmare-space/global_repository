import 'package:flutter/material.dart';

mixin NiToast {
  static BuildContext toastContext;
  static List<String> stack = <String>[];
  static void initContext(BuildContext context) {
    toastContext ??= context;
  }

  static void showToast(
    String message, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    //创建一个OverlayEntry对象

    // final EdgeInsets padding = MediaQuery.of(toastContext).viewInsets;
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                color: const Color(0xff2c2c2e),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    //往Overlay中插入插入OverlayEntry
    Overlay.of(toastContext).insert(overlayEntry);
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
}

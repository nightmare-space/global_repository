import 'dart:ui';

import 'package:flutter/material.dart';

class NiToast extends InheritedWidget {
  ///构造函数
  const NiToast({Key key, @required Widget child})
      : super(key: key, child: child);
  //定义一个便捷方法，方便子树中的widget获取共享数据
  static NiToast of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NiToast>();
  }

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
        return Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 2.0,
                              sigmaY: 2.0,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                // color: const Color(0xff2c2c2e),

                                color: Color(0xffececec).withOpacity(0.6),
                              ),
                              height: 72,
                              // child:
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              message,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        return Center(
          child: Material(
            color: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  // color: const Color(0xff2c2c2e),

                  color: Color(0xffececec),
                ),
                height: 64,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
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

  ///framework通过使用旧widget占据树中的这个位置的小部件作为参数调用这个函数来区分这些情况。
  @override
  bool updateShouldNotify(NiToast oldWidget) {
    return oldWidget != this.child; //一般比较的是数据是不是不一样
  }
}

// mixin NiToast {
//   static BuildContext toastContext;
//   static List<String> stack = <String>[];
//   static void initContext(BuildContext context) {
//     toastContext ??= context;
//   }

//   static void showToast(
//     String message, {
//     Duration duration = const Duration(milliseconds: 1000),
//   }) {
//     //创建一个OverlayEntry对象

//     // final EdgeInsets padding = MediaQuery.of(toastContext).viewInsets;
//     final OverlayEntry overlayEntry = OverlayEntry(
//       builder: (BuildContext context) {
//         return Center(
//           child: Material(
//             color: Colors.transparent,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(
//                   8,
//                 ),
//                 color: const Color(0xff2c2c2e),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Text(
//                   message,
//                   style: const TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     //往Overlay中插入插入OverlayEntry
//     Overlay.of(toastContext).insert(overlayEntry);
//     //两秒后，移除Toast
//     Future<void>.delayed(duration).then((_) {
//       // ExplosionWidget.bang();
//       Future<void>.delayed(
//           const Duration(
//             milliseconds: 800,
//           ), () {
//         overlayEntry.remove();
//       });
//     });
//   }
// }

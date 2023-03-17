import 'package:flutter/material.dart' hide TabController;
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:global_repository/src/controller/tab_controller.dart';
import 'package:window_manager/window_manager.dart';

class TopTab extends StatefulWidget {
  const TopTab({
    Key? key,
    this.value,
    required this.children,
    this.onChanged,
  }) : super(key: key);
  final int? value;
  // final void Function()
  final List<Widget> children;
  final void Function(int index)? onChanged;

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> with SingleTickerProviderStateMixin {
  TabController tabController = Get.put(TabController());
  late AnimationController controller;
  late Animation offset;
  int? index;
  double tabWidth = 120.w;
  double tabHeight = 22.w;
  double paddingTop = 4.w;
  bool isFull = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    offset = Tween<double>(begin: 0, end: 0).animate(controller);
    index = widget.value;
    tabController.addListener(listenOpenPage);
  }

  @override
  void dispose() {
    controller.dispose();
    tabController.removeListener(listenOpenPage);
    super.dispose();
  }

  void listenOpenPage() {
    offset = Tween<double>(begin: offset.value, end: (tabWidth + 10.w) * tabController.pageindex).animate(controller);
    controller.reset();
    controller.forward();
  }

  String getIcon(int? type) {
    switch (type) {
      case 0:
        return 'assets/icon/phone.png';
      case 1:
        return 'assets/icon/computer.png';
      case 2:
        return 'assets/icon/broswer.png';
      default:
        return 'assets/icon/computer.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color tabColor = Color(0xffe8e9ee);
    if (GetPlatform.isMobile) {
      return const SizedBox();
    }
    return Material(
      color: tabColor,
      child: SizedBox(
        height: tabHeight,
        width: double.infinity,
        child: Row(
          children: [
            if (GetPlatform.isDesktop)
              Expanded(
                child: DragToMoveArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: GetPlatform.isMacOS ? 60.w : 0,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(top: paddingTop),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: controller,
                                    builder: (context, c) {
                                      return SizedBox(
                                        width: offset.value,
                                      );
                                    },
                                  ),
                                  Stack(
                                    children: [
                                      Material(
                                        color: Color(0xfff3f4f9),
                                        child: SizedBox(
                                          height: tabHeight,
                                          width: 10.w,
                                        ),
                                      ),
                                      Material(
                                        color: tabColor,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(16.w),
                                        ),
                                        child: SizedBox(
                                          height: tabHeight,
                                          width: 10.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: tabHeight,
                                    width: tabWidth,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff3f4f9),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.w),
                                        topRight: Radius.circular(12.w),
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Material(
                                        color: Color(0xfff3f4f9),
                                        child: SizedBox(
                                          height: tabHeight,
                                          width: 10.w,
                                        ),
                                      ),
                                      Material(
                                        color: tabColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16.w),
                                        ),
                                        child: SizedBox(
                                          height: tabHeight,
                                          width: 10.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                for (int i = 0; i < widget.children.length; i++)
                                  Padding(
                                    padding: EdgeInsets.only(top: paddingTop, right: 10.w),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        index = 0;
                                        offset = Tween<double>(begin: offset.value, end: (tabWidth + 10.w) * i).animate(controller);
                                        controller.reset();
                                        controller.forward();
                                        setState(() {});
                                        // 等待200ms，让动画执行完毕
                                        Future<void>.delayed(const Duration(milliseconds: 200), () {
                                          widget.onChanged?.call(i);
                                        });
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.only(),
                                        color: Colors.transparent,
                                        child: Stack(
                                          alignment: Alignment.centerRight,
                                          children: [
                                            Container(
                                              height: tabHeight,
                                              width: tabWidth,
                                              child: Center(child: widget.children[i]),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: tabHeight,
                                                  height: tabHeight,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(tabHeight / 2),
                                                    onTap: () {
                                                      tabController.closePage(i);
                                                    },
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.clear,
                                                        size: 18.w,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (GetPlatform.isDesktop)
              Container(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expanded(
                    //   child: DragToMoveArea(
                    //     child: Container(
                    //       color: Colors.transparent,
                    //     ),
                    //   ),
                    // ),
                    WindowCaptionButton.minimize(
                      onPressed: () {
                        windowManager.minimize();
                      },
                      brightness: Theme.of(context).brightness,
                    ),
                    isFull
                        ? WindowCaptionButton.unmaximize(
                            onPressed: () {
                              isFull = false;
                              setState(() {});
                              windowManager.unmaximize();
                            },
                            brightness: Theme.of(context).brightness,
                          )
                        : WindowCaptionButton.maximize(
                            onPressed: () {
                              isFull = true;
                              setState(() {});
                              windowManager.maximize();
                            },
                            brightness: Theme.of(context).brightness,
                          ),
                    WindowCaptionButton.close(
                      onPressed: () {
                        windowManager.close();
                      },
                      brightness: Theme.of(context).brightness,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

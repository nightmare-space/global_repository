import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/src/widgets/screen_query.dart';
import 'package:global_repository/src/widgets/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:signale/signale.dart';
import 'api/api.dart';
import 'api/models.dart';
import 'diary_page.dart';
import 'select_tab.dart';

// API api = API(Dio(), baseUrl: 'https://api.bkkj.cc/api/v1/board');
// TODO 试试直接改host，或者用系统环境变量
API? _api;
API get api {
  _api ??= API(Dio(), baseUrl: 'http://127.0.0.1:18000/api/v1/board');
  // _api = API(Dio(), baseUrl: 'http://192.168.31.178:18000/api/v1/board');
  _api = API(Dio(), baseUrl: 'https://api.bkkj.cc/api/v1/board');
  return _api!;
}

class ProjBoardV2 extends StatefulWidget {
  const ProjBoardV2();

  @override
  State<ProjBoardV2> createState() => _ProjBoardV2State();
}

class _ProjBoardV2State extends State<ProjBoardV2> {
  // key is app string
  Map<String, List<BoardItem>> boardItemsMap = {};
  // Map<String, List<String>> boardTitlesMap = {};
  // final headTabs = ['看板', '工作记录&日记'];
  final headTabs = ['看板'];
  late String rootPage = headTabs.first;
  String? currentApp;
  String time = '';
  BoardItems boardItems = BoardItems(datas: []);

  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      load();
    });

    // Timer.periodic(Duration(milliseconds: 300), (_) {});
  }

  Future<void> load() async {
    setState(() {});
    boardItems = await api.getBoardItems();
    Log.w('boardItems => ${boardItems.datas?.length}');
    // put boardItems into boardItemsMap,use item.app
    boardItemsMap.clear();
    for (var item in boardItems.datas!) {
      boardItemsMap.putIfAbsent(item.app!, () => []).add(item);
    }
    boardItemsMap.removeWhere((key, value) => key == 'TND(TheNeoDesktop)');
    if (boardItemsMap.isNotEmpty) currentApp ??= boardItemsMap.keys.first ?? null;
    Log.i('boardItemsMap => ${boardItemsMap.keys}');
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_keyboardFocusNode);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 新增：键盘焦点与 Shift 状态
  bool _shiftPressed = false;
  final FocusNode _keyboardFocusNode = FocusNode();

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Log.i('l(20) -> ${context.l(20)}');
    Log.i('scale -> ${ScreenQuery.of(context).scale}');
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final textStyle = TextStyle(
      fontSize: context.l(16),
      fontWeight: FontWeight.w500,
      color: onSurface,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Theme(
        data: ThemeData(
          scaffoldBackgroundColor: surface,
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.grey.withOpacity(0.5)),
            trackColor: WidgetStateProperty.all(Colors.transparent),
            radius: Radius.circular(l(20)),
            thickness: WidgetStateProperty.all(l(6)),
            crossAxisMargin: l(2),
            mainAxisMargin: l(2),
            minThumbLength: l(36),
          ),
        ),
        child: Scaffold(
          backgroundColor: surface,
          body: SafeAreaFix(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? l(12) : l(32)),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            width: double.infinity,
                            height: l(56),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '项目看板',
                              style: TextStyle(
                                fontSize: l(32),
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: l(32)),
                              Text(
                                '哈喽大家，为了让大家感知到我现在在做的事，和已经收录的问题，现在我把我自己的项目看板公开',
                                textAlign: TextAlign.start,
                                style: textStyle,
                              ),
                              SizedBox(height: l(16)),
                              Text(
                                '后续会开发一个，需求加急功能，大家对比较关注的问题，可以点赞，我会优先处理',
                                textAlign: TextAlign.start,
                                style: textStyle,
                              ),
                              SizedBox(height: l(20)),
                              Text(
                                '我目前是自由开发，给自己的要求是上一休六',
                                textAlign: TextAlign.start,
                                style: textStyle,
                              ),
                              SizedBox(height: l(20)),
                              Row(
                                children: [
                                  Text(
                                    '当前页面更新时间：',
                                    style: textStyle,
                                  ),
                                  Text(
                                    time,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                              SizedBox(height: l(20)),
                              SelectTab<String>(
                                onTabChange: (value) {
                                  rootPage = value;
                                  setState(() {});
                                },
                                value: rootPage,
                                tabs: headTabs,
                              ),
                              SizedBox(height: l(20)),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ];
                },
                // body: Container(
                //   width: 100,
                //   height: 100,
                //   color: Colors.red,
                // ),
                body: Builder(
                  builder: (context) {
                    if (boardItemsMap.keys.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return CustomScrollView(
                      slivers: [
                        // 注入 overlap handle，配合上面的 SliverOverlapAbsorber
                        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        if (rootPage == headTabs.first) ...[
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyHeaderDelegate(
                              child: SizedBox(
                                height: l(40),
                                child: SelectTab<String>(
                                  onTabChange: (value) {
                                    currentApp = value;
                                    setState(() {});
                                  },
                                  value: currentApp ?? '',
                                  tabs: boardItemsMap.keys.toList(),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: l(20)),
                          ),
                          SliverToBoxAdapter(
                            child: BoardDetail(items: boardItemsMap[currentApp] ?? []),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: l(20)),
                          ),
                        ] else if (rootPage == headTabs.last)
                          SliverToBoxAdapter(
                            child: const DiaryPage(),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BoardDetail extends StatefulWidget {
  const BoardDetail({
    Key? key,
    required this.items,
  }) : super(key: key);
  final List<BoardItem> items;

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  int page = 0;
  Map<String, String> statusMap = {
    'BACKLOG': '待办',
    'BUG': '缺陷',
    'IN_PROGRESS': '进行中',
    'DONE': '已完成',
    'ABANDONED': '废弃需求',
  };

  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // 计算内容的高度，用于设置InteractiveViewer的容器高度
  double _calculateContentHeight(List<List<BoardItem>> all) {
    if (all.isEmpty) return 0;

    // 找到最长的列
    int maxItems = all.map((items) => items.length).reduce((a, b) => a > b ? a : b);

    // 估算高度：标题高度 + 间距 + (每个item的估算高度 * 数量) + 容器padding
    return l(18) + l(8) + (maxItems * l(80)) + l(16) + l(100); // 添加一些额外空间
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        final backlogItems = widget.items.where((item) => item.status == 'BACKLOG').toList();
        final bugItems = widget.items.where((item) => item.status == 'BUG').toList();
        final inProgressItems = widget.items.where((item) => item.status == 'IN_PROGRESS').toList();
        final doneItems = widget.items.where((item) => item.status == 'DONE').toList();
        final abandonedItems = widget.items.where((item) => item.status == 'ABANDONED').toList();
        final all = [
          backlogItems,
          bugItems,
          inProgressItems,
          doneItems,
          abandonedItems,
        ];

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // 拦截所有滚动通知，阻止它们向上传递
            return true;
          },
          child: Listener(
            onPointerSignal: (pointerSignal) {
              // if (pointerSignal is PointerScrollEvent) {
              //   // 检测Shift键状态
              //   final shiftPressed = RawKeyboard.instance.keysPressed.any((k) => k == LogicalKeyboardKey.shiftLeft || k == LogicalKeyboardKey.shiftRight);

              //   // 处理横向滚动
              //   if (shiftPressed && pointerSignal.scrollDelta.dy != 0) {
              //     // 将垂直滚动转换为水平滚动
              //     final currentMatrix = _transformationController.value;
              //     final newMatrix = Matrix4.copy(currentMatrix);

              //     // 计算新的水平偏移
              //     final scrollSensitivity = 2.0;
              //     final deltaX = pointerSignal.scrollDelta.dy * scrollSensitivity;
              //     newMatrix.translate(-deltaX, 0.0);

              //     // 应用变换
              //     _transformationController.value = newMatrix;

              //     // 阻止事件继续传递
              //     GestureBinding.instance.pointerSignalResolver.resolve(pointerSignal);
              //     return;
              //   }

              //   // 如果本身就是水平滚动，直接处理
              //   if (pointerSignal.scrollDelta.dx != 0) {
              //     final currentMatrix = _transformationController.value;
              //     final newMatrix = Matrix4.copy(currentMatrix);

              //     // 应用水平滚动
              //     final scrollSensitivity = 2.0;
              //     final deltaX = pointerSignal.scrollDelta.dx * scrollSensitivity;
              //     newMatrix.translate(-deltaX, 0.0);

              //     _transformationController.value = newMatrix;

              //     // 阻止事件继续传递
              //     GestureBinding.instance.pointerSignalResolver.resolve(pointerSignal);
              //   }

              //   // 处理垂直滚动（当没有按Shift键时）
              //   if (!shiftPressed && pointerSignal.scrollDelta.dy != 0) {
              //     final currentMatrix = _transformationController.value;
              //     final newMatrix = Matrix4.copy(currentMatrix);

              //     // 应用垂直滚动
              //     final scrollSensitivity = 2.0;
              //     final deltaY = pointerSignal.scrollDelta.dy * scrollSensitivity;
              //     newMatrix.translate(0.0, -deltaY);

              //     _transformationController.value = newMatrix;

              //     // 阻止事件继续传递
              //     GestureBinding.instance.pointerSignalResolver.resolve(pointerSignal);
              //   }
              // }
            },
            child: SizedBox(
              height: _calculateContentHeight(all), // 计算内容高度
              child: InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                scaleEnabled: false, // 禁用缩放
                panEnabled: true, // 启用平移
                minScale: 1.0,
                maxScale: 1.0,
                boundaryMargin: EdgeInsets.only(top: 0, bottom: _calculateContentHeight(all) / 2), // 允许无限制滚动
                panAxis: PanAxis.free, // 允许自由方向平移
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: l(12),
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ...all.map(
                      (items) {
                        if (items.isEmpty) return const SizedBox.shrink();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: l(8 + 8)),
                              child: Text(
                                statusMap[items.first.status] ?? '',
                                style: TextStyle(
                                  color: onSurface,
                                  fontSize: l(18),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: l(8)),
                            Material(
                              color: surfaceContainer,
                              borderRadius: BorderRadius.circular(l(20)),
                              child: Container(
                                width: l(300),
                                padding: EdgeInsets.symmetric(horizontal: l(8), vertical: l(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...items.map(
                                      (item) {
                                        return Builder(builder: (context) {
                                          bool isLast = item == items.last;
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: surface,
                                              borderRadius: BorderRadius.circular(l(12)),
                                            ),
                                            width: double.infinity,
                                            margin: isLast ? null : EdgeInsets.only(bottom: l(12)),
                                            padding: EdgeInsets.all(l(0)),
                                            child: Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: l(8), top: l(8)),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: ' ',
                                                                  ),
                                                                  TextSpan(
                                                                    text: item.title ?? '',
                                                                    style: TextStyle(
                                                                      color: item.status == 'DONE' ? onSurface.withOpacity(0.7) : onSurface,
                                                                      decoration: item.status == 'DONE' ? TextDecoration.lineThrough : null,
                                                                      fontSize: l(14),
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: l(8)),
                                                          child: Row(
                                                            spacing: l(2),
                                                            children: [
                                                              Text(
                                                                item.likeCount.toString(),
                                                                style: TextStyle(
                                                                  color: onSurface,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                color: Theme.of(context).colorScheme.primary,
                                                                onPressed: () async {
                                                                  try {
                                                                    await api.likeBoardItem(item.id!, {'user_identifier': 'nightmare_space_user'});
                                                                    item.increaseLikeCount();
                                                                    setState(() {});
                                                                    showToast('催更成功~');
                                                                  } catch (e) {
                                                                    Log.e('likeBoardItem error => $e');
                                                                  }
                                                                },
                                                                icon: Text('🚀'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (item.description.isNotEmpty)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(l(12)),
                                                        ),
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(l(8)),
                                                        child: HighlightedText(
                                                          text: item.description,
                                                          isDone: item.status == 'DONE',
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    Key? key,
    required this.text,
    required this.isDone,
  }) : super(key: key);
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    Function l = context.l;
    List<TextSpan> spans = [];
    text.split(' ').forEach((word) {
      if (word.startsWith('#')) {
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: isDone ? Theme.of(context).primaryColor.withOpacity(0.7) : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: l(14),
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: isDone ? onSurface.withOpacity(0.7) : onSurface,
            fontSize: l(14),
            fontWeight: FontWeight.w500,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ));
      }
    });
    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

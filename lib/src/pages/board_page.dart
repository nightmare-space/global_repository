import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/src/widgets/screen_query.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:speed_share/modules/personal/screen_util.dart';

import 'board_util.dart';

class ProjBoard extends StatefulWidget {
  const ProjBoard();

  @override
  State<ProjBoard> createState() => _ProjBoardState();
}

class _ProjBoardState extends State<ProjBoard> {
  Map<String, dynamic> projData = {};
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    Response<Map<String, dynamic>> result = await Dio().get('https://nightmare.press/YanTool/resources/output.json');
    projData = result.data!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? l(20) : l(120)),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: l(100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: l(100)),
                Text(
                  '''哈喽大家，为了让大家感知到我现在在做的事，和已经收录的问题，现在我把我自己的项目看板公开
          
后续会开发一个，需求加急功能，大家对比较关注的问题，可以点赞，我会优先处理
          
我目前是自由开发，给自己的要求是上四休三，每天会尽量付出8小时在这些项目          
          ''',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: l(20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                for (String key in projData.keys)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: l(24),
                        ),
                      ),
                      SizedBox(height: l(12)),
                      BoardDetail(data: projData[key]),
                      SizedBox(height: l(24)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoardDetail extends StatefulWidget {
  const BoardDetail({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        List<BoardCard> boards = getBoardFromMD(widget.data);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (BoardCard board in boards)
                Padding(
                  padding: EdgeInsets.only(right: l(12)),
                  child: SizedBox(
                    width: l(400),
                    child: Column(
                      children: [
                        Text(
                          board.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: l(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: l(12)),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff141414),
                            borderRadius: BorderRadius.circular(l(20)),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: l(8), vertical: l(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < board.items.length; i++)
                                Builder(builder: (context) {
                                  BoardItem item = board.items[i];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff050505),
                                      borderRadius: BorderRadius.circular(l(12)),
                                    ),
                                    width: double.infinity,
                                    margin: i == board.items.length - 1 ? null : EdgeInsets.only(bottom: l(12)),
                                    padding: EdgeInsets.all(l(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: HighlightedText(
                                        text: item.content,
                                        isDone: item.isDone,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
            fontSize: l(18),
            fontFamily: 'CustomFont',
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: '$word ',
          style: TextStyle(
            color: isDone ? Colors.white70 : Colors.white,
            fontSize: l(18),
            fontFamily: 'CustomFont',
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

class LineThroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Hello, Flutter!',
        style: TextStyle(
          fontSize: 24,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(canvas, Offset.zero);

    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2; // 调整线条粗细

    final textHeight = textPainter.size.height;
    final yOffset = textHeight / 2;

    canvas.drawLine(
      Offset(0, yOffset),
      Offset(textPainter.width, yOffset),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

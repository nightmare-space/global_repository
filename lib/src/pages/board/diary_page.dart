import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/src/pages/about_page.dart';
import 'package:global_repository/src/widgets/widgets.dart';
import 'package:signale/signale.dart';

class DiaryNode {
  DiaryNode(this.title, this.summary);

  final String title;
  final String summary;
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  String diary = '';
  int page = 0;
  String time = '';
  List<DiaryNode> diaries = [];
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    Response<String> result = await Dio().get('https://nightmare.press/YanTool/resources/工作记录与日记.md');
    diary = result.data!;

    RegExp regExp = RegExp('##');
    for (String line in diary.split(regExp)) {
      String title = line.split('\n').first.trim();
      String summary = line.replaceAll(title, '').trim();
      Log.i('title -> ${title}');
      Log.i('summary -> ${summary}');
      if (summary.isEmpty) {
        continue;
      }
      diaries.add(DiaryNode(title, summary));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: l(12)),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: diaries.length,
        itemBuilder: (c, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: l(8)),
                child: Text(
                  diaries[i].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: l(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: l(10)),
              if (diaries[i].summary.isNotEmpty)
                Material(
                  borderRadius: BorderRadius.circular(l(12)),
                  clipBehavior: Clip.hardEdge,
                  color: Color(0xff141414),
                  child: Padding(
                    padding: EdgeInsets.all(l(10)),
                    child: Text(
                      diaries[i].summary,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: l(18),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: l(20)),
            ],
          );
        },
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/src/widgets/widgets.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  String diary = '';
  int page = 0;
  String time = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    Response<String> result = await Dio().get('https://nightmare.press/YanTool/resources/工作记录与日记.md');
    diary = result.data!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          diary,
          style: TextStyle(
            color: Colors.white,
            fontSize: l(16),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

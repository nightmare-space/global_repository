import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';

class ChangeNode {
  ChangeNode(this.title, this.summary);

  final String title;
  final String summary;
}

///  更新日志
class ChangeLogPage extends StatefulWidget {
  const ChangeLogPage({Key? key, this.showAppbar = true}) : super(key: key);
  final bool showAppbar;

  @override
  State createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends State<ChangeLogPage> {
  List<ChangeNode> changes = [];
  @override
  void initState() {
    super.initState();
    newMethod();
  }

  Future<void> newMethod() async {
    String data = await rootBundle.loadString('CHANGELOG.md');
    // Log.i(data);
    RegExp regExp = RegExp('##');
    for (String line in data.split(regExp)) {
      String title = line.split('\n').first.trim();
      String summary = line.replaceAll(title, '').trim();
      changes.add(ChangeNode(title, summary));
    }
    changes.removeAt(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppbar ? AppBar(title: Text('更新日志')) : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: changes.length,
          itemBuilder: (c, i) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      changes[i].title,
                      style: TextStyle(
                        fontSize: l(14),
                      ),
                    ),
                  ),
                  if (changes[i].summary.isNotEmpty)
                    GlobalCardItem(
                      padding: EdgeInsets.all(10.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: changes[i].summary));
                            showToast('已复制到剪切板');
                          },
                          child: Text(
                            changes[i].summary,
                            style: TextStyle(
                              fontSize: l(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

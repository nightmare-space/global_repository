import 'dart:io';

import 'package:signale/signale.dart';

Future<int> getSafePort(int rangeStart, int rangeEnd) async {
  if (rangeStart == rangeEnd) {
    // 说明都失败了
    return null;
  }
  try {
    await ServerSocket.bind(
      '0.0.0.0',
      rangeStart,
      shared: true,
    );
    Log.d('端口$rangeStart绑定成功');
    return rangeStart;
  } catch (e) {
    Log.e('端口$rangeStart绑定失败');
    return await getSafePort(rangeStart + 1, rangeEnd);
  }
}
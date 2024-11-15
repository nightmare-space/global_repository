import 'dart:io';

import 'package:flutter/services.dart';

class AssetsUtils {
  AssetsUtils._();
  static Future<void> copyAssetToPath(String key, String path, {bool forceCopy = false}) async {
    final ByteData byteData = await rootBundle.load(key);
    final Uint8List picBytes = byteData.buffer.asUint8List();
    final File file = File(path);
    if (forceCopy || !await file.exists() || file.lengthSync() != picBytes.length) {
      await file.writeAsBytes(picBytes);
    }
  }
}

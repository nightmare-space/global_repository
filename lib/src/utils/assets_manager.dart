import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

/// Create by Nightmare at 2022/03/01
/// 很多个应用都需要启动的时候复制指定的资源
/// 所以就封装了这个类
///
class AssetsManager {
  AssetsManager._();
  static Future<void> copyFiles({
    List<String>? android,
    List<String>? macOS,
    List<String>? windows,
    required List<String> global,
    required String localPath,
    String package = '',
  }) async {
    if (Platform.isAndroid) {
      final Directory dir = Directory(localPath);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      for (final String fileName in android!) {
        final filePath = localPath + fileName.replaceAll(RegExp('.*/'), '');
        await AssetsUtils.copyAssetToPath(
          '${package}assets/$fileName',
          filePath,
        );
        final ProcessResult result = await Process.run(
          'chmod',
          <String>['+x', filePath],
        );
        Log.d(
          '更改文件权限 $fileName 输出 stdout:${result.stdout} stderr；${result.stderr}',
        );
      }
    }
    if (Platform.isMacOS) {
      final Directory dir = Directory(localPath);
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      for (final String fileName in macOS!) {
        final filePath = localPath + fileName.replaceAll(RegExp('.*/'), '');
        await AssetsUtils.copyAssetToPath(
          '${package}assets/$fileName',
          filePath,
        );
        final ProcessResult result = await Process.run(
          'chmod',
          <String>['+x', filePath],
        );
        Log.d(
          '更改文件权限 $fileName 输出 stdout:${result.stdout} stderr；${result.stderr}',
        );
      }
    }
    final Directory dir = Directory(localPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    for (final String fileName in global) {
      final filePath = localPath + fileName.replaceAll(RegExp('.*/'), '');
      await AssetsUtils.copyAssetToPath(
        '${package}assets/$fileName',
        filePath,
      );
      if (!Platform.isWindows) {
        final ProcessResult result = await Process.run(
          'chmod',
          <String>['+x', filePath],
        );
        Log.d(
          '更改文件权限 $fileName 输出 stdout:${result.stdout} stderr；${result.stderr}',
        );
      }
    }
  }
}

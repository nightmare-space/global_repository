import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path_provider/path_provider.dart';

Future<String> exec(String cmd) async {
  String value = '';
  final io.ProcessResult result = await io.Process.run(
    'sh',
    ['-c', cmd],
    environment: PlatformUtil.environment(),
  );
  value += result.stdout.toString();
  value += result.stderr.toString();
  return value.trim();
}

bool isAddress(String content) {
  final RegExp regExp = RegExp(
      '((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})(\\.((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})){3}');
  return regExp.hasMatch(content);
}

// 针对平台
class PlatformUtil {
  static Future<List<String>> localAddress() async {
    List<String> address = [];
    final List<io.NetworkInterface> interfaces = await io.NetworkInterface.list(
      includeLoopback: false,
      type: io.InternetAddressType.IPv4,
    );
    for (final io.NetworkInterface netInterface in interfaces) {
      // 遍历网卡
      for (final io.InternetAddress netAddress in netInterface.addresses) {
        // 遍历网卡的IP地址
        if (isAddress(netAddress.address)) {
          address.add(netAddress.address);
        }
      }
    }
    return address;
  }

  static bool isMobilePhone() {
    return io.Platform.isAndroid || io.Platform.isIOS;
  }

  static String getLsPath() {
    return '/system/bin/ls';
  }

  // 判断当前的设备是否是桌面设备
  static bool isDesktop() {
    return !isMobilePhone();
  }

  static String getDownloadPath() {
    if (io.Platform.isAndroid) {
      return '/sdcard/download';
    }
    final Map<String, String> map = Map.from(io.Platform.environment);
    // print(map);
    return map['HOME'] + '/downloads';
  }

  static Map<String, String> environment() {
    if (kIsWeb) {
      return {};
    }
    final Map<String, String> map = Map.from(io.Platform.environment);
    if (io.Platform.isWindows) {
      map['PATH'] = RuntimeEnvir.binPath + ';' + map['PATH'];
    } else {
      map['PATH'] = RuntimeEnvir.binPath + ':' + map['PATH'];
    }
    return map;
  }

  static Map<String, String> environmentByPackage(String packageName) {
    final Map<String, String> map = Map.from(io.Platform.environment);
    map['PATH'] = RuntimeEnvir.binPath + ';' + map['PATH'];
    return map;
  }

  static Future<bool> cmdIsExist(String cmd) async {
    String stderr;
    String stdout;
    final io.ProcessResult result = await io.Process.run(
      io.Platform.isWindows ? 'where' : 'which',
      [cmd],
      environment: PlatformUtil.environment(),
    );
    stdout = result.stdout.toString();
    stderr = result.stderr.toString();
    // print('stderr->${result.stderr.toString()}');
    // print('stdout->${result.stdout.toString()}');
    if (io.Platform.isWindows)
      return stderr.isEmpty;
    else
      return stdout.isNotEmpty;
  }

  static Future<String> getDocumentDirectory() async {
    // 获取外部储存路径的函数
    // 原path_provider中有提供，后来被删除了
    String path;
    if (io.Platform.isAndroid) {
      io.Directory storageDirectory = await getExternalStorageDirectory();
      path = storageDirectory.path.replaceAll(
        RegExp('/Android.*'),
        '',
      ); //初始化外部储存的路径
    } else if (isDesktop()) {
      path = io.FileSystemEntity.parentOf(io.Platform.resolvedExecutable);
    }
    return path;
  }
}

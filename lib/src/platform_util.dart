import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> exec(String cmd) async {
  String value = '';
  final ProcessResult result = await Process.run(
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
  // 判断当前的设备是否是移动设备
  static String _packageName;
  static String get packageName => _packageName;
  static Future<void> initPackageName() async {
    // 获取包名
    _packageName ??= await getPackageName();
  }

  static void setPackageName(String packageName) {
    // 获取包名
    _packageName = packageName;
  }

  static Future<List<String>> localAddress() async {
    List<String> address = [];
    final List<NetworkInterface> networkInterfaces =
        await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.IPv4,
    );
    for (final NetworkInterface netInterface in networkInterfaces) {
      // 遍历网卡
      // print('${netInterface.name} : ${netInterface.addresses}');
      for (final InternetAddress netAddress in netInterface.addresses) {
        // 遍历网卡的IP地址
        if (isAddress(netAddress.address)) {
          address.add(netAddress.address);
        }
      }
    }
    return address;
  }

  static bool isMobilePhone() {
    return Platform.isAndroid || Platform.isIOS;
  }

  static String getLsPath() {
    return '/system/bin/ls';
  }

  // 判断当前的设备是否是桌面设备
  static bool isDesktop() {
    return !isMobilePhone();
  }

  static String getFileName(String filePath) {
    return filePath.split(Platform.pathSeparator).last;
  }

  static String getPlatformPathByUnixPath(String filePath) {
    if (Platform.isWindows)
      return filePath.replaceAll('/', r'\').replaceAll(RegExp('/c'), 'C:');
    else
      return filePath;
  }

  static String getDownloadPath() {
    if (Platform.isAndroid) {
      return '/sdcard/download';
    }
    final Map<String, String> map = Map.from(Platform.environment);
    // print(map);
    return map['HOME'] + '/downloads';
  }

  // 获取二进制文件的路径

  static String getBinaryPath() {
    String binPath = getDataPath() +
        '${Platform.pathSeparator}usr${Platform.pathSeparator}bin';
    Directory binDir = Directory(binPath);
    if (!binDir.existsSync()) {
      binDir.createSync(recursive: true);
    }
    // print();
    return binPath;
  }

  static String getTmpPath() {
    String binPath = getDataPath() +
        '${Platform.pathSeparator}usr${Platform.pathSeparator}tmp';
    Directory binDir = Directory(binPath);
    if (!binDir.existsSync()) {
      binDir.createSync();
    }
    // print();
    return binPath;
  }

  // 获取files文件夹的路径，更多用在安卓
  static String getFilsePath() {
    if (Platform.isMacOS) {
      String macDataPath =
          FileSystemEntity.parentOf(Platform.resolvedExecutable) + '/data';
      Directory macDataDir = Directory(macDataPath);
      if (!macDataDir.existsSync()) {
        macDataDir.createSync();
      }
      return macDataPath;
    }
    return '/data/data/$_packageName/files';
  }

  // 获取files文件夹的路径，更多用在安卓
  static String getDataPath({String packageName}) {
    _packageName ??= packageName;
    if (Platform.isMacOS) {
      String macDataPath =
          FileSystemEntity.parentOf(Platform.resolvedExecutable) + '/data';
      Directory macDataDir = Directory(macDataPath);
      if (!macDataDir.existsSync()) {
        macDataDir.createSync();
      }
      return macDataPath;
    }
    if (Platform.isLinux) {
      return FileSystemEntity.parentOf(Platform.resolvedExecutable) + '/data';
    }
    if (Platform.isWindows) {
      String dataPath =
          FileSystemEntity.parentOf(Platform.resolvedExecutable) + r'\data';
      Directory dataDir = Directory(dataPath);
      if (!dataDir.existsSync()) {
        dataDir.createSync();
      }
      return dataPath;
    }

    // TODO 要确保初始化
    return '/data/data/$_packageName/files';
  }

  static String getUnixPath(String prePath) {
    if (!RegExp('^[A-Z]:').hasMatch(prePath)) {
      return prePath.replaceAll('\\', '/');
    }
    final Iterable<Match> e = RegExp('^[A-Z]').allMatches(prePath);
    final String patch = e.elementAt(0).group(0);
    return prePath
        .replaceAll('\\', '/')
        .replaceAll(RegExp('^' + patch + ':'), '/mnt/' + patch.toLowerCase());
  }

  static Map<String, String> environment() {
    final Map<String, String> map = Map.from(Platform.environment);
    if (Platform.isAndroid) {
      // 只有安卓需要
      // TODO
      map['PATH'] = '/data/data/$_packageName/files/usr/bin:' + map['PATH'];
    }
    if (Platform.isMacOS) {
      map['PATH'] = getBinaryPath() + ':' + map['PATH'];
    }
    if (Platform.isWindows) {
      map['PATH'] = getBinaryPath() + ';' + map['PATH'];
    }
    return map;
  }

  static Map<String, String> environmentByPackage(String packageName) {
    final Map<String, String> map = Map.from(Platform.environment);
    if (Platform.isAndroid) {
      // 只有安卓需要
      // TODO
      map['PATH'] = '/data/data/$packageName/files/usr/bin:' + map['PATH'];
    }
    if (Platform.isMacOS) {
      map['PATH'] = getBinaryPath() + ':' + map['PATH'];
    }
    if (Platform.isWindows) {
      map['PATH'] = getBinaryPath() + ';' + map['PATH'];
    }
    return map;
  }

  static Future<bool> cmdIsExist(String cmd) async {
    // TODO 只为了适配windwos
    String stderr;
    String stdout;
    final ProcessResult result = await Process.run(
      Platform.isWindows ? 'where' : 'which',
      [cmd],
      environment: PlatformUtil.environment(),
    );
    stdout = result.stdout.toString();
    stderr = result.stderr.toString();
    // print('stderr->${result.stderr.toString()}');
    // print('stdout->${result.stdout.toString()}');
    if (Platform.isWindows)
      return stderr.isEmpty;
    else
      return stdout.isNotEmpty;
  }

  static Future<String> getPackageName() async {
    if (packageName != null) {
      return packageName;
    }
    String _packageName = '';
    Directory appDocumentsDir = await getApplicationSupportDirectory();
    _packageName = appDocumentsDir.path;
    _packageName = packageName.replaceAll('/data/user/0/', '');
    _packageName = packageName.replaceAll('/files', '');
    return _packageName;
  }

  static Future<String> workDirectory() async {
    // 获取外部储存路径的函数
    // 原path_provider中有提供，后来被删除了
    String path;
    if (Platform.isAndroid) {
      Directory storageDirectory = await getExternalStorageDirectory();
      path = storageDirectory.path.replaceAll(
        RegExp('/Android.*'),
        '',
      ); //初始化外部储存的路径
    } else if (isDesktop()) {
      path = FileSystemEntity.parentOf(Platform.resolvedExecutable);
    }
    return path;
  }

  static Future<String> getDocumentDirectory() async {
    // 获取外部储存路径的函数
    // 原path_provider中有提供，后来被删除了
    String path;
    if (Platform.isAndroid) {
      Directory storageDirectory = await getExternalStorageDirectory();
      path = storageDirectory.path.replaceAll(
        RegExp('/Android.*'),
        '',
      ); //初始化外部储存的路径
    } else if (isDesktop()) {
      path = FileSystemEntity.parentOf(Platform.resolvedExecutable);
    }
    return path;
  }
}

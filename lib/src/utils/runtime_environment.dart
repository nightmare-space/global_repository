// 多个包在单独运行的时候会是独立的包名
// 而当被集成的时候，应该拿它所集成到的项目的包名
// 所以在代码中不应该使用自身的配置文件中的路径来进行读写

import 'dart:io';

String _binKey = 'BIN';
String _tmpKey = 'TMP';
String _homeKey = 'HOME';
String _filesKey = 'FILES';
String _usrKey = 'USR';
// 在安卓端是沙盒路径
String _dataKey = 'DATA';
String _pathKey = 'PATH';

class RuntimeEnvir {
  static bool _isInit = false;
  static Map<String, String> _environment = {};

  static void initEnvirWithPackageName(String packageName) {
    if (_isInit) {
      return;
    }
    _environment[_dataKey] = '/data/data/$packageName';
    _environment[_filesKey] = '${_environment[_dataKey]}/files';
    _environment[_usrKey] = '${_environment[_filesKey]}/usr';
    _environment[_binKey] = '${_environment[_usrKey]}/bin';
    _environment[_homeKey] = '${_environment[_filesKey]}/home';
    _environment[_tmpKey] = '${_environment[_usrKey]}/tmp';
    _environment[_pathKey] =
        '${_environment[_binKey]}:' + Platform.environment['PATH'];
    _isInit = true;
  }

  static void initEnvirForDesktop() {
    if (_isInit) {
      return;
    }
    String dataPath = FileSystemEntity.parentOf(Platform.resolvedExecutable) +
        Platform.pathSeparator +
        'data';
    Directory dataDir = Directory(dataPath);
    if (!dataDir.existsSync()) {
      dataDir.createSync();
    }
    _environment[_dataKey] = dataPath;
    _environment[_filesKey] = dataPath;
    _environment[_usrKey] = '$dataPath${Platform.pathSeparator}usr';
    _environment[_binKey] =
        '${_environment[_usrKey]}${Platform.pathSeparator}bin';
    _environment[_homeKey] = '$dataPath${Platform.pathSeparator}home';
    _environment[_tmpKey] =
        '${_environment[_usrKey]}${Platform.pathSeparator}tmp';
    _isInit = true;
  }

  static void write(String key, String value) {
    _environment[key] = value;
  }

  static String getValue(String key) {
    if (_environment.containsKey(key)) {
      return _environment[key];
    }
    return '';
  }

  static String get binPath {
    if (_environment.containsKey(_binKey)) {
      return _environment[_binKey];
    }
    throw Exception();
  }

  static String get dataPath {
    if (_environment.containsKey(_dataKey)) {
      return _environment[_dataKey];
    }
    throw Exception();
  }

  static set binPath(String value) {
    _environment[_binKey] = value;
  }

  static String get usrPath {
    if (_environment.containsKey(_usrKey)) {
      return _environment[_usrKey];
    }
    throw Exception();
  }

  static set usrPath(String value) {
    _environment[_usrKey] = value;
  }

  static String get tmpPath {
    if (_environment.containsKey(_tmpKey)) {
      return _environment[_tmpKey];
    }
    throw Exception();
  }

  static set tmpPath(String value) {
    _environment[_tmpKey] = value;
  }

  static String get homePath {
    if (_environment.containsKey(_homeKey)) {
      return _environment[_homeKey];
    }
    throw Exception();
  }

  static set homePath(String value) {
    _environment[_homeKey] = value;
  }

  static String get filesPath {
    if (_environment.containsKey(_filesKey)) {
      return _environment[_filesKey];
    }
    throw Exception();
  }

  static set filesPath(String value) {
    _environment[_filesKey] = value;
  }
}

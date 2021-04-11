// 多个包在单独运行的时候会是独立的包名
// 而当被集成的时候，应该拿它所集成到的项目的包名
// 所以在代码中不应该使用自身的配置文件中的路径来进行读写
String binKey = 'BIN';
String tmpKey = 'TMP';
String homeKey = 'HOME';
String filesKey = 'FILES';
String usrKey = 'USR';

class NiEnvironment {
  static Map<String, String> _environment = {};
  static void write(String key, String value) {
    _environment['key'] = value;
  }

  static String getValue(String key) {
    if (_environment.containsKey(key)) {
      return _environment[key];
    }
    return '';
  }

  static String get binPath {
    if (_environment.containsKey(binKey)) {
      return _environment[binKey];
    }
    throw Exception();
  }

  static set binPath(String value) {
    _environment[binKey] = value;
  }

  static String get usrPath {
    if (_environment.containsKey(usrKey)) {
      return _environment[usrKey];
    }
    throw Exception();
  }

  static set usrPath(String value) {
    _environment[usrKey] = value;
  }

  static String get tmpPath {
    if (_environment.containsKey(tmpKey)) {
      return _environment[tmpKey];
    }
    throw Exception();
  }

  static set tmpPath(String value) {
    _environment[tmpKey] = value;
  }

  static String get homePath {
    if (_environment.containsKey(homeKey)) {
      return _environment[homeKey];
    }
    throw Exception();
  }

  static set homePath(String value) {
    _environment[homeKey] = value;
  }

  static String get filesPath {
    if (_environment.containsKey(filesKey)) {
      return _environment[filesKey];
    }
    throw Exception();
  }

  static set filesPath(String value) {
    _environment[filesKey] = value;
  }
}

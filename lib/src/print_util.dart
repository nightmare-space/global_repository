class PrintUtil {
  static void printn(Object object, [int color, int backgroundColor]) =>
      printd(object, color, backgroundColor);
  static void printd(Object object, [int color, int backgroundColor]) {
    String colorStr = '';
    if (color != null) {
      colorStr += ';$color';
    }
    if (backgroundColor != null) {
      colorStr += ';$backgroundColor';
    }
    print('\x1B[1$colorStr\m$object\x1B[0m');
  }

  static void printD(Object object, [List<int> colors = const []]) {
    String colorStr = '';
    if (colors.isNotEmpty) {
      colors.forEach((element) {
        colorStr += ';$element';
      });
    }
    print('\x1B[1$colorStr\m$object\x1B[0m');
  }
}

void main() {
  PrintUtil.printn('object');
  PrintUtil.printn('object', 30);
  PrintUtil.printn('object', 31);
  PrintUtil.printn('object', 32);
  PrintUtil.printn('object', 33);
  PrintUtil.printn('object', 34);
  PrintUtil.printn('object', 35);
  PrintUtil.printn('object', 36);
  PrintUtil.printn('object', 37);
  PrintUtil.printn('object', 31, 40);
  PrintUtil.printn('object', 31, 41);
  PrintUtil.printn('object', 31, 42);
  PrintUtil.printn('object', 31, 43);
  PrintUtil.printn('object', 31, 44);
  PrintUtil.printn('object', 31, 45);
  PrintUtil.printn('object', 31, 46);
  PrintUtil.printn('object', 31, 47);
  PrintUtil.printn('object', 31, 7);
  PrintUtil.printD('object', [31, 47, 7]);
  print('${'a' * 47}\x0dbbb\n');
}

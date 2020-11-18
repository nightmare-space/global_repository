class PrintUtil {
  static void printn(Object object, [int color]) {
    String colorStr = '';
    if (color != null) {
      colorStr = ';$color';
    }
    print('\x1B[1;31$colorStr\m$object\x1B[0m');
  }
}

// void main() {
//   PrintUtil.printn('object');
//   PrintUtil.printn('object', 32);
//   PrintUtil.printn('object', 33);
//   PrintUtil.printn('object', 34);
//   PrintUtil.printn('object', 35);
//   PrintUtil.printn('object', 36);
//   PrintUtil.printn('object', 37);
// }

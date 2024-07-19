import 'dart:io';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:xterm/xterm.dart';

class XTermWrapper extends StatefulWidget {
  const XTermWrapper({
    Key? key,
    required this.terminal,
    required this.fontSize,
  }) : super(key: key);
  final Terminal terminal;
  final double fontSize;

  @override
  State<XTermWrapper> createState() => _XTermWrapperState();
}

class _XTermWrapperState extends State<XTermWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
      child: TerminalView(
        widget.terminal,
        backgroundOpacity: 0,
        readOnly: true,
        keyboardType: TextInputType.text,
        textStyle: TerminalStyle(fontSize: widget.fontSize),
        theme: Platform.isAndroid ? android : theme,
      ),
    );
  }
}

TerminalTheme android = const TerminalTheme(
  cursor: Color(0XAAAEAFAD),
  selection: Color(0X22000000),
  foreground: Colors.black,
  background: Color(0XFF000000),
  black: Color(0XFF000000),
  red: Color(0XFFCD3131),
  green: Color(0XFF0DBC79),
  yellow: Color(0XFFE5E510),
  blue: Color(0XFF2472C8),
  magenta: Color(0XFFBC3FBC),
  cyan: Color(0XFF11A8CD),
  white: Color(0XFFE5E5E5),
  brightBlack: Color(0XFF666666),
  brightRed: Color(0XFFF14C4C),
  brightGreen: Color(0XFF23D18B),
  brightYellow: Color(0XFFF5F543),
  brightBlue: Color(0XFF3B8EEA),
  brightMagenta: Color(0XFFD670D6),
  brightCyan: Color(0XFF29B8DB),
  brightWhite: Color(0XFFFFFFFF),
  searchHitBackground: Color(0XFFFFFF2B),
  searchHitBackgroundCurrent: Color(0XFF31FF26),
  searchHitForeground: Color(0XFF000000),
);

TerminalTheme theme = const TerminalTheme(
  cursor: Color(0XAAAEAFAD),
  selection: Color(0X22000000),
  foreground: Color(0XFF000000),
  background: Color(0XFF000000),
  black: Color(0XFF000000),
  red: Color(0XFFCD3131),
  green: Color(0XFF0DBC79),
  yellow: Color(0XFFE5E510),
  blue: Color(0XFF2472C8),
  magenta: Color(0XFFBC3FBC),
  cyan: Color(0XFF11A8CD),
  white: Color(0XFFE5E5E5),
  brightBlack: Color(0XFF666666),
  brightRed: Color(0XFFF14C4C),
  brightGreen: Color(0XFF23D18B),
  brightYellow: Color(0XFFF5F543),
  brightBlue: Color(0XFF3B8EEA),
  brightMagenta: Color(0XFFD670D6),
  brightCyan: Color(0XFF29B8DB),
  brightWhite: Color(0XFFFFFFFF),
  searchHitBackground: Color(0XFFFFFF2B),
  searchHitBackgroundCurrent: Color(0XFF31FF26),
  searchHitForeground: Color(0XFF000000),
);

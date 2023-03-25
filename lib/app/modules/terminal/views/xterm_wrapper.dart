import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pty/pty.dart';
import 'package:xterm/xterm.dart';

class XTermWrapper extends StatefulWidget {
  const XTermWrapper({
    Key key,
    this.terminal,
    this.pseudoTerminal,
  }) : super(key: key);
  final Terminal terminal;
  final PseudoTerminal pseudoTerminal;

  @override
  State<XTermWrapper> createState() => _XTermWrapperState();
}

class _XTermWrapperState extends State<XTermWrapper> {
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    // print('$this init');
    // print('\x1b[31m监听的id 为${pseudoTerminal.pseudoTerminalId}');
    // 延时有用，是termare_app引起的。
    // PageView.builder会在短时间init与dispose这个widget
    // if (!mounted) {
    //   return;
    // }
    widget.terminal.onOutput = (data) {
      widget.pseudoTerminal.write(data);
    };

    widget.terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      widget.pseudoTerminal.resize(width, height);
    };
    streamSubscription ??= widget.pseudoTerminal.out.listen(
      (String data) {
        widget.terminal.write(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TerminalView(
      widget.terminal,
      backgroundOpacity: 0,
      keyboardType: TextInputType.text,
      theme: GetPlatform.isAndroid ? android : theme,
    );
  }
}

TerminalTheme android = const TerminalTheme(
  cursor: Color(0XAAAEAFAD),
  selection: Color(0XFFFFFF40),
  foreground: Colors.white,
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
  selection: Color(0XFFFFFF40),
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

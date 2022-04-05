import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pty/pty.dart';
import 'package:xterm/next.dart';

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
    if (!mounted) {
      return;
    }
    widget.terminal.onOutput = (data) {
      widget.pseudoTerminal.write(data);
    };
    streamSubscription ??= widget.pseudoTerminal.out.listen(
      (String data) {
        widget.terminal.write(data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TerminalView(widget.terminal);
  }
}

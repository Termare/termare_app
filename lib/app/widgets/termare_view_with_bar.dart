import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:pty/pty.dart';
import 'package:xterm/xterm.dart';
import 'term_bottom_bar.dart';

class TermareViewWithBottomBar extends StatefulWidget {
  const TermareViewWithBottomBar({
    Key key,
    this.termview,
    this.pseudoTerminal,
    this.terminal,
  }) : super(key: key);
  final Widget termview;
  final PseudoTerminal pseudoTerminal;
  final Terminal terminal;
  @override
  _TermareViewWithBottomBarState createState() =>
      _TermareViewWithBottomBarState();
}

class _TermareViewWithBottomBarState extends State<TermareViewWithBottomBar> {
  @override
  void dispose() {
    super.dispose();
  }

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle.light;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: widget.termview,
                  ),
                  TerminalFoot(
                    pseudoTerminal: widget.pseudoTerminal,
                    terminal: widget.terminal,
                  ),
                ],
              ),
              // if (PlatformUtil.isDesktop())
              //   Align(
              //     alignment: Alignment.topRight,
              //     child: SizedBox(
              //       height: 32.0,
              //       child: IconButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         icon: const Icon(
              //           Icons.clear,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

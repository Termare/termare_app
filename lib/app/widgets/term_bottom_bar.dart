import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_repository/src/utils/screen_util.dart';
import 'package:pty/pty.dart';
import 'package:xterm/input/keys.dart';
import 'package:xterm/next/terminal.dart';

class TerminalFoot extends StatefulWidget {
  const TerminalFoot({Key key, this.pseudoTerminal, this.terminal})
      : super(key: key);
  final PseudoTerminal pseudoTerminal;
  final Terminal terminal;

  @override
  _TerminalFootState createState() => _TerminalFootState();
}

class _TerminalFootState extends State<TerminalFoot>
    with SingleTickerProviderStateMixin {
  Color defaultDragColor = Colors.white.withOpacity(0.4);
  Animation<double> height;
  AnimationController controller;
  Color dragColor;
  @override
  void initState() {
    super.initState();
    dragColor = defaultDragColor;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    height = Tween<double>(begin: 18.0, end: 82).animate(CurvedAnimation(
      curve: Curves.easeIn,
      parent: controller,
    ));
    height.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 414.w,
      height: height.value,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanDown: (_) {
                dragColor = Colors.white.withOpacity(0.8);
                setState(() {});
              },
              onPanCancel: () {
                dragColor = defaultDragColor;
                setState(() {});
              },
              onPanEnd: (_) {
                dragColor = defaultDragColor;
                setState(() {});
              },
              onTap: () {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: SizedBox(
                height: 16,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: dragColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'ESC',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([0x1b]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'TAB',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([9]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'CTRL',
                    enable: false,
                    onTap: () {
                      // widget.pseudoTerminal.enbaleOrDisableCtrl();
                      // setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'ALT',
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '－',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([110 - 96]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '↑',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([112 - 96]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '↲',
                    onTap: () {
                      widget.terminal.keyInput(TerminalKey.enter);
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([110 - 96]),
                      // );
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'INS',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([0x1b]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'END',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([9]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: 'SHIFT',
                    onTap: () {
                      // widget.pseudoTerminal.enbaleOrDisableCtrl();
                      // setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: ':',
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '←',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([112 - 96]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '↓',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([110 - 96]),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: BottomItem(
                    pseudoTerminal: widget.pseudoTerminal,
                    title: '→',
                    onTap: () {
                      // widget.pseudoTerminal.input?.call(
                      //   utf8.decode([110 - 96]),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomItem extends StatefulWidget {
  const BottomItem({
    Key key,
    this.pseudoTerminal,
    this.title,
    this.onTap,
    this.enable = false,
  }) : super(key: key);
  final PseudoTerminal pseudoTerminal;
  final String title;
  final void Function() onTap;
  final bool enable;

  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> {
  Color backgroundColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTap: widget.onTap,
      onPanDown: (_) {
        widget.onTap?.call();
        backgroundColor = Colors.white.withOpacity(0.2);
        setState(() {});
        Feedback.forLongPress(context);
      },
      onPanEnd: (_) {
        backgroundColor = Colors.transparent;
        setState(() {});
        Feedback.forLongPress(context);
      },
      onPanCancel: () {
        backgroundColor = Colors.transparent;
        setState(() {});
        Feedback.forLongPress(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.enable ? Colors.white.withOpacity(0.4) : backgroundColor,
        ),
        height: 30,
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

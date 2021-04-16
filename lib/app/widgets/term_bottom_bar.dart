import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:termare_view/termare_view.dart';

class TermBottomBar extends StatefulWidget {
  const TermBottomBar({Key key, this.controller}) : super(key: key);
  final TermareController controller;
  @override
  _TermBottomBarState createState() => _TermBottomBarState();
}

class _TermBottomBarState extends State<TermBottomBar> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: widget.controller.theme.backgroundColor,
        child: SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: 'ESC',
                  onTap: () {
                    widget.controller.input(
                      utf8.decode([0x1b]),
                    );
                  },
                ),
              ),
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: 'TAB',
                  onTap: () {
                    widget.controller.input(
                      utf8.decode([9]),
                    );
                  },
                ),
              ),
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: 'CTRL',
                  enable: widget.controller.ctrlEnable,
                  onTap: () {
                    widget.controller.enbaleOrDisableCtrl();
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: 'ALT',
                ),
              ),
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: '↑',
                  onTap: () {
                    widget.controller.input(
                      utf8.decode([112 - 96]),
                    );
                  },
                ),
              ),
              Expanded(
                child: BottomItem(
                  controller: widget.controller,
                  title: '↓',
                  onTap: () {
                    widget.controller.input(
                      utf8.decode([110 - 96]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomItem extends StatefulWidget {
  const BottomItem({
    Key key,
    this.controller,
    this.title,
    this.onTap,
    this.enable = false,
  }) : super(key: key);
  final TermareController controller;
  final String title;
  final void Function() onTap;
  final bool enable;

  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> {
  Color backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = widget.controller.theme.backgroundColor;
    widget.controller.addListener(updateBackground);
  }

  void updateBackground() {
    backgroundColor = widget.controller.theme.backgroundColor;
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(updateBackground);
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
        backgroundColor = widget.controller.theme.backgroundColor;
        setState(() {});
        Feedback.forLongPress(context);
      },
      onPanCancel: () {
        backgroundColor = widget.controller.theme.backgroundColor;
        setState(() {});
        Feedback.forLongPress(context);
      },
      // highlightColor: Colors.white.withOpacity(0.4),
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.enable ? Colors.white.withOpacity(0.4) : backgroundColor,
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.controller.theme.defaultFontColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:pty/pty.dart';
import 'package:termare_app/app/modules/dashboard/views/dashboard.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_view/termare_view.dart';
import 'package:xterm/next.dart';

import '../../setting/views/setting_page.dart';

class PtyTermEntity {
  PtyTermEntity(
    this.controller,
    this.pseudoTerminal,
    this.terminal,
  );
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
  final Terminal terminal;
  @override
  bool operator ==(dynamic other) {
    // 判断是否是非
    if (other is! TermareController) {
      return false;
    }
    if (other is TermareController) {
      return other.hashCode == hashCode;
    }
    return false;
  }

  @override
  int get hashCode => pseudoTerminal.hashCode;
}

class TerminalPages extends StatefulWidget {
  TerminalPages({
    Key key,
    this.packageName,
  }) : super(key: key) {
    if (packageName != null) {
      // 改包可能是被其他项目集成的
      Config.packageName = packageName;
      Config.flutterPackage = 'packages/termare_app/';
    }
    if (Get.arguments != null) {
      Config.packageName = Get.arguments.toString();
      Config.flutterPackage = 'packages/termare_app/';
    }
  }

  final String packageName;

  @override
  _TerminalPagesState createState() => _TerminalPagesState();
}

class _TerminalPagesState extends State<TerminalPages>
    with TickerProviderStateMixin {
  TerminalController controller = Get.find();
  PageController pageController = PageController();
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    if (controller.terms.isEmpty) {
      controller.createPtyTerm().then((value) {
        setState(() {});
      });
    }
  }

  double offset = 0;
  double maxSize = 10000;
  double _getPixels(double page) {
    return page * Get.size.width;
  }

  double _getPage(double pixels) {
    return pixels / Get.size.width;
  }

  double _getTargetPixels(
    double pixels,
    Tolerance tolerance,
    double velocity,
  ) {
    double page = _getPage(pixels);
    Log.e('page -> $page');
    if (pixels < 0) {
      // return 0;
    }
    if (pixels >= maxSize) {
      return maxSize;
    }
    if (true) {
      if (velocity < -tolerance.velocity) {
        page -= 0.5;
      } else if (velocity > tolerance.velocity) {
        page += 0.5;
      }
      return _getPixels(page.roundToDouble());
    }
    return _getPixels(page.roundToDouble());
  }

  final Tolerance _kDefaultTolerance = Tolerance(
    // TODO(ianh): Handle the case of the device pixel ratio changing.
    // TODO(ianh): Get this from the local MediaQuery not dart:ui's window object.
    velocity: 1.0 /
        (0.050 *
            WidgetsBinding
                .instance.window.devicePixelRatio), // logical pixels per second
    distance:
        1.0 / WidgetsBinding.instance.window.devicePixelRatio, // logical pixels
  );

  @override
  Widget build(BuildContext context) {
    final Map<int, Widget> map = {
      1: Builder(builder: (context) {
        double _offset;
        if (offset >= 0) {
          if (offset < Get.size.width / 2) {
            _offset = offset;
          } else {
            _offset = Get.size.width - offset;
          }
        } else if (offset < 0) {
          if (offset.abs() < Get.size.width / 2) {
            _offset = offset;
          } else {
            // Log.d('offset $offset');
            _offset = -Get.size.width - offset;
          }
        }
        return GetBuilder<TerminalController>(builder: (context) {
          return Transform(
            transform: Matrix4.identity()..translate(_offset),
            // ..scale(((Get.width - _offset.abs()) / Get.width) / 2 + 1 / 2),
            alignment: Alignment.center,
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Opacity(
                opacity: 1.0 - 1.0 * _offset.abs() / Get.size.width,
                child: controller.getCurTerm(),
              ),
            ),
          );
        });
      }),
    };
    if (offset < 0) {
      map[0] = Builder(builder: (context) {
        double _offset;
        if (offset.abs() < Get.size.width / 2) {
          _offset = -offset;
        } else {
          _offset = offset + Get.size.width;
        }
        return Opacity(
          opacity: 1.0,
          child: Transform(
            transform: Matrix4.identity()..translate(_offset),
            // ..scale(0.8),
            alignment: Alignment.center,
            child: SettingPage(),
          ),
        );
      });
      if (offset.abs() > Get.size.width / 2) {
        final Widget tmp = map[1];
        map[1] = map[0];
        map[0] = tmp;
      }
    } else {
      map[0] = Builder(builder: (context) {
        double _offset;
        if (offset < Get.size.width / 2) {
          _offset = -offset;
        } else {
          _offset = offset - Get.size.width;
        }
        return Transform(
          transform: Matrix4.identity()..translate(_offset),
          // ..scale(((Get.width - _offset.abs()) / Get.width) / 2 + 1 / 2),
          alignment: Alignment.center,
          child: Opacity(
            // opacity: 1.0 - 1.0 * (_offset.abs() / Get.size.width),
            opacity: 1.0,
            child: DashBoard(
              onSelect: () {
                animationController = AnimationController(
                  vsync: this,
                  value: Get.width,
                  lowerBound: 0,
                  upperBound: Get.width,
                  duration: Duration(milliseconds: 300),
                );
                animationController.reset();
                animationController.addListener(() {
                  offset = animationController.value;
                  // Log.d(offset);
                  setState(() {});
                });
                animationController.value = Get.width;
                animationController.reverse();
              },
            ),
          ),
        );
      });
      // Log.d('offset $offset');
      // Log.d('Get.size.width / 2 ${Get.size.width / 2}');
      if (offset > Get.size.width / 2) {
        Widget tmp = map[1];
        map[1] = map[0];
        map[0] = tmp;
      }
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GetBuilder<TerminalController>(
        init: TerminalController(),
        builder: (_) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (details) {
              animationController?.stop();
            },
            onHorizontalDragUpdate: (details) {
              offset += details.delta.dx;
              // Log.e(offset);
              setState(() {});
            },
            onHorizontalDragEnd: (details) {
              double velocity = details.velocity.pixelsPerSecond.dx;
              double start = offset;
              double target = _getTargetPixels(
                start,
                _kDefaultTolerance,
                velocity,
              );
              final spring = SpringDescription.withDampingRatio(
                mass: 0.5,
                stiffness: 100.0,
                ratio: 1.1,
              );
              final ScrollSpringSimulation scrollSpringSimulation =
                  ScrollSpringSimulation(
                spring,
                start,
                target,
                velocity,
                tolerance: _kDefaultTolerance,
              );
              animationController = AnimationController(
                vsync: this,
                value: 0,
                lowerBound: double.negativeInfinity,
                upperBound: double.infinity,
              );
              animationController.reset();
              animationController.addListener(() {
                offset = animationController.value;
                // Log.d(offset);
                setState(() {});
              });
              animationController.animateWith(scrollSpringSimulation);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                map[0],
                map[1],
              ],
            ),
          );
        },
      ),
    );
  }
}

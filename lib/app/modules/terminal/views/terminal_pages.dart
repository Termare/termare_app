import 'dart:ui';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_title.dart';
import 'package:termare_app/app/widgets/custom_icon_button.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';

import '../../setting/views/setting_page.dart';
import 'quark_window_check.dart';

class PtyTermEntity {
  PtyTermEntity(
    this.controller,
    this.pseudoTerminal,
  );
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
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
  int get hashCode => pseudoTerminal.pseudoTerminalId.hashCode;
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
    with SingleTickerProviderStateMixin {
  TerminalController controller;
  PageController pageController = PageController();
  PageController titleController = PageController();
  String titleName = '终端[0]';
  @override
  void initState() {
    super.initState();
    controller = Get.find();
    if (controller.terms.isEmpty) {
      controller.createPtyTerm().then((value) {
        setState(() {});
      });
    }
    pageController.addListener(() {
      print(pageController.page.round());
      // if (pageController.page.toString().split('.').last == '0') {
      if (titleName != '终端[${pageController.page.round()}]') {
        titleName = '终端[${pageController.page.round()}]';
        titleController.animateToPage(
          pageController.page.round(),
          duration: Duration(
            milliseconds: 300,
          ),
          curve: Curves.ease,
        );
        setState(() {});
      }
      // print(pageController.page);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: TermareStyles.vsCode.backgroundColor,
        // backgroundColor: Color(0xfff3efef),
        body: SafeArea(
          child: GetBuilder<TerminalController>(
            init: TerminalController(),
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Material(
                  //   color: Color(0xfff3efef),
                  //   child: SizedBox(
                  //     height: 36,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             '$titleName -> ',
                  //             style: const TextStyle(
                  //               height: 1.0,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: LayoutBuilder(
                  //               builder: (_, BoxConstraints constraints) {
                  //                 // print('$constraints');
                  //                 return SizedBox(
                  //                   height: 36,
                  //                   child: PageView.builder(
                  //                     physics: NeverScrollableScrollPhysics(),
                  //                     itemCount: controller.terms.length,
                  //                     controller: titleController,
                  //                     itemBuilder: (c, i) {
                  //                       return TerminalTitle(
                  //                         controller:
                  //                             controller.terms[i].controller,
                  //                       );
                  //                     },
                  //                   ),
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //           NiIconButton(
                  //             child: const Icon(Icons.filter_none),
                  //             onTap: () async {
                  //               print(
                  //                   'pageController.page-> ${pageController.page}');
                  //               final int index = await Get.to<int>(
                  //                 QuarkWindowCheck(
                  //                   children: controller.getPtyTermsForCheck(),
                  //                   page: pageController.page.toInt(),
                  //                 ),
                  //               );
                  //               if (index != null) {
                  //                 pageController.jumpToPage(index);
                  //               }
                  //             },
                  //           ),
                  //           NiIconButton(
                  //             child: const Icon(Icons.add),
                  //             onTap: () async {
                  //               await controller.createPtyTerm();
                  //               setState(() {});
                  //               pageController.animateToPage(
                  //                 controller.terms.length - 1,
                  //                 duration: const Duration(milliseconds: 300),
                  //                 curve: Curves.ease,
                  //               );
                  //             },
                  //           ),
                  //           NiIconButton(
                  //             child: const Icon(Icons.settings),
                  //             onTap: () {
                  //               Get.to(SettingPage());
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      children: controller.getPtyTerms(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

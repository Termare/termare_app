import 'dart:io';
import 'dart:ui';
import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/app/widgets/termare_view_with_bar.dart';
import 'package:termare_app/config/config.dart';
import 'package:provider/provider.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';
import 'download_bootstrap_page.dart';
import 'quark_window_check.dart';
import '../../setting/views/setting_page.dart';

class PtyTermEntity {
  PtyTermEntity(
    this.controller,
    this.pseudoTerminal,
  );
  final TermareController controller;
  final PseudoTerminal pseudoTerminal;
}

class TerminalPages extends StatefulWidget {
  const TerminalPages({Key key, this.terminalIndex = 0}) : super(key: key);
  final int terminalIndex;
  @override
  _TerminalPagesState createState() => _TerminalPagesState();
}

class _TerminalPagesState extends State<TerminalPages>
    with SingleTickerProviderStateMixin {
  TerminalController controller;
  PageController pageController = PageController();
  String titleName = '终端[0]';
  @override
  void initState() {
    super.initState();
    Get.put(TerminalController());
    controller = Get.find();
    if (controller.terms.isEmpty) {
      controller.createPtyTerm();
    }
    pageController.addListener(() {
      print(pageController.page.round());
      // if (pageController.page.toString().split('.').last == '0') {
      if (titleName != '终端[${pageController.page.round()}]') {
        titleName = '终端[${pageController.page.round()}]';
        setState(() {});
      }
      // print(pageController.page);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // pageController.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        // color: widget.,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GetBuilder<TerminalController>(
              init: TerminalController(),
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 36,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Builder(
                              builder: (_) {
                                return Text(
                                  '$titleName ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.filter_none),
                                  onPressed: () async {
                                    print(
                                        'pageController.page-> ${pageController.page}');
                                    final int index = await Get.to<int>(
                                      QuarkWindowCheck(
                                        children:
                                            controller.getPtyTermsForCheck(),
                                        page: pageController.page.toInt(),
                                      ),
                                    );
                                    if (index != null) {
                                      pageController.jumpToPage(index);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    await controller.createPtyTerm();
                                    setState(() {});
                                    pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Get.to(SettingPage());
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
      ),
    );
  }
}

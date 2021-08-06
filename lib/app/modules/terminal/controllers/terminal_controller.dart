import 'dart:io';
import 'dart:ui';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/app/modules/setting/controllers/setting_controller.dart';
import 'package:termare_app/app/modules/setting/models_model.dart';
import 'package:termare_app/app/modules/terminal/views/download_bootstrap_page.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_app/app/widgets/termare_view_with_bar.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';

class TerminalController extends GetxController {
  List<PtyTermEntity> terms = [];

  SettingController settingController = Get.find<SettingController>();

  Future<void> createPtyTerm() async {
    bool isFirst = false;
    final SettingInfo settingInfo = settingController.settingInfo;
    if (Platform.isAndroid) {
      final File bashFile = File(RuntimeEnvir.binPath + '/bash');
      final bool exist = bashFile.existsSync();
      if (!exist) {
        // 初始化后 bash 应该存在
        isFirst = true;
        // 这个 await 为了不弹太快
        await Future.delayed(const Duration(milliseconds: 300));
        await showCustomDialog<void>(
          bval: false,
          context: Get.overlayContext,
          child: DownloadBootPage(),
        );
      }
    }
    String executable = '';
    if (Platform.environment.containsKey('SHELL')) {
      executable = Platform.environment['SHELL'];
      executable = executable.replaceAll(RegExp('.*/'), '');
    } else {
      if (Platform.isMacOS) {
        executable = 'bash';
      } else if (Platform.isWindows) {
        executable = 'wsl';
      } else if (Platform.isAndroid) {
        executable = settingInfo.cmdLine;
        final Directory directory = Directory(RuntimeEnvir.homePath);
        if (!directory.existsSync()) {
          directory.createSync();
        }
      }
    }
    final Map<String, String> environment = {
      'TERM': 'xterm-256color',
      'PATH': PlatformUtil.environment()['PATH'],
    };
    String workingDirectory = '.';
    if (Platform.isAndroid) {
      environment['HOME'] = RuntimeEnvir.homePath;
      environment['TMPDIR'] = RuntimeEnvir.tmpPath;
      workingDirectory = RuntimeEnvir.homePath;
    } else {
      environment['HOME'] = PlatformUtil.environment()['HOME'];
    }
    final TermareController controller = TermareController(
      fontFamily: Config.flutterPackage + settingInfo.fontFamily,
      terminalTitle: 'localhost',
      theme: TermareStyle.parse(settingInfo.termStyle).copyWith(
        fontSize: settingInfo.fontSize.toDouble(),
      ),
    );
    final Size size = window.physicalSize;
    final double screenWidth = size.width / window.devicePixelRatio;
    final double screenHeight = size.height / window.devicePixelRatio;
    controller.setWindowSize(Size(screenWidth, screenHeight));
    print(
        '$executable ${Size(screenWidth, screenHeight)} ${controller.row} ${controller.column}');
    final PseudoTerminal pseudoTerminal = PseudoTerminal(
      executable: executable,
      workingDirectory: workingDirectory,
      environment: environment,
      row: controller.row,
      // 不能减一了
      column: controller.column,
      arguments: ['-l'],
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (settingInfo.initCmd.isNotEmpty) {
        pseudoTerminal.write(settingInfo.initCmd + '\n');
      }
      if (isFirst) {
        pseudoTerminal.write('apt update' '\n');
      }
    });
    if (settingInfo.vibrationWhenEscapeA) {
      controller.onBell = () {
        Feedback.forLongPress(Get.context);
      };
    }

    terms.add(
      PtyTermEntity(controller, pseudoTerminal),
    );

    // await pseudoTerminal.defineTermFunc(func: '''
    // function sync_repository(){
    //   apt update
    //   apt upgrade
    // }
    // ''');
    // pseudoTerminal.write('sync_repository\n');
    update();
  }

  List<Widget> getPtyTermsForCheck() {
    final List<Widget> widgets = [];
    final List<PtyTermEntity> terms = this.terms;
    for (int i = 0; i < terms.length; i++) {
      final PtyTermEntity entity = terms[i];
      widgets.add(Hero(
        tag: '$i',
        child: TermarePty(
          key: Key('$i'),
          controller: entity.controller,
          pseudoTerminal: entity.pseudoTerminal,
        ),
      ));
    }
    return widgets;
  }

  List<Widget> getPtyTerms() {
    final List<Widget> widgets = [];
    final List<PtyTermEntity> terms = this.terms;
    for (int i = 0; i < terms.length; i++) {
      final PtyTermEntity entity = terms[i];
      widgets.add(
        Hero(
          tag: '$i',
          child: TermareViewWithBottomBar(
            controller: entity.controller,
            termview: TermarePty(
              key: Key('$i'),
              controller: entity.controller,
              pseudoTerminal: entity.pseudoTerminal,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

import 'dart:io';
import 'dart:ui';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:pseudo_terminal_utils/pseudo_terminal_utils.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:termare_app/app/modules/setting/controllers/setting_controller.dart';
import 'package:termare_app/app/modules/setting/models_model.dart';
import 'package:termare_app/app/modules/terminal/views/download_bootstrap_page.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_app/app/widgets/termare_view_with_bar.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';

String lockFile = RuntimeEnvir.dataPath + '/cache/init_lock';

String initShell = '''
function initApp(){
  cd ${RuntimeEnvir.usrPath}/
  echo 准备符号链接...
  for line in `cat SYMLINKS.txt`
  do
    OLD_IFS="\$IFS"
    IFS="←"
    arr=(\$line)
    IFS="\$OLD_IFS"
    ln -s \${arr[0]} \${arr[3]}
  done
  rm -rf SYMLINKS.txt
  TMPDIR=/data/data/com.nightmare.termare/files/usr/tmp
  filename=bootstrap
  rm -rf "\$TMPDIR/\$filename*"
  rm -rf "\$TMPDIR/*"
  chmod -R 0777 ${RuntimeEnvir.binPath}/*
  chmod -R 0777 ${RuntimeEnvir.usrPath}/lib/* 2>/dev/null
  chmod -R 0777 ${RuntimeEnvir.usrPath}/libexec/* 2>/dev/null
  echo "\x1b[0;31m- 执行 apt update\x1b[0m"
  apt update
  echo -e "\x1b[0;32m一切处理结束\x1b[0m"
  rm -rf $lockFile
  bash
}
''';

class TerminalController extends GetxController {
  List<PtyTermEntity> terms = [];
  int currentTerminal = 0;
  // final player = AudioPlayer();
  SettingController settingController = Get.find<SettingController>();
  bool hasBash() {
    final File bashFile = File(RuntimeEnvir.binPath + '/bash');
    final bool exist = bashFile.existsSync();
    return exist;
  }

  Future<void> createPtyTerm() async {
    // final duration = await player.setAsset(
    //   Assets.ogg,
    // );
    final SettingInfo settingInfo = settingController.settingInfo;
    final TermareController controller = TermareController(
      fontFamily: Config.flutterPackage + settingInfo.fontFamily,
      terminalTitle: 'localhost',
      theme: TermareStyle.parse(settingInfo.termStyle).copyWith(
        fontSize: settingInfo.fontSize.toDouble(),
      ),
    );
    if (Platform.isAndroid) {
      if (!hasBash()) {
        // 初始化后 bash 应该存在
        initTerminal(controller);
        return;
      }
    }
    final Size size = window.physicalSize;
    final double screenWidth = size.width / window.devicePixelRatio;
    final double screenHeight = size.height / window.devicePixelRatio;
    controller.setWindowSize(Size(screenWidth, screenHeight));
    final PseudoTerminal pseudoTerminal = TerminalUtil.getShellTerminal(
      exec: settingInfo.cmdLine,
      row: controller.row,
      column: controller.column,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (settingInfo.initCmd.isNotEmpty) {
        pseudoTerminal.write(settingInfo.initCmd + '\n');
      }
    });
    if (settingInfo.vibrationWhenEscapeA) {
      controller.onBell = () async {
        Feedback.forLongPress(Get.context);
        // player.play();
      };
    }
    terms.add(
      PtyTermEntity(controller, pseudoTerminal),
    );
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

  Future<void> initTerminal(TermareController controller) async {
    // 这个 await 为了不弹太快
    await Future.delayed(const Duration(milliseconds: 300));
    await Get.dialog(DownloadBootPage());
    final PseudoTerminal pseudoTerminal = TerminalUtil.getShellTerminal(
      home: RuntimeEnvir.filesPath,
      useIsolate: false,
    );
    pseudoTerminal.startPolling();
    await pseudoTerminal.defineTermFunc(
      initShell,
      tmpFilePath: RuntimeEnvir.filesPath + '/define',
    );
    Log.i('初始化成功');
    pseudoTerminal.write('initApp\n');
    terms.add(
      PtyTermEntity(controller, pseudoTerminal),
    );
    update();
  }

  void switchTo(int value) {
    currentTerminal = value;
    update();
  }

  Widget getCurTerm() {
    if (terms.isEmpty) {
      return const SizedBox();
    }
    final PtyTermEntity entity = terms[currentTerminal];
    return Hero(
      tag: '$currentTerminal',
      child: TermareViewWithBottomBar(
        controller: entity.controller,
        termview: TermarePty(
          key: Key('$currentTerminal'),
          controller: entity.controller,
          pseudoTerminal: entity.pseudoTerminal,
        ),
      ),
    );
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

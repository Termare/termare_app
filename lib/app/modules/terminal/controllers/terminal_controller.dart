import 'dart:io';
import 'dart:ui';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/app/modules/terminal/views/download_bootstrap_page.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_app/app/widgets/termare_view_with_bar.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';

class TerminalController extends GetxController {
  List<PtyTermEntity> terms = [];

  Future<void> createPtyTerm() async {
    if (Platform.isAndroid) {
      final File bashFile = File(Config.binPath + '/bash');
      final bool exist = bashFile.existsSync();
      if (!exist) {
        await Future.delayed(const Duration(milliseconds: 300));
        await showCustomDialog<void>(
          bval: false,
          context: Get.overlayContext,
          child: DownloadBootPage(),
        );
      }
    }
    String executable = '';
    if (Platform.isMacOS) {
      executable = 'bash';
    } else if (Platform.isWindows) {
      executable = 'wsl';
    } else if (Platform.isAndroid) {
      if (File('${PlatformUtil.getBinaryPath()}/login').existsSync()) {
        executable = 'login';
      } else {
        executable = 'sh';
      }
      final Directory directory = Directory(Config.homePath);
      if (!directory.existsSync()) {
        directory.createSync();
      }
    }
    final Map<String, String> environment = {
      'TERM': 'screen-256color',
      'PATH': PlatformUtil.environment()['PATH'],
    };
    if (Platform.isAndroid) {
      environment['HOME'] = Config.homePath;
      environment['TMPDIR'] = Config.tmpPath;
    }
    final TermSize size = TermSize.getTermSize(window.physicalSize);
    final PseudoTerminal pseudoTerminal = PseudoTerminal(
      executable: executable,
      workingDirectory: Config.homePath,
      environment: environment,
      row: size.row,
      column: size.column,
    );
    final TermareController controller = TermareController(
      fontFamily: Config.flutterPackage + 'MenloforPowerline',
      terminalTitle: 'localhost',
      theme: TermareStyles.termux.copyWith(
        fontSize: 11,
      ),
    );
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

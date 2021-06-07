import 'dart:io';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart' as p;
import 'package:termare_pty/termare_pty.dart';
import 'package:termare_view/termare_view.dart';

String termLockFilePath = '${RuntimeEnvir.usrPath}/tmp/termare_pop_lock';

extension DefineFunc on PseudoTerminal {
  Future<void> defineTermFunc({
    @required String func,
    String tmpFilePath,
  }) async {
    tmpFilePath ??=
        RuntimeEnvir.dataPath + '${Platform.pathSeparator}defineTermFunc';
    Log.d('定义函数中...--->$tmpFilePath');

    final File tmpFile = File(tmpFilePath);
    await tmpFile.writeAsString(func);
    Log.d('创建临时脚本成功...->${tmpFile.path}');
    'export AUTO=TRUE\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );
    Log.d('script -> source ${p.basename(tmpFilePath)}');
    Log.d('rm -rf ${p.basename(tmpFilePath)}');
    'source ${p.basename(tmpFilePath)}\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );

    'rm -rf ${p.basename(tmpFilePath)}\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );
    while (true) {
      final bool exist = await tmpFile.exists();
      // 把不想被看到的代码读掉
      await read();
      // Log.d('read()------------------->$tmp');
      if (!exist) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    Log.d('创建临时脚本结束');
  }
}

class TermUtils {
  static Future<void> openTerm2({
    @required BuildContext context,
    @required TermareController controller,
    @required String exec,
    @required PseudoTerminal pseudoTerminal,
  }) async {
    pseudoTerminal.write('$exec\n');
    await Navigator.of(context).push(
      MaterialPageRoute<TermareView>(
        builder: (_) {
          return WillPopScope(
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Material(
                color: controller.theme.backgroundColor,
                child: SafeArea(
                  child: TermarePty(
                    controller: controller,
                    pseudoTerminal: pseudoTerminal,
                  ),
                ),
              ),
            ),
            onWillPop: () async {
              final bool isLock = File(termLockFilePath).existsSync();
              if (isLock) {
                showToast('请等待返回键释放');
              }
              Log.d(isLock);
              return !isLock;
            },
          );
        },
      ),
    );
  }
}

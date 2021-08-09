import 'dart:io';

import 'package:global_repository/global_repository.dart';
import 'package:termare_pty/termare_pty.dart';

extension DefineFunction on PseudoTerminal {
  Future<void> defineTermFunc(
    String function, {
    String tmpFilePath,
  }) async {
    tmpFilePath ??= RuntimeEnvir.tmpPath + '/defineTermFunc';
    Log.d('定义函数中...--->$tmpFilePath');
    // Log.w(function);
    final File tmpFile = File(tmpFilePath);
    await tmpFile.writeAsString(function);
    Log.d('创建临时脚本成功...->${tmpFile.path}');
    'export AUTO=TRUE\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );
    Log.d('script -> source $tmpFilePath');
    Log.d('rm -rf $tmpFilePath');
    'source $tmpFilePath\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );

    'rm -rf $tmpFilePath\n'.split('').forEach(
      (String element) {
        write(element);
      },
    );
    while (true) {
      // ignore: avoid_slow_async_io
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

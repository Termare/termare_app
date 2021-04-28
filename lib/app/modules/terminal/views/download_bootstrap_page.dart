import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/config/config.dart';

class DownloadBootPage extends StatefulWidget {
  @override
  _DownloadBootPageState createState() => _DownloadBootPageState();
}

class _DownloadBootPageState extends State<DownloadBootPage> {
  @override
  Widget build(BuildContext context) {
    return FullHeightListView(
      child: _DownloadFile(),
    );
  }
}

class _DownloadFile extends StatefulWidget {
  const _DownloadFile({Key key, this.callback}) : super(key: key);
  final void Function() callback;
  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<_DownloadFile> {
  final Dio dio = Dio();
  Response<String> response;
  final String filesPath = RuntimeEnvir.usrPath;
  List<String> androidAdbFiles = [
    'https://nightmare-my.oss-cn-beijing.aliyuncs.com/Termare/bootstrap-aarch64.zip',
  ];

  double fileDownratio = 0.0;
  String title = '';
  Future<void> downloadFile(String urlPath) async {
    print(urlPath);
    response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    // final String _human = getFileSize(_fullByte); //拿到可读的文件大小返回给用户
    print('fullByte======$fullByte ${PlatformUtil.getFileName(urlPath)}');
    final String savePath = filesPath + '/' + PlatformUtil.getFileName(urlPath);
    // print(savePath);
    await dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (count, total) {
        final double process = count / total;
        fileDownratio = process;
        setState(() {});
        // );
      },
    );
    Process.runSync('chmod', <String>[
      '0777',
      savePath,
    ]);
    await installModule(savePath);
  }

  Future<void> installModule(String modulePath) async {
    title = '解压中...';
    setState(() {});
    // Read the Zip file from disk.
    final bytes = File(modulePath).readAsBytesSync();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    // Extract the contents of the Zip archive to disk.
    final int total = archive.length;
    int count = 0;
    // print('total -> $total count -> $count');
    for (final file in archive) {
      final filename = file.name;
      // print(filename);
      if (file.isFile) {
        final data = file.content as List<int>;
        await File('${RuntimeEnvir.usrPath}/' + filename).create(
          recursive: true,
        );
        await File('${RuntimeEnvir.usrPath}/' + filename).writeAsBytes(data);
      } else {
        Directory('${RuntimeEnvir.usrPath}/' + filename).create(
          recursive: true,
        );
      }
      count++;
      fileDownratio = count / total;
      print('total -> $total count -> $count');
      setState(() {});
    }
    File(modulePath).delete();
    title = '配置中...';
    fileDownratio = null;
    setState(() {});
    await exec('''
    cd ${RuntimeEnvir.usrPath}/
    for line in `cat SYMLINKS.txt`
    do
      OLD_IFS="\$IFS"
      IFS="←"
      arr=(\$line)
      IFS="\$OLD_IFS"
      ln -s \${arr[0]} \${arr[3]}
    done
    rm -rf SYMLINKS.txt
    chmod -R 0777 ${RuntimeEnvir.binPath}/*
    chmod -R 0777 ${RuntimeEnvir.usrPath}/libexec/* 2>/dev/null
    chmod -R 0777 ${RuntimeEnvir.usrPath}/lib/apt/methods/* 2>/dev/null
    ''');
  }

  @override
  void initState() {
    super.initState();
    execDownload();
  }

  Future<void> execDownload() async {
    List<String> needDownloadFile;

    if (Platform.isAndroid) {
      needDownloadFile = androidAdbFiles;
    }
    for (final String urlPath in needDownloadFile) {
      title = '下载 ${PlatformUtil.getFileName(urlPath)} 中...';
      setState(() {});
      await downloadFile(urlPath);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '进度',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              child: LinearProgressIndicator(
                value: fileDownratio,
              ),
            ),
            SizedBox(
              child: Text(
                '下载到的目录为 $filesPath',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        showToast('等待下载完成后');
        return false;
      },
    );
  }
}

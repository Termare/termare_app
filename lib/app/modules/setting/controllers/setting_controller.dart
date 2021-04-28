import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/app/modules/setting/models_model.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_view/termare_view.dart';

class SettingController extends GetxController {
  SettingInfo settingInfo;
  String filePath = RuntimeEnvir.homePath + '/.termare_setting';
  @override
  void onInit() {
    readLocalStorage();
    super.onInit();
  }

  void changeRepository() {
    // Get.dialog(Text('data'));
    final TextEditingController controller = TextEditingController(
      text: settingInfo.repository,
    );
    showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改软件源'),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: const Color(0xfff0f0f0),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.repository = controller.text;
                    showToast('目前改了没用，如果你有自己编译的可以使用的源，请联系我');
                    saveToLocal();
                    Get.back();
                  },
                  child: Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changeBufferLine() {
    TextEditingController controller = TextEditingController(
      text: settingInfo.bufferLine.toString(),
    );
    showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改缓冲行'),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: const Color(0xfff0f0f0),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.bufferLine = int.tryParse(controller.text);
                    showToast('目前改了没用');
                    saveToLocal();
                    Get.back();
                  },
                  child: Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changeCmdLine() {
    TextEditingController controller = TextEditingController(
      text: settingInfo.cmdLine.toString(),
    );
    showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改命令行'),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: const Color(0xfff0f0f0),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.cmdLine = controller.text;
                    saveToLocal();
                    showToast('更改成功');
                    Get.back();
                  },
                  child: Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changeInitCmd() {
    TextEditingController controller = TextEditingController(
      text: settingInfo.initCmd.toString(),
    );
    showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改初始命令'),
            SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  fillColor: const Color(0xfff0f0f0),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.initCmd = controller.text;
                    saveToLocal();
                    showToast('更改成功');
                    Get.back();
                  },
                  child: Text('确定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> changeFontFamily(TermareController controller) async {
    await showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改字体样式'),
            SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8.0,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    settingInfo.fontFamily = 'DroidSansMono';
                  },
                  child: Text('DroidSansMono'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.fontFamily = 'MenloforPowerline';
                    Get.back();
                  },
                  child: Text('MenloforPowerline'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.fontFamily = 'SourceCodePro';
                    Get.back();
                  },
                  child: Text('SourceCodePro'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.fontFamily = 'SourceCodeProMediumforPowerline';
                    Get.back();
                  },
                  child: Text('SourceCodeProMediumforPowerline'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.fontFamily = 'MesloLGMforPowerline';
                    saveToLocal();
                    Get.back();
                  },
                  child: Text('MesloLGMforPowerline'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final TerminalController terminalController =
        Get.find<TerminalController>();
    for (final PtyTermEntity entity in terminalController.terms) {
      entity.controller.setFontfamily(settingInfo.fontFamily);
    }
    controller.setFontfamily(settingInfo.fontFamily);
    update();
    saveToLocal();
    showToast('更改成功');
  }

  Future<void> changeTermStyle(TermareController controller) async {
    await showCustomDialog(
      context: Get.context,
      child: FullHeightListView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('更改终端主题'),
            SizedBox(
              height: 8,
            ),
            Wrap(
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    settingInfo.termStyle = 'vsCode';
                  },
                  child: Text('vs code'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.termStyle = 'manjaro';
                    Get.back();
                  },
                  child: Text('manjaro'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.termStyle = 'macos';
                    saveToLocal();
                    showToast('macos');
                    Get.back();
                  },
                  child: Text('macos'),
                ),
                TextButton(
                  onPressed: () {
                    settingInfo.termStyle = 'termux';
                    saveToLocal();
                    showToast('更改成功');
                    Get.back();
                  },
                  child: Text('termux'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    saveToLocal();
    update();
    controller.changeStyle(
      TermareStyle.parse(settingInfo.termStyle).copyWith(
        fontSize: settingInfo.fontSize.toDouble(),
      ),
    );
    final TerminalController terminalController =
        Get.find<TerminalController>();
    for (final PtyTermEntity entity in terminalController.terms) {
      entity.controller.changeStyle(
        TermareStyle.parse(settingInfo.termStyle).copyWith(
          fontSize: settingInfo.fontSize.toDouble(),
        ),
      );
    }

    showToast('更改成功');
  }

  void readLocalStorage() {
    if (!Directory(RuntimeEnvir.homePath).existsSync()) {
      Directory(RuntimeEnvir.homePath).create(recursive: true);
    }
    print('filePath -> $filePath');
    File file = File(filePath);
    if (file.existsSync()) {
      Map<String, dynamic> json =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      settingInfo = SettingInfo.fromJson(json);
    } else {
      settingInfo = SettingInfo.fromJson(
        {
          "bufferLine": 1000,
          "enableUtf8": true,
          "bellWhenEscapeA": false,
          "vibrationWhenEscapeA": true,
          "repository": "http://nightmare.fun/termare/",
          "cmdLine": "login",
          "initCmd": "",
          "termType": "xterm-256color",
          "fontSize": 11,
          "fontFamily": "MenloforPowerline",
          "termStyle": "vsCode"
        },
      );
    }
  }

  void changeInfo(SettingInfo settingInfo) {
    this.settingInfo = settingInfo;
    update();
  }

  void saveToLocal() {
    final File file = File(filePath);
    file.writeAsString(settingInfo.toString());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

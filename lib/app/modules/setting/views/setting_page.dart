import 'dart:async';
import 'dart:io';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:termare_app/app/modules/setting/controllers/setting_controller.dart';
import 'package:termare_app/app/modules/setting/utils/term_utils.dart';
import 'package:termare_app/app/modules/setting/views/powerlevel10k_addr.dart';
import 'package:termare_app/app/modules/terminal/controllers/terminal_controller.dart';
import 'package:termare_app/app/modules/terminal/views/terminal_pages.dart';
import 'package:termare_app/app/modules/terminal/views/web_view.dart';
import 'package:termare_app/app/widgets/pop_button.dart';
import 'package:termare_app/config/assets.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_app/themes/app_colors.dart';
import 'package:termare_view/termare_view.dart';

import 'zsh_select_addr.dart';

TermareStyle termareStyle = TermareStyles.termux;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TermareController _controller = TermareController(
    theme: TermareStyles.vsCode.copyWith(
      fontSize: 8,
    ),
  );
  TermareController _preview;

  bool writeLock = false;

  SettingController controller = Get.find();

  @override
  void initState() {
    super.initState();
    _preview = TermareController(
      theme: TermareStyles.vsCode.copyWith(
        fontSize: controller.settingInfo.fontSize.toDouble(),
      ),
    )
      ..write(
        '字体预览 font preview\r\n' +
            '[30m[40m   [31m[41m   [32m[42m   [33m[43m   [34m[44m   [35m[45m   [36m[46m   [37m[47m   [m\r\n'
                '[38;5;8m[48;5;8m   [38;5;9m[48;5;9m   [38;5;10m[48;5;10m   [38;5;11m[48;5;11m   [38;5;12m[48;5;12m   [38;5;13m[48;5;13m   [38;5;14m[48;5;14m   [38;5;15m[48;5;15m   [m',
      )
      ..showCursor = false;
    execFetch();
  }

  Future<void> execFetch() async {
    final String fetch = await rootBundle.loadString(
      Assets.neofetchContent,
    );
    _controller.clear();
    _controller.enableAutoScroll();
    writeLock = true;
    await Future.delayed(Duration(milliseconds: 300));
    if (!mounted) {
      return;
    }
    for (final String line in fetch.split('\n')) {
      for (final String char in line.split('')) {
        _controller.write(char);
        // 这儿不是故意这么写，用 mill 不能实现我想要的效果
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        await Future<void>.delayed(const Duration(microseconds: 900));
        // await Future<void>.delayed(Duration(milliseconds: 1));
      }
      _controller.write('\r\n');
    }

    writeLock = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '设置',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        brightness: Brightness.light,
        centerTitle: true,
        leading: const PopButton(),
        elevation: 0,
      ),
      body: GetBuilder<SettingController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingTitle(
                  title: '终端外观',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (writeLock) {
                          return;
                        }
                        execFetch();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: IgnorePointer(
                          child: TermareView(
                            controller: _controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: _preview.theme.characterHeight * 3,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: IgnorePointer(
                          child: TermareView(
                            controller: _preview,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SettingItem(
                  title: '更改字体大小',
                  subTitle: controller.settingInfo.fontSize.toString(),
                ),
                Slider(
                  value: controller.settingInfo.fontSize.toDouble(),
                  max: 24,
                  min: 4,
                  // label: '$fontSize',
                  activeColor: Theme.of(context).accentColor,
                  inactiveColor: Theme.of(context).accentColor.withOpacity(0.3),
                  // divisions: 20,
                  onChanged: (size) {
                    controller.settingInfo.fontSize = size.toInt();
                    controller.update();
                    final TerminalController terminalController =
                        Get.find<TerminalController>();
                    for (final PtyTermEntity entity
                        in terminalController.terms) {
                      entity.controller.setFontSize(
                        controller.settingInfo.fontSize.toDouble(),
                      );
                    }
                    controller.saveToLocal();
                    _preview.setFontSize(
                      controller.settingInfo.fontSize.toDouble(),
                    );
                    setState(() {});
                  },
                ),
                SettingItem(
                  title: '更改字体样式',
                  subTitle: controller.settingInfo.fontFamily.toString(),
                  onTap: () {
                    controller.changeFontFamily(_preview);
                  },
                ),
                SettingItem(
                  title: '更改主题',
                  suffix: Column(
                    children: [
                      SizedBox(
                        height: 8.w,
                      ),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.w,
                        children: [
                          TagItem(
                            value: 'vsCode',
                            groupValue: controller.settingInfo.termStyle,
                            onChanged: controller.onTextStyleChange,
                          ),
                          TagItem(
                            value: 'manjaro',
                            groupValue: controller.settingInfo.termStyle,
                            onChanged: controller.onTextStyleChange,
                          ),
                          TagItem(
                            value: 'macos',
                            groupValue: controller.settingInfo.termStyle,
                            onChanged: controller.onTextStyleChange,
                          ),
                          TagItem(
                            value: 'termux',
                            groupValue: controller.settingInfo.termStyle,
                            onChanged: controller.onTextStyleChange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SettingTitle(
                  title: '通用设置',
                ),
                SettingItem(
                  title: '源地址',
                  subTitle: controller.settingInfo.repository,
                  onTap: controller.changeRepository,
                ),
                SettingItem(
                  title: '缓存行数',
                  subTitle: controller.settingInfo.bufferLine.toString(),
                  onTap: controller.changeBufferLine,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SettingItem(
                      title: '默认支持 UTF8',
                      subTitle: controller.settingInfo.enableUtf8.toString(),
                    ),
                    Switch(
                      value: controller.settingInfo.enableUtf8,
                      onChanged: (value) {
                        controller.settingInfo.enableUtf8 = value;
                        controller.update();
                        showToast('目前改了没用');
                      },
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SettingItem(
                      title: r'收到\a时候响铃',
                      subTitle:
                          controller.settingInfo.bellWhenEscapeA.toString(),
                    ),
                    Switch(
                      value: controller.settingInfo.bellWhenEscapeA,
                      onChanged: (value) {
                        controller.settingInfo.bellWhenEscapeA = value;
                        showToast('目前改了没用');
                        controller.update();
                      },
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SettingItem(
                      title: r'收到\a时候振动',
                      subTitle: controller.settingInfo.vibrationWhenEscapeA
                          .toString(),
                    ),
                    Switch(
                      value: controller.settingInfo.vibrationWhenEscapeA,
                      onChanged: (value) {
                        controller.settingInfo.vibrationWhenEscapeA = value;
                        controller.update();
                        showToast('有用的');
                      },
                    ),
                  ],
                ),
                const SettingTitle(
                  title: 'SHELL',
                ),
                SettingItem(
                  title: '命令行',
                  subTitle: controller.settingInfo.cmdLine,
                  onTap: controller.changeCmdLine,
                ),
                SettingItem(
                  title: '初始命令',
                  subTitle: controller.settingInfo.initCmd,
                  onTap: controller.changeInitCmd,
                ),
                SettingItem(
                  title: '终端类型',
                  subTitle: controller.settingInfo.termType,
                ),

                // const SettingTitle(
                //   title: '界面设置',
                // ),
                // SwitchItem(
                //   title: '显示快捷操作栏目',
                //   value: true,
                //   onChanged: (value) {},
                // ),
                // const SettingTitle(
                //   title: 'App主题',
                // ),
                // 改成可切换的设置页面
                // ThemeChangeBar(),
                //
                const SettingTitle(
                  title: '快捷命令',
                ),
                SettingItem(
                  title: '安装zsh',
                  subTitle: '自动键入相关命令',
                  onTap: () async {
                    final String url = await showCustomDialog<String>(
                      context: context,
                      child: FullHeightListView(
                        child: SelectAddr(),
                      ),
                    );
                    if (url == null) {
                      return;
                    }
                    final PseudoTerminal pseudoTerminal = PseudoTerminal(
                      executable: Platform.isWindows ? 'wsl' : 'bash',
                      workingDirectory: RuntimeEnvir.homePath,
                      environment: {
                        'TERM': 'screen-256color',
                        'PATH': '${RuntimeEnvir.binPath}:' +
                            Platform.environment['PATH'],
                        'HOME': RuntimeEnvir.homePath,
                      },
                      arguments: ['-l'],
                    );
                    await pseudoTerminal.defineTermFunc(
                      func: '''
                  function install_zsh(){
                    apt update
                    zsh_exist=`which zsh`
                    git_exist=`which git`
                    if [ -z "\$zsh_exist" ]; then
                    apt-get install -yq zsh
                    fi
                    if [ -z "\$git_exist" ]; then
                    apt-get install -yq git
                    fi
                    sh -c "\$(curl -fsSL $url)"
                  }
                  ''',
                    );
                    TermUtils.openTerm2(
                      context: context,
                      controller: TermareController(),
                      exec: 'install_zsh',
                      pseudoTerminal: pseudoTerminal,
                    );
                    // Get.to(page)
                  },
                ),
                SettingItem(
                  title: '安装 zsh powerlevel10k 主题',
                  subTitle: '自动键入相关命令，处理配置文件',
                  onTap: () async {
                    // Get.defaultDialog(title: '选择');
                    final String url = await showCustomDialog<String>(
                      context: context,
                      child: FullHeightListView(
                        child: PowerLevelAddr(),
                      ),
                    );
                    if (url == null) {
                      return;
                    }
                    final PseudoTerminal pseudoTerminal = PseudoTerminal(
                      executable: Platform.isWindows ? 'wsl' : 'bash',
                      workingDirectory: RuntimeEnvir.homePath,
                      environment: {
                        'TERM': 'screen-256color',
                        'PATH': '${RuntimeEnvir.binPath}:' +
                            Platform.environment['PATH'],
                        'HOME': RuntimeEnvir.homePath,
                      },
                      arguments: ['-l'],
                    );
                    await pseudoTerminal.defineTermFunc(
                      func: '''
                  function install_powerlevel10k(){
                    git clone --depth=1 $url \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
                  }
                  ''',
                    );
                    await TermUtils.openTerm2(
                      context: context,
                      controller: TermareController(),
                      exec: 'install_powerlevel10k',
                      pseudoTerminal: pseudoTerminal,
                    );
                    final File zsh = File('${RuntimeEnvir.homePath}/.zshrc');
                    String zshRaw = await zsh.readAsString();
                    zshRaw = zshRaw.replaceAll(
                      RegExp('ZSH_THEME.*'),
                      'ZSH_THEME="powerlevel10k/powerlevel10k"',
                    );
                    await zsh.writeAsString(zshRaw);
                    // Get.to(page)
                  },
                ),

                SettingItem(
                  title: '打开 Vs Code',
                  subTitle: '自动键入相关命令，处理配置文件',
                  onTap: () async {
                    // Get.to(WebViewExample());
                    final PseudoTerminal pseudoTerminal = PseudoTerminal(
                      executable: Platform.isWindows ? 'wsl' : 'bash',
                      workingDirectory: RuntimeEnvir.homePath,
                      environment: {
                        'TERM': 'screen-256color',
                        'PATH': '${RuntimeEnvir.binPath}:' +
                            Platform.environment['PATH'],
                        'HOME': RuntimeEnvir.homePath,
                      },
                      useIsolate: false,
                      arguments: ['-l'],
                    );
                    pseudoTerminal.startPolling();
                    final Completer completer = Completer();
                    pseudoTerminal.out.listen((event) {
                      if (event.contains('http://127.0.0.1:8080')) {
                        completer.complete();
                      }
                      Log.w('event -> $event');
                    });
                    pseudoTerminal.write(
                      '${RuntimeEnvir.homePath}/code-server/bin/code-server\n',
                    );
                    await completer.future;
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.manual,
                      overlays: [],
                    );
                    // Get.to(WebviewScaffold(
                    //   url: 'http://127.0.0.1:8080',
                    // ));
                  },
                ),
                SettingItem(
                  title: '安装 zsh-autosuggestions',
                  subTitle: '自动键入相关命令，处理配置文件',
                  onTap: () async {
                    final PseudoTerminal pseudoTerminal = PseudoTerminal(
                      executable: Platform.isWindows ? 'wsl' : 'bash',
                      workingDirectory: RuntimeEnvir.homePath,
                      environment: {
                        'TERM': 'screen-256color',
                        'PATH': '${RuntimeEnvir.binPath}:' +
                            Platform.environment['PATH'],
                        'HOME': RuntimeEnvir.homePath,
                      },
                      arguments: ['-l'],
                    );
                    await pseudoTerminal.defineTermFunc(
                      func: '''
                  function install_powerlevel10k(){
                    git clone git://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-\$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
                  }
                  ''',
                    );
                    await TermUtils.openTerm2(
                      context: context,
                      controller: TermareController(),
                      exec: 'install_powerlevel10k',
                      pseudoTerminal: pseudoTerminal,
                    );
                    final File zsh = File('${RuntimeEnvir.homePath}/.zshrc');
                    String zshRaw = await zsh.readAsString();
                    zshRaw = zshRaw.replaceAll(
                      RegExp('plugins=.*'),
                      'plugins=(git zsh-autosuggestions)',
                    );
                    await zsh.writeAsString(zshRaw);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TagItem extends StatelessWidget {
  const TagItem({
    Key key,
    this.value,
    this.groupValue,
    this.onChanged,
  }) : super(key: key);
  final String value;
  final String groupValue;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isSelect = value == groupValue;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          // color: Theme.of(context).primaryColor,
          border: Border.all(
            color: isSelect
                ? Theme.of(context).primaryColor
                : AppColors.borderColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              color: isSelect
                  ? Theme.of(context).primaryColor
                  : AppColors.fontColor,
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchItem extends StatelessWidget {
  const SwitchItem({
    Key key,
    this.title,
    this.onChanged,
    this.value,
  }) : super(key: key);
  final String title;
  final void Function(bool) onChanged;
  final bool value;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      // color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatefulWidget {
  const SettingItem({
    Key key,
    this.title,
    this.onTap,
    this.subTitle,
    this.suffix = const SizedBox(),
  }) : super(key: key);

  final String title;
  final String subTitle;
  final void Function() onTap;
  final Widget suffix;
  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 64.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    // color: Theme.of(context).colorScheme.primaryVariant,
                    fontWeight: FontWeight.w400,
                    fontSize: 18.w,
                  ),
                ),
                Builder(builder: (_) {
                  String content = widget.subTitle;
                  if (content == null) {
                    return SizedBox();
                  }
                  return Text(
                    content,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
                widget.suffix,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTitle extends StatefulWidget {
  const SettingTitle({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SettingTitleState createState() => _SettingTitleState();
}

class _SettingTitleState extends State<SettingTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 10,
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 18.w,
          color: Theme.of(context).colorScheme.primaryVariant,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class TermColorList extends StatelessWidget {
  const TermColorList({Key key, this.style}) : super(key: key);
  final TermareStyle style;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              color: style.black,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.red,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.green,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.yellow,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.blue,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.purplishRed,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.cyan,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.white,
              width: 20,
              height: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Container(
              color: style.lightBlack,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightRed,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightGreen,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightYellow,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightBlue,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightPurplishRed,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightCyan,
              width: 20,
              height: 10,
            ),
            Container(
              color: style.lightWhite,
              width: 20,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }
}

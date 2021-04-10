import 'dart:io';

import 'package:dart_pty/dart_pty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:termare_app/app/modules/setting/utils/term_utils.dart';
import 'package:termare_app/config/config.dart';
import 'package:termare_view/termare_view.dart';

TermareStyle termareStyle = TermareStyles.termux;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TermareController _controller = TermareController(
    theme: TermareStyles.termux.copyWith(
      fontSize: 8,
    ),
  );
  bool writeLock = false;
  @override
  void initState() {
    super.initState();
    execFetch();
  }

  Future<void> execFetch() async {
    final String fetch = await rootBundle.loadString(
      'assets/text/neofetch.txt',
    );
    _controller.clear();
    _controller.autoScroll = false;
    writeLock = true;
    for (final String char in fetch.split('')) {
      _controller.write(char);
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
        centerTitle: true,
        leading: const SizedBox(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   color: TermareStyles.termux.backgroundColor,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'termux',
            //         style: TextStyle(
            //           color: TermareStyles.termux.defaultColor,
            //         ),
            //       ),
            //       TermColorList(
            //         style: TermareStyles.termux,
            //       ),
            //       Radio<TermareStyle>(
            //         value: TermareStyles.termux,
            //         groupValue: termareStyle,
            //         onChanged: (v) {
            //           termareStyle = v;
            //           setState(() {});
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   color: TermareStyles.manjaro.backgroundColor,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'manjaro',
            //         style: TextStyle(
            //           color: TermareStyles.manjaro.defaultColor,
            //         ),
            //       ),
            //       TermColorList(
            //         style: TermareStyles.manjaro,
            //       ),
            //       Radio<TermareStyle>(
            //         value: TermareStyles.manjaro,
            //         groupValue: termareStyle,
            //         onChanged: (v) {
            //           termareStyle = v;
            //           setState(() {});
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   color: TermareStyles.macos.backgroundColor,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'macos',
            //         style: TextStyle(
            //           color: TermareStyles.macos.defaultColor,
            //         ),
            //       ),
            //       TermColorList(
            //         style: TermareStyles.macos,
            //       ),
            //       Radio<TermareStyle>(
            //         value: TermareStyles.macos,
            //         groupValue: termareStyle,
            //         onChanged: (v) {
            //           termareStyle = v;
            //           setState(() {});
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            const SettingTitle(
              title: '通用设置',
            ),
            const SettingItem(
              title: '初始命令',
            ),
            SwitchItem(
              title: r'收到\a时候响铃',
              value: true,
              onChanged: (value) {},
            ),
            SwitchItem(
              title: r'收到\a时候振动',
              value: true,
              onChanged: (value) {},
            ),
            const SettingTitle(
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
            SettingItem(
              title: '更改字体',
            ),
            SettingItem(
              title: '更改主题',
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
              onTap: () async {
                final PseudoTerminal pseudoTerminal = PseudoTerminal(
                  row: 53,
                  column: 49,
                  executable: Platform.isWindows ? 'wsl' : 'bash',
                  workingDirectory: Config.homePath,
                  environment: {
                    'TERM': 'screen-256color',
                    'PATH': '${Config.binPath}:' + Platform.environment['PATH'],
                    'HOME': Config.homePath,
                  },
                );
                await pseudoTerminal.defineTermFunc(
                  func: r'''
                  function install_zsh(){
                    apt update
                    zsh_exist=`which zsh`
                    git_exist=`which git`
                    if [ -z "$zsh_exist" ]; then
                    apt-get install -yq zsh
                    fi
                    if [ -z "$git_exist" ]; then
                    apt-get install -yq git
                    fi
                    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
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
              onTap: () async {
                final PseudoTerminal pseudoTerminal = PseudoTerminal(
                  row: 53,
                  column: 49,
                  executable: Platform.isWindows ? 'wsl' : 'bash',
                  workingDirectory: Config.homePath,
                  environment: {
                    'TERM': 'screen-256color',
                    'PATH': '${Config.binPath}:' + Platform.environment['PATH'],
                    'HOME': Config.homePath,
                  },
                );
                await pseudoTerminal.defineTermFunc(
                  func: r'''
                  function install_powerlevel10k(){
                    git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
                  }
                  ''',
                );
                await TermUtils.openTerm2(
                  context: context,
                  controller: TermareController(),
                  exec: 'install_powerlevel10k',
                  pseudoTerminal: pseudoTerminal,
                );
                final File zsh = File('${Config.homePath}/.zshrc');
                String zshRaw = await zsh.readAsString();
                zshRaw = zshRaw.replaceAll(
                  RegExp('ZSH_THEME.*'),
                  'ZSH_THEME="powerlevel10k/powerlevel10k"',
                );
                await zsh.writeAsString(zshRaw);
                // Get.to(page)
              },
            ),
          ],
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
  const SettingItem({Key key, this.title, this.onTap}) : super(key: key);

  final String title;
  final void Function() onTap;
  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: SizedBox(
          height: 68,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    // color: Theme.of(context).colorScheme.primaryVariant,
                    fontWeight: FontWeight.w400,
                  ),
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
        vertical: 16,
        horizontal: 10,
      ),
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.headline6.copyWith(
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

import 'package:flutter/material.dart';

class SelectAddr extends StatefulWidget {
  @override
  _SelectAddrState createState() => _SelectAddrState();
}

class _SelectAddrState extends State<SelectAddr> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('选择地址'),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  'https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh',
                );
              },
              child: Text('Github'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  'https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh',
                );
              },
              child: Text('Gitee'),
            ),
          ],
        ),
      ],
    );
  }
}

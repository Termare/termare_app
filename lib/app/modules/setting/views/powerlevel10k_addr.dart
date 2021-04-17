import 'package:flutter/material.dart';

class PowerLevelAddr extends StatefulWidget {
  @override
  _PowerLevelAddrState createState() => _PowerLevelAddrState();
}

class _PowerLevelAddrState extends State<PowerLevelAddr> {
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
                  'https://github.com/romkatv/powerlevel10k',
                );
              },
              child: Text('Github'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  'https://gitee.com/romkatv/powerlevel10k.git',
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

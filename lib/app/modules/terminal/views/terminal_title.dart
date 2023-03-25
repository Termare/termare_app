// import 'package:flutter/material.dart';
// import 'package:termare_view/termare_view.dart';

// class TerminalTitle extends StatefulWidget {
//   const TerminalTitle({Key key, this.controller}) : super(key: key);
//   final TermareController controller;

//   @override
//   _TerminalTitleState createState() => _TerminalTitleState();
// }

// class _TerminalTitleState extends State<TerminalTitle> {
//   @override
//   void initState() {
//     super.initState();
//     widget.controller?.addListener(update);
//   }

//   void update() {
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     widget.controller?.removeListener(update);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Center(
//         child: Text(
//           widget.controller?.terminalTitle ?? '',
//           style: const TextStyle(
//             height: 1.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

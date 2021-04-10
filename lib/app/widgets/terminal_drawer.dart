// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:termare_app/modules/code/code_list.dart';
// import 'package:termare_app/modules/setting/setting_page.dart';
// import 'package:termare_view/termare_view.dart';

// class TerminalDrawer extends StatefulWidget {
//   const TerminalDrawer({Key key, this.controller}) : super(key: key);
//   final TermareController controller;

//   @override
//   _TerminalDrawerState createState() => _TerminalDrawerState();
// }

// class _TerminalDrawerState extends State<TerminalDrawer> {
//   final children = <int, Widget>{
//     0: const Text(
//       '视图',
//       style: TextStyle(color: Colors.white),
//     ),
//     1: const Text(
//       '代码片段',
//       style: TextStyle(color: Colors.white),
//     ),
//   };

//   int currentSegment = 0;

//   void onValueChanged(int newValue) {
//     setState(() {
//       currentSegment = newValue;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
//         child: Material(
//           textStyle: const TextStyle(
//             color: Colors.white,
//           ),
//           borderRadius: BorderRadius.circular(8),
//           color: Colors.black.withOpacity(0.2),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: 500,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: CupertinoSlidingSegmentedControl<int>(
//                       backgroundColor: Colors.white.withOpacity(0.2),
//                       children: children,
//                       onValueChanged: onValueChanged,
//                       groupValue: currentSegment,
//                       thumbColor: Colors.white.withOpacity(0.2),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: [
//                     Column(
//                       children: [
//                         const Text('字体大小'),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.remove,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 widget.controller.setFontSize(
//                                   widget.controller.theme.fontSize - 1,
//                                 );
//                                 setState(() {});
//                               },
//                             ),
//                             Text(widget.controller.theme.fontSize.toString()),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 widget.controller.setFontSize(
//                                   widget.controller.theme.fontSize + 1,
//                                 );
//                                 setState(() {});
//                               },
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('显示网格'),
//                             Checkbox(
//                               checkColor: Colors.black,
//                               // c: MaterialStateProperty.resolveWith((_) {
//                               //   return Colors.white;
//                               // }),
//                               value: widget.controller.showBackgroundLine,
//                               onChanged: (value) {
//                                 widget.controller.showBackgroundLine = value;
//                                 widget.controller.dirty = true;
//                                 setState(() {});
//                                 widget.controller.notifyListeners();
//                               },
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               color: TermareStyles.termux.backgroundColor,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'termux',
//                                     style: TextStyle(
//                                       color: TermareStyles.termux.defaultColor,
//                                     ),
//                                   ),
//                                   TermColorList(
//                                     style: TermareStyles.termux,
//                                   ),
//                                   Radio<TermareStyle>(
//                                     value: TermareStyles.termux,
//                                     groupValue: termareStyle,
//                                     onChanged: (v) {
//                                       termareStyle = v;
//                                       // systemUiOverlayStyle =
//                                       //     SystemUiOverlayStyle.light;
//                                       setState(() {});
//                                       widget.controller.theme =
//                                           termareStyle.copyWith(
//                                         fontSize:
//                                             widget.controller.theme.fontSize,
//                                       );
//                                       widget.controller.dirty = true;
//                                       widget.controller.notifyListeners();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               color: TermareStyles.manjaro.backgroundColor,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'manjaro',
//                                     style: TextStyle(
//                                       color: TermareStyles.manjaro.defaultColor,
//                                     ),
//                                   ),
//                                   TermColorList(
//                                     style: TermareStyles.manjaro,
//                                   ),
//                                   Radio<TermareStyle>(
//                                     value: TermareStyles.manjaro,
//                                     groupValue: termareStyle,
//                                     onChanged: (v) {
//                                       termareStyle = v;
//                                       // systemUiOverlayStyle =
//                                       //     SystemUiOverlayStyle.light;
//                                       setState(() {});
//                                       widget.controller.theme =
//                                           termareStyle.copyWith(
//                                         fontSize:
//                                             widget.controller.theme.fontSize,
//                                       );
//                                       widget.controller.dirty = true;
//                                       widget.controller.notifyListeners();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               color: TermareStyles.macos.backgroundColor,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'macos',
//                                     style: TextStyle(
//                                       color: TermareStyles.macos.defaultColor,
//                                     ),
//                                   ),
//                                   TermColorList(
//                                     style: TermareStyles.macos,
//                                   ),
//                                   Radio<TermareStyle>(
//                                     value: TermareStyles.macos,
//                                     groupValue: termareStyle,
//                                     onChanged: (v) {
//                                       termareStyle = v;
//                                       // systemUiOverlayStyle =
//                                       //     SystemUiOverlayStyle.dark;
//                                       setState(() {});
//                                       widget.controller.theme =
//                                           termareStyle.copyWith(
//                                         fontSize:
//                                             widget.controller.theme.fontSize,
//                                       );
//                                       widget.controller.dirty = true;
//                                       widget.controller.notifyListeners();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     LayoutBuilder(
//                       builder: (c, cc) {
//                         print(cc.maxHeight);
//                         return Scaffold(
//                           backgroundColor: Colors.transparent,
//                           body: Theme(
//                             data: ThemeData(
//                               textTheme: const TextTheme(
//                                 subtitle1: TextStyle(
//                                   fontSize: 16.0,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                                 bodyText2: TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                             child: CodeListPage(
//                               controller: widget.controller,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ][currentSegment],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

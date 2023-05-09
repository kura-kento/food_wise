// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CameraDialog extends StatefulWidget {
//   const CameraDialog({Key? key}) : super(key: key);
//
//   @override
//   _CameraDialogState createState() => _CameraDialogState();
// }
//
// class _CameraDialogState extends State<CameraDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         color: Theme.of(context).backgroundColor,
//         padding: const EdgeInsets.all(15.0),
//         child: const Center(
//           child: Text(
//             '広告の位置',
//             textAlign: TextAlign.center,
//             textScaleFactor: 1.5,
//           ),
//         ),
//       ) ,
//       onTap: (){
//         AddPositionDialog(context);
//       },
//     );
//   }
//
//   void AddPositionDialog(context) async {
//     await showCupertinoModalPopup<void>(
//       context: context,
//       builder: (BuildContext context) => CupertinoActionSheet(
//         title: const Text('選択してください'),
//         // message: const Text('Message'),
//         actions: <CupertinoActionSheetAction>[
//           CupertinoActionSheetAction(
//             child: const Text('写真を撮る'),
//             onPressed: () {
//
//
//             },
//           ),
//           CupertinoActionSheetAction(
//             child: const Text('アルバムから読み取る'),
//             onPressed: () {
//             },
//           )
//         ],
//       ),
//     );
//   }
// }

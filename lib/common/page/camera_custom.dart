//
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
//
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// class MyHomePage extends StatefulWidget {
//   final String title;
//   CroppedFile? _croppedFile;
//
//   MyHomePage({required this.title});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// enum AppState {
//   free,
//   picked,
//   cropped,
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late AppState state;
//   XFile? _pickedFile;
//   CroppedFile? _croppedFile;
//
//   @override
//   void initState() {
//     super.initState();
//     state = AppState.free;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: _croppedFile != null ? Image.file(_croppedFile.path) : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.deepOrange,
//         onPressed: () {
//           if (state == AppState.free)
//             _pickImage();
//           else if (state == AppState.picked)
//             _cropImage();
//           else if (state == AppState.cropped) _clearImage();
//         },
//         child: _buildButtonIcon(),
//       ),
//     );
//   }
//
//   Widget _buildButtonIcon() {
//     if (state == AppState.free)
//       return Icon(Icons.add);
//     else if (state == AppState.picked)
//       return Icon(Icons.crop);
//     else if (state == AppState.cropped)
//       return Icon(Icons.clear);
//     else
//       return Container();
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile =
//     await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _pickedFile = pickedFile;
//       });
//     }
//   }
//
//   Future<void> _cropImage() async {
//     if (_pickedFile != null) {
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: _pickedFile!.path,
//         compressFormat: ImageCompressFormat.jpg,
//         compressQuality: 100,
//         uiSettings: [
//           AndroidUiSettings(
//               toolbarTitle: 'Cropper',
//               toolbarColor: Colors.deepOrange,
//               toolbarWidgetColor: Colors.white,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: false),
//           IOSUiSettings(
//             title: 'Cropper',
//           ),
//           WebUiSettings(
//             context: context,
//             presentStyle: CropperPresentStyle.dialog,
//             boundary: const CroppieBoundary(
//               width: 520,
//               height: 520,
//             ),
//             viewPort:
//             const CroppieViewPort(width: 480, height: 480, type: 'circle'),
//             enableExif: true,
//             enableZoom: true,
//             showZoomer: true,
//           ),
//         ],
//       );
//       if (croppedFile != null) {
//         setState(() {
//           _croppedFile = croppedFile;
//         });
//       }
//     }
//   }
//
//   void _clearImage() {
//     setState(() {
//       _pickedFile = null;
//       _croppedFile = null;
//     });
//   }
// }
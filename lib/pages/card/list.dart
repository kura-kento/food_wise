// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// // import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:food_wise/common/layout/appbar.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../common/app.dart';
// import '../../common/page/camera.dart';
// import '../../model/FoodStorage.dart';
// import '../../model/database_help.dart';
// import 'detail.dart';
// import 'form.dart';
//
// class CardList extends StatefulWidget {
//   const CardList({Key? key}) : super(key: key);
//
//   @override
//   State<CardList> createState() => _CardListState();
// }
//
// class _CardListState extends State<CardList> with WidgetsBindingObserver {
//   double listHeight = 60;
//   File? _image;
//
//   final _picker = ImagePicker();
//
//   // null safety対応のため、?でnull許容
//   String? _result;
//
//   @override
//     initState() {
//     WidgetsBinding.instance.addObserver(this);
//     tracking();//広告追跡のダイアログ
//     getFoodStorage();
//     _signIn();
//     super.initState();
//   }
//
//   // 匿名でのFirebaseログイン処理
//   void _signIn() async {
//     final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     try{
//       await firebaseAuth.signInAnonymously();
//       print('ゲストログイン成功');
//     } catch(e) {
//       print(e.toString());
//     }
//   }
//
//   Future<void> tracking() async {
//     Future.delayed(const Duration(seconds: 1), () {
//       AppTrackingTransparency.requestTrackingAuthorization();
//     });
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     print('リスト dispose:停止');
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
// // アプリを閉じたとき
// //   @override
// //   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
// //     print('isCamera:' + App.isCamera.toString());
// //     if (App.isCamera) { return; }
// //
// //     // アプリがバックグラウンドに遷移し（最前面に表示されてない）、入力不可な一時停止状態
// //     if (state == AppLifecycleState.paused) {
// //       print('paused');
// //       // アプリは表示されているが、フォーカスがあたっていない状態
// //     } else if(state == AppLifecycleState.inactive) {
// //       print('inactive');
// //       print(this);
// //       if (SharedPrefs.getIsPassword()) {
// //         WidgetsBinding.instance.removeObserver(this);
// //         await Navigator.of(context).push(
// //           MaterialPageRoute(
// //             builder: (context) {
// //               return const PassLock();
// //             },
// //           ),
// //         );
// //         WidgetsBinding.instance.addObserver(this);
// //       }
// //       // アプリがフォアグランドに遷移し（paused状態から復帰）、復帰処理用の状態
// //     } else if (state == AppLifecycleState.resumed) {
// //       print('resumed');
// //     }
// //     setState(() { });
// //   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Visibility(
//           visible: App.isVisible,
//           child: Column(
//             children: [
//               CustomAppBar(
//                 rightButton: cameraBtn(),
//               ),
//               Expanded(
//                 child: FutureBuilder(
//                   future: getFoodStorage(),
//                   builder: (BuildContext context ,AsyncSnapshot snapshot) {
//                     if (snapshot.hasData) {
//                       return SingleChildScrollView(
//                         child: Column(children: [
//                           // 画像を取得できたら表示
//                           // null safety対応のため_image!とする（_imageはnullにならない）
//                           if (_image != null) Image.file(_image!, height: 400),
//
//                           // 画像を取得できたら解析ボタンを表示
//                           if (_image != null || true) _analysisButton(),
//                           Container(
//                             height: 240,
//
//                             // OCR（テキスト検索）の結果をスクロール表示できるようにするため
//                             // 結果表示部分をSingleChildScrollViewでラップ
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.vertical,
//                               child: Text(
//                                 (() {
//                                   // OCR（テキスト認識）の結果（_result）を取得したら表示
//                                   if (_result != null) {
//                                     // null safety対応のため_result!とする（_resultはnullにならない）
//                                     return _result!;
//                                   } else if (_image != null) {
//                                     return 'ボタンを押すと解析が始まります';
//                                   } else {
//                                     return 'OCR（テキスト認識）したい画像を撮影または読込んでください';
//                                   }
//                                 }()),
//                               ),
//                             ),
//                           ),
//                         ]),
//                       );
//                     } else {
//                       return const Text("データが存在しません");
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//
//             // カメラ起動ボタン
//             FloatingActionButton(
//               onPressed: () => _getImage(FileMode.CAMERA),
//               tooltip: 'Pick Image from camera',
//               child: Icon(Icons.camera_alt),
//             ),
//
//             // ギャラリー（ファイル）検索起動ボタン
//             FloatingActionButton(
//               onPressed: () => _getImage(FileMode.GALLERY),
//               tooltip: 'Pick Image from gallery',
//               child: Icon(Icons.folder_open),
//             ),
//           ],
//         ),
//         // floatingActionButton: FloatingActionButton(
//         //   backgroundColor: App.primary_color,
//         //   child: Icon(Icons.add, color: App.btn_color, size: 40),
//         //   onPressed: () => navigationCardFormPage(),
//         // ),
//       ),
//     );
//   }
//
//   Future _getImage(FileMode fileMode) async {
//
//     // null safety対応のため、lateで宣言
//     late final _pickedFile;
//
//     // image_pickerの機能で、カメラからとギャラリーからの2通りの画像取得（パスの取得）を設定
//     if (fileMode == FileMode.CAMERA) {
//       _pickedFile = await _picker.getImage(source: ImageSource.camera);
//     } else {
//       _pickedFile = await _picker.getImage(source: ImageSource.gallery);
//     }
//
//     setState(() {
//       if (_pickedFile != null) {
//         _image = File(_pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   Future<List> getFoodStorage() async {
//     //全てのDBを取得
//     List<FoodStorage> result = await DatabaseHelper().getFoodStorage();
//     // result.forEach((FoodStorage val) => print(val.toMap()));
//     return result;
//   }
//
// //   Future<List<ListTable>> getCardList() async {
// // //全てのDBを取得
// //     List<ListTable> result = await DatabaseHelper().getListTable();
// //     return result;
// //   }
//
//   // タップ時の処理
//   Future<void> navigationCardFormPage({Map? listMap}) async {
//     await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) {
//           if(listMap != null) {
//             return CardDetail(listMap: listMap);
//           } else {
//             return CardForm();
//           }
//
//         },
//       ),
//     );
//     // 変更内容を取得
//     setState(() {});
//   }
//
//   Widget listWidget(context, index, cardItem) {
//     return Row(
//       children: [
//         SizedBox(
//           width: listHeight * App.goldenRatio, // カード比
//           child: cardItem['frontPath'] != null
//               ?
//           Image.file(File(cardItem['frontPath']))
//           // Image.memory(base64Decode(cardItem['frontPath']))
//               :
//           Container(
//             color: Colors.grey,
//             child: const Center(child: Text('No Image')),
//           )
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: Text(cardItem['list_title']),
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.only(right: 15.0),
//           child: ReorderableDragStartListener(
//             index: index,
//             child: const Icon(Icons.swap_vert, color: Colors.grey,),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // 並び替えロジック
//   Future<void> onReorder(int oldIndex, int newIndex, data) async {
//     //【注意②】並び替え時のロジックは公式にも記載があり、あまり考える必要はありません。
//     if (oldIndex < newIndex) {
//       newIndex -= 1;
//     }
//     List ids = data.map((val) => val['id']).toList();
//     final int item = ids.removeAt(oldIndex);
//     ids.insert(newIndex, item);
//
//     // DBトランザクションを開始する
//     await DatabaseHelper().database.transaction((txn) async {
//       // 並び替え後のリスト項目を1つずつループし、DBを更新する
//       for (int i = 0; i < ids.length; i++) {
//         final id = ids[i];
//         // sort番号を更新する
//         final newSortNo = i + 1;
//         // DBを更新する
//         await txn.rawUpdate(
//             'UPDATE lists SET list_sort = ? WHERE id = ?', [newSortNo, id]);
//       }
//     });
//     setState(() {});
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('並び替えに成功しました。'),
//       ),
//     );
//   }
//
//   Widget cameraBtn() {
//     return ElevatedButton(
//       onPressed: () async {
//         setState(() {});
//         var result = await Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => const CameraWidget(),
//             settings: const RouteSettings(name: 'camera_page'),
//           ),
//         );
//         _image = File(result!.path!);
//         // var croppedFile = await _cropImage(result);
//         // frontImage = Image.file(File(croppedFile?.path));
//         setState(() {});
//         if (!mounted) return;
//         // Navigator.pop(context);
//       },
//       child: const Text('変更',style: TextStyle(color: Colors.white),),
//     );
//   }
//
//   // OCR（テキスト認識）開始処理
//   Widget _analysisButton() {
//
//     return ElevatedButton(
//       child: Text('解析'),
//       onPressed: () async {
//
//         // null safety対応のため_image!とする（_imageはnullにならない）
//         List<int> _imageBytes = _image!.readAsBytesSync();
//         String _base64Image = base64Encode(_imageBytes);
//
//         // Firebase上にデプロイしたFunctionを呼び出す処理
//         HttpsCallable _callable = FirebaseFunctions.instance.httpsCallable(
//           'annotateImage',
//           options: HttpsCallableOptions(timeout: const Duration(seconds: 300),),
//         );
//         final params = '''
// {
// "image": {"content": "$_base64Image"},
// "features": [
//   {"type": "TEXT_DETECTION"}
// ],
// "imageContext": {
//   "languageHints": ["ja"]
// }
// }
// ''';
//
//         final _text = await _callable(params).then((v) {
//           return v.data[0]["fullTextAnnotation"]["text"];
//         }).catchError((error) {
//           // print('エラーコード:' + error.code.toString());
//           // print('エラー詳細:' + error.details.toString());
//           print('エラーメッセージ:' + error.message.toString());
//           return '読み取りエラーです';
//         });
//         // OCR（テキスト認識）の結果を更新
//         setState(() {
//           _result = _text;
//         });
//       },
//     );
//   }
// }
//
// // カメラ経由かギャラリー（ファイル）経由かを示すフラグ
// enum FileMode{
//   CAMERA,
//   GALLERY,
// }
import 'dart:convert';
import 'dart:io';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/abmob/admob_banner.dart';
import '../../common/app.dart';
import '../../common/layout/appbar.dart';
import '../../common/page/camera.dart';
import '../../model/database_help.dart';
import '../../model/FoodStorage.dart';

import 'dart:async';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';

class SetCards {
  SetCards({this.frontPath, this.backPath});
  String? frontPath;
  String? backPath;
}

class CardForm extends StatefulWidget {
  CardForm({Key? key, this.listMap}) : super(key: key);
  Map? listMap;
  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  double padding = 12.0;
  var focusNode = FocusNode();
  TextEditingController dishController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  List<GlobalKey<FlipCardState>> cardKeyList = <GlobalKey<FlipCardState>>[];
  List<FlipCardController?> flipCardControllerList = <FlipCardController>[];
  List<SetCards> cards = <SetCards>[];
  Image? frontImage;
  Image? backImage;
  String _imagePath = '';

  @override
  void initState() {
    _setImagePath();
    //新規作成
    if(widget.listMap != null) {
    }

    dishController = TextEditingController(text: widget.listMap?['list_title'] ?? "");
    super.initState();
  }

  _setImagePath() async {
    _imagePath = (await getApplicationDocumentsDirectory()).path;
  }

  @override
  void dispose() {
    print('フォーム dispose:停止');
    dishController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BannerBody(
          child: Scaffold(
            body: GestureDetector(
              onTap: () { FocusScope.of(context).requestFocus(FocusNode()); print("tap");},
              child: Visibility(
                visible: App.isVisible,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // アップバー
                        CustomAppBar(
                          title: widget.listMap != null ? '追加' : '編集',
                          leftButton: IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: App.btn_color),
                            onPressed: () { Navigator.of(context).pop(); },
                          ),
                          rightButton: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),),
                          onTap:() {
                            _save();
                            Navigator.pop(context);
                            setState(() {});
                          }
                        ),
                      dishTitle(), //料理名
                      Container(padding: EdgeInsets.all(padding),),
                        /*
                         * メモ
                         */
                        Container(
                          padding: EdgeInsets.all(padding),
                          child: TextField(
                            controller: memoController,
                            decoration: InputDecoration(
                              labelText: 'メモ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            minLines: 5,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }

  //戻るボタンが押されたとき
  // Future<bool> _backButtonPress(BuildContext context) async {
  //   _save();
  //   return true;
  // }

  void _save() {
    // 新規 かつ 空白　＝＞ 何もしない
    // 編集 かつ 空白　＝＞ 削除
    // 編集 かつ 文字変更なし =>　何もしない　
    // それ以外　＝＞ 内容を保存
    // CreditCard card = CreditCard(dishController.text, 1,DateTime.now(), null);
    if(widget.listMap == null) { // 新規
      if(dishController.text != '') { // 入力がある
        // insertCard(
        //   CreditCard(
        //     null, // listIDはDB側の処理で定義する
        //     cards[0].frontPath,
        //     cards[0].backPath,
        //     0,
        //     DateTime.now(),
        //     null
        //   ),
        //   ListTable(
        //     null,
        //     dishController.text,
        //     memoController.text,
        //     0,
        //     DateTime.now(),
        //     null
        //   )
        // );
      }
      return;
    } else { //編集
      if(dishController.text == '') { // 空白
      } else { // 入力がある
        // updateCard(
        //     CreditCard.withId(
        //         widget.listMap!['card_id'],
        //         widget.listMap!['list_id'],
        //         cards[0].frontPath,
        //         cards[0].backPath,
        //         widget.listMap!['card_sort'],
        //         DateTime.now(),
        //         null
        //     ),
        //     ListTable.withId(
        //         widget.listMap!['list_id'],
        //         null, //TODO: タグIDを設定
        //         // widget.listMap!['card_id'],
        //         dishController.text,
        //         memoController.text,
        //         widget.listMap!['list_sort'],
        //         DateTime.now(),
        //         null
        //     )
        // );
      }
    }
  }

  Future<void> insertCard(FoodStorage card) async {
    await DatabaseHelper().insertStorage(card);
    setState(() {});
  }

  Future<void> updateCard(FoodStorage card) async {
    await DatabaseHelper().updateStorage(card);
    setState(() {});
  }

  Future<void> deleteCard(FoodStorage card) async {
    // await databaseHelper.deleteCard(card.id ?? 0);
    setState(() {});
  }

  //カメラ　ダイアログ
  void AddPositionDialog(context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('選択してください'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('写真を撮る'),
            onPressed: () async {
              setState(() {});
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CameraWidget(),
                  settings: const RouteSettings(name: 'camera_page'),
                ),
              );
              var croppedFile = await _cropImage(result);
              // frontImage = Image.file(File(croppedFile?.path));
              setState(() {});
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('アルバムから読み取る'),
            onPressed: () {
              _pickImage();
              setState(() {});
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  //画像調整
  Future<CroppedFile?> _cropImage(file) async {
    var croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 5,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: '画像編集',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
          const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );
    return croppedFile;
  }

  //アルバムから読み取る
  Future<void> _pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      var croppedFile = await _cropImage(pickedFile);
      if (croppedFile != null) {
        var savePath = await _savePhoto(croppedFile, pickedFile?.name);
        frontImage = Image.file(File(savePath));
      }
      Future.delayed(const Duration(seconds: 1), () {
        App.isCamera = false; // TODO　削除予定
      });

      setState(() {});
    } on PlatformException catch (e) {
      // スナップバー
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('画像の選択に失敗しました。※jpeg未対応'),
        ),
      );
      print('画像の選択に失敗しました: $e');
    }
  }

  Future<String> toBase64(pickedFile) async {
    var bytes = File(pickedFile?.path ?? '');
    return base64Encode(await bytes.readAsBytes());
  }

  // 写真を保存する
  Future<String> _savePhoto(photo, name) async {
    final Uint8List buffer = await photo.readAsBytes();
    final String savePath = '$_imagePath/${name}';
    final File saveFile = File(savePath);
    saveFile.writeAsBytesSync(buffer, flush: true, mode: FileMode.write);
    // 画像ギャラリーにも保存（オプション）
    // await ImageGallerySaver.saveImage(buffer, name: photo.name);
    // print('写真を保存する');
    // print(saveFile.path);
    return saveFile.path;
  }

  // 料理名
  Widget dishTitle() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: TextField(
        controller: dishController,
        decoration: InputDecoration(
          labelText: '料理名',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}

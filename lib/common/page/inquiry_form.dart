import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ncmb/ncmb.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../app.dart';

enum InputMode{
  create,
  edit
}

class InquiryForm extends StatefulWidget {
  const InquiryForm({Key? key,required this.inputMode, this.mapData}) : super(key: key);
  final InputMode inputMode;
  final NCMBObject? mapData;

  @override
  _InquiryFormState createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {

  TextEditingController controller = TextEditingController();
  TextEditingController adminController = TextEditingController();
  String? _deviceId;
  final picker = ImagePicker();
  // PickedFile pickedFile;
  String base64 = "";
  final _GlobalKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    App.ncmb;
    initPlatformState();
    if(widget.inputMode == InputMode.edit) {
      controller = TextEditingController(text: widget.mapData?.getString("msg"));
      adminController = TextEditingController(text: widget.mapData?.getString("admin_msg"));
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    FocusNode();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _GlobalKey,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: GestureDetector(
            onTap: () =>
                FocusScope.of(context).requestFocus(new FocusNode()),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: App.primary_color,
                title: Text(widget.inputMode == InputMode.create ? 'お問い合わせフォーム':'お問い合わせフォーム(確認)'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(height: 50,),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 5,
                        controller: controller,
                        validator: (value) {
                          print(value);
                          if (value == null || value.isEmpty) {
                            return '入力してください';
                          }
                          else if(value.length < 10){
                            return '最低10文字以上入力してください';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          // hintText: 'プレースホルダ',
                          labelText: 'お問い合わせ内容',
                          //この一行
                          alignLabelWithHint: true,
                          suffixIcon:
                          widget.inputMode == InputMode.create
                              ?
                            IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              controller.clear();
                            },
                          )
                              :
                          null,
                        ),
                      ),
                    ),
//管理者返信
                    !(widget.inputMode == InputMode.create || adminController.text == "")
                        ?
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 5,
                        controller: adminController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '回答',
                          //この一行
                          alignLabelWithHint: true,
                        ),
                      ),
                    )
                        :
                    Container(),
//添付ボタン
                    widget.inputMode == InputMode.create
                        ?
                    Align(
                      alignment: Alignment.centerRight,
                      child: MaterialButton(
                        onPressed: () => imageDialog(context),
                        child: Icon(Icons.attach_file),
                        padding: EdgeInsets.all(16),//パディング
                        color: base64 == "" ? Colors.grey[200] : Theme.of(context).primaryColor, //背景色
                        // textColor: Colors.white, //アイコンの色
                        shape: CircleBorder(),//丸
                      ),
                    )
                        :
                    Container(),

                    widget.inputMode == InputMode.create
                        ?
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary : Theme.of(context).primaryColor,
                      ),
                      onPressed: (){
                        print(_GlobalKey.currentState?.validate());
                        if (_GlobalKey.currentState?.validate() ?? false) {
                          save();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("送信",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                        :
                    Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> save() async{
    NCMBObject item = NCMBObject(App.table_name)
    // 値を設定
    ..set('msg', controller.text)
    ..set('image', base64)
    ..set('admin_msg', '')
    ..set('device_id', _deviceId!)
    ..set('del', 0);
    // 保存（awaitで非同期処理を実行）
    await item.save();
    // 保存が完了したらobjectIdをデバッグ表示
    print(item.get('objectId'));
  }
//==============画像処理 start================

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    var bytes = new File(pickedFile?.path ?? '');
    final Uint8List = await bytes.readAsBytes();
    base64 = base64Encode(Uint8List);
    setState(() {});
    // base64 = await imageEncode(File(pickedFile.path));
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    var bytes = new File(pickedFile?.path ?? '');
    final Uint8List = await bytes.readAsBytes();
    base64 = base64Encode(Uint8List);
    setState(() {});
    // base64 = await imageEncode(File(pickedFile.path));
  }

  Future<String> imageEncode(File file) async {
    // if(file == null) return "";
    final bytes = await compressFile(file);
    return base64Encode(bytes);
  }
  //リサイズ
  Future<Uint8List> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 600,
      minHeight: 374,
      quality: 94,
    );
    return result ?? Uint8List(0);
  }

  void imageDialog(context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('選択してください'),
        // message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('写真を撮る'),
            onPressed: () {
              getImageCamera();
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('アルバムから読み取る'),
            onPressed: () {
              getImageGallery();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

//==============画像処理 end================
}

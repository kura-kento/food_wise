import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ncmb/ncmb.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../app.dart';
import 'inquiry_form.dart';

//【共通】お問い合わせ画面
class InquiryPage extends StatefulWidget {
  const InquiryPage({Key? key}) : super(key: key);

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  String? _deviceId;
  @override
  void initState() {
    // TODO: implement initState
    App.ncmb;
    initPlatformState();
    super.initState();
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
          child: Scaffold(
            // backgroundColor: App.primary_color,
            appBar: AppBar(
              backgroundColor: App.primary_color,
              title: Text("お問い合わせ"),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("アプリ改善案や不具合のなどを伝えていただければ嬉しいです。またアプリの感想なども受け付けております。"),
                      ),
//                       Container(child:
//                         Text(
//                          '''
// アップデート予定
//
//                         ''')
//                       ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor : Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return InquiryForm(inputMode: InputMode.create,);
                              },
                            ),
                          );
                        },
                        child: const Text(
                            "お問い合わせフォーム",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FutureBuilder(
                      future: future(),
                      builder: (context, future){
                        if(!future.hasData){
                          return Container();
                        }
                        return ListView.builder(
                          itemCount: future.data?.length,
                          itemBuilder: (context, int index){
                            return Card(
                                child: Slidable(
                                  key: const ValueKey(0),
                                  // actionPane: const SlidableDrawerActionPane(),
                                  // actionExtentRatio: 0.15,
                                  child: ListTile(
                                    title: Text(
                                      future.data?[index].get('msg'),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    trailing: future.data?[index].get('admin_msg') == "" ? null : Icon(Icons.mark_email_unread_outlined),
                                    // subtitle: Text("サブタイトル"),
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return InquiryForm(inputMode: InputMode.edit,mapData: future.data?[index],);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    dismissible: DismissiblePane(onDismissed: () {}),
                                    children: [
                                      SlidableAction(
                                        onPressed: (BuildContext context) {
                                          print(index);
                                          del(future.data?[index]);
                                          setState(() {});
                                          // スナップバー
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('お問合せ内容を削除しました。'),
                                            ),
                                          );
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: '削除',
                                      ),
                                    ],
                                  )
                                ),
                            );
                          },
                        );
                      }
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  Future<List> future() async {
    //管理デバイス'7573EA19-F410-45EF-B364-81F30E7199C1'
    NCMBQuery query = NCMBQuery(App.table_name);
    if(_deviceId != '6B570FE2-CA15-463D-8B76-735FFA15588F') {
      query.equalTo('device_id',_deviceId!);
    }
    query.equalTo('del', 0);
    var items =  query.fetchAll();
    // // var check = await items;
    // query.notInArray("disabled",1);
    // var check =  query.fetchAll();
    // print(check);
    // // print(check.contains({"disabled":1}));
    return items;
  }

  Future<void> del(NCMBObject item) async {
    item.set('del', 1);
    await item.save();
    // 保存が完了したらobjectIdをデバッグ表示
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../abmob/reward_widget.dart';
import '../app.dart';
import '../color_picker.dart';
import '../page/inquiry_page.dart';
import '../shared_prefs.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  TextEditingController passController = TextEditingController(text: SharedPrefs.getPassword());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 55,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: App.primary_color,
                ),
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                child: const Center(
                  child: Text('設定',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
            ),
          ),
          const RewardWidget(),
          const Divider(color: Colors.black, height:0),
          Container(
            color: Theme.of(context).backgroundColor,
            child: ListTile(
              title: const Text('パスワードの有無'),
              trailing: CupertinoSwitch(
                value: SharedPrefs.getIsPassword(),
                onChanged: (bool value) {
                  setState(() {
                    SharedPrefs.setIsPassword(value);
                  });
                },
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            child: ListTile(
              title: TextField(
                controller: passController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                  // FilteringTextInputFormatter.allow(RegExp(r'[0–9]+'))
                ],
                decoration: const InputDecoration(
                  labelText: "パスワード",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  SharedPrefs.setPassword(value);
                },
              ),
            ),
          ),
          ListTile(
            title: const Text('カラーテーマ'),
            leading: const Icon(Icons.color_lens_outlined),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ColorPicker();
                  },
                ),
              );
            },
          ),
          // const Divider(color: Colors.grey,height:0),
          // ListTile(
          //   title: const Text('文字の設定'),
          //   trailing: const Icon(Icons.text_rotation_none),
          //   onTap: (){
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) {
          //           return TextSetting();
          //         },
          //       ),
          //     );
          //   },
          // ),
          const Divider(color: Colors.grey,height:0),
          ListTile(
            title: Text(
              "広告の位置（${SharedPrefs.getAdPositionTop() ? "下" : "上"}変更）",
            ),
            trailing: const Icon(Icons.ad_units_outlined),
            onTap: () {
              setState(() {
                SharedPrefs.setAdPositionTop(!SharedPrefs.getAdPositionTop());
              });
              RestartWidget.restartApp(context);
            },
          ),
          const Divider(color: Colors.grey,height:0),
          ListTile(
            title: const Text(
              "お問い合わせ",
            ),
            trailing: const Icon(Icons.insert_comment_outlined),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const InquiryPage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

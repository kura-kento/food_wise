import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/SelectDialog.dart';
import '../common/abmob/reward_widget.dart';
import '../common/shared_prefs.dart';
import '../model/database_help.dart';

class SettingPage extends StatefulWidget {

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // final BannerAd myBanner = AdMob.admobBanner();
  // final BannerAd myBanner2 = AdMob.admobBanner2();
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController unitController = TextEditingController();
  TextEditingController passwordController = TextEditingController(text: SharedPrefs.getPassword());

  int _numRewardedLoadAttempts = 0;

  @override
  void initState() {
    // updateListViewCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if(AdMob.isNoAds() == false){
    //   myBanner.load();
    //   myBanner2.load();
    // }

    return Column(
      children: [
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: SharedPrefs.getAdPositionTop()
        //       ? AdMob.adContainer(myBanner)
        //       : Container(),
        // ),
        Expanded(
          child: Scaffold(
              body: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Column(
                    children: [
                      Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text('設定', style: TextStyle(fontSize: 20,color: Colors.black)),
                          )
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                RewardWidget(),
                                Divider(color: Colors.grey,height:0),
                                ListTile(
                                    title: Text('パスワードの有無'),
                                    trailing: CupertinoSwitch(
                                      value: SharedPrefs.getIsPassword(),
                                      onChanged: (bool value) {
                                        setState(() {
                                          SharedPrefs.setIsPassword(value);
                                        });
                                      },
                                    )
                                ),
                                ListTile(
                                  title: TextField(
                                    controller: passwordController,
                                    maxLength: 8,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                      // FilteringTextInputFormatter.allow(RegExp(r'[0–9]+'))
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: "パスワード",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (String value){
                                      SharedPrefs.setPassword(value);
                                    },
                                  )
                                ),
                                Divider(color: Colors.grey,height:0),
                                SelectDialog(),
                                Divider(color: Colors.grey,height:0),
                                // InkWell()
                                // Divider(color: Colors.grey,height:0),
                                // Padding(
                                //     padding: EdgeInsets.only(top:5,bottom:5),
                                //     child:Column(
                                //       children: <Widget>[
                                //         Text("${AppLocalizations.of(context).unit}${AppLocalizations.of(context).edit}"),
                                //         Row(
                                //           children: <Widget>[
                                //             Expanded(
                                //               flex: 1,
                                //               child: Text("${AppLocalizations.of(context).unit}：",
                                //                 textAlign: TextAlign.center,
                                //                 textScaleFactor: 1.5,
                                //               ),
                                //             ),
                                //             Expanded(
                                //               flex:2,
                                //               child: TextField(
                                //                 onTap: (){
                                //                   unitController.text = SharedPrefs.getUnit();
                                //                 },
                                //                 controller: unitController,
                                //                 decoration: InputDecoration(
                                //                     labelText: '${SharedPrefs.getUnit()}',
                                //                     border: OutlineInputBorder(
                                //                         borderRadius: BorderRadius.circular(5.0)
                                //                     )
                                //                 ),
                                //               ),
                                //             ),
                                //             Expanded(
                                //                 flex: 1,
                                //                 child: Padding(
                                //                   padding: const EdgeInsets.all(8.0),
                                //                   child:
                                //                   ElevatedButton(
                                //                     style: ElevatedButton.styleFrom(
                                //                       primary: App.NoAdsButtonColor, //ボタンの背景色
                                //                     ),
                                //                     onPressed: () {
                                //                         setState(() {
                                //                           SharedPrefs.setUnit("${unitController.text}");
                                //                           FocusScope.of(context).unfocus();
                                //                         });
                                //                     },
                                //                     child: AutoSizeText(
                                //                       AppLocalizations.of(context).update,
                                //                       minFontSize: 4,
                                //                       maxLines: 1,
                                //                       textScaleFactor: 1.5,
                                //                       style: TextStyle(fontSize: App.BTNfontsize),
                                //                     ),
                                //                   ),
                                //                 ),
                                //             )
                                //           ],
                                //         ),
                                //       ],
                                //     )
                                // ),
                                Padding(
                                  padding:EdgeInsets.only(top:10.0),
                                ),
                                Divider(color: Colors.grey,height:0),
                                // InkWell(
                                //   child: Container(
                                //     padding: EdgeInsets.all(15.0),
                                //     width: MediaQuery.of(context).size.width,
                                //     child: Center(
                                //       child: Text(
                                //         AppLocalizations.of(context).deleteAllBalancedata,
                                //         textScaleFactor: 1.5,
                                //         style: TextStyle(color: Colors.red),
                                //       ),
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     setState(() {
                                //       showCupertinoDialog(
                                //         context: context,
                                //         builder: (BuildContext context)
                                //         {
                                //           return CupertinoAlertDialog(
                                //             title: Text(AppLocalizations.of(context).deleteAllDialog),
                                //             //content: Text(""),
                                //             actions: <Widget>[
                                //               CupertinoDialogAction(
                                //                 child: Text(AppLocalizations.of(context).delete),
                                //                 onPressed: () =>
                                //                     allDelete(),
                                //                 isDestructiveAction: true,
                                //               ),
                                //               CupertinoDialogAction(
                                //                 child: Text(AppLocalizations.of(context).cancel),
                                //                 onPressed: () =>
                                //                     Navigator.of(context).pop(),
                                //                 isDefaultAction: true,
                                //               ),
                                //             ],
                                //           );
                                //         },
                                //       );
                                //     });
                                //   },
                                // ),
                                // Divider(color: Colors.grey,height:0),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
        // SharedPrefs.getAdPositionTop()
        //     ? Container()
        //     : AdMob.adContainer(myBanner2),
      ],
    );
  }
  void moveToLastScreen(){
    Navigator.pop(context);
  }

  Widget expandedNull(value){
    return Expanded(
        flex: value,
        child:Container(
          child:Text(""),
        )
    );
  }

//ダイアログ
  Future<void> allDelete() async{
      // await databaseHelper.allDeleteCalendar();
      Navigator.of(context).pop();
  }
}

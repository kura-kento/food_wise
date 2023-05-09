import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../main.dart';
import '../abmob/admob.dart';
import '../app.dart';
import '../shared_prefs.dart';


class TextSetting extends StatefulWidget {
  const TextSetting({Key? key}) : super(key: key);

  @override
  _TextSettingState createState() => _TextSettingState();
}

class _TextSettingState extends State<TextSetting> {
  final BannerAd myBanner = AdMob.admobBanner();
  final BannerAd myBanner2 = AdMob.admobBanner2();
  double _value = SharedPrefs.getTextSize();
  @override
  Widget build(BuildContext context) {
    print('isNoAds:' + AdMob.isNoAds().toString());
    if(AdMob.isNoAds() == false){
      myBanner.load();
      myBanner2.load();
    }

    return SafeArea(
        child: Column(
          children: [
            SharedPrefs.getAdPositionTop()
                ? AdMob.adContainer(myBanner)
                : Container(),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  // backgroundColor: _controller.color,
                  title: Text('文字サイズ変更'),
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 45.0,bottom: 25.0),
                      child: Center(
                        child: Text(
                          "テキスト確認用",
                          style: TextStyle(color: App.text_color, fontSize: SharedPrefs.getTextSize()),
                        ),
                      ),
                    ),
                    Center(
                      child: Slider(
                        label: '文字の大きさ',
                        min: 0,
                        max: 30,
                        value: _value,
                        activeColor: Colors.orange,
                        inactiveColor: Colors.blueAccent,
                        divisions: 10,
                        onChanged: (value) {
                          _value = value;
                          SharedPrefs.setTextSize(value * 1.0);
                          setState(() {});
                        },
                        // onChangeStart: _startSlider,
                        // onChangeEnd: _endSlider,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('※変更した場合、アプリが再起動されます',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor, //ボタンの背景色
                        shape: CircleBorder(),
                        minimumSize: Size(45, 45),
                      ),
                      onPressed: () {
                        // SharedPrefs.setColorString('0xFF' +
                        //     _controller.color.value.toRadixString(16).substring(2, 8));
                        // SharedPrefs.setColorListNumber(0);
                        RestartWidget.restartApp(context);
                      },
                      child: Text('変更',style: TextStyle(color: Colors.white),),
                      // child: Icon(icon),
                    ),
                  ],
                ),
              ),
            ),
            SharedPrefs.getAdPositionTop()
                ? Container()
                : AdMob.adContainer(myBanner2),
          ],
        )
    );
  }
}

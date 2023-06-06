import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_wise/pages/calendar/calendar_page.dart';
import 'package:food_wise/pages/calendar/Widget/form.dart';
import 'package:food_wise/pages/input/input.dart';
import 'package:food_wise/pages/setting_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../common/abmob/admob.dart';
import '../common/app.dart';
import '../common/page_animation.dart';
import '../common/pass_lock.dart';
import '../common/shared_prefs.dart';

class HomePage extends StatefulWidget {
  // const HomePage() : super();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  //以下BottomNavigationBar設定
  int _currentIndex = 0;
  final _pageWidgets = [
    // const ImageOCR(),
    // MemoHome(),
    CalendarPage(),
    InputForm(),

    // const CardList(),
    // CalendarPage(),
    SettingPage(),
  ];
  bool isVisible = true;

  final BannerAd myBanner = AdMob.admobBanner();

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {});
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    tracking();//広告追跡のダイアログ
  }

  Future<void> tracking() async {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("アプリから離れた:paused");
      // onResume処理
      if(SharedPrefs.getIsPassword()) {
        Navigator.push(
          context,
          FadePageRoute(
            page: PassLock(),
            settings: RouteSettings(name: '',),
          ),
        );
      }
    } else if(state == AppLifecycleState.inactive) {
      print("inactive");
      if(SharedPrefs.getIsPassword()) {
        isVisible = false;
        setState(() { });
      }
    } else if(state == AppLifecycleState.resumed) {
      print("resumed:再開時");
      isVisible = true;
      setState(() { });
    }
  }

//メインのページ
  @override
  Widget build(BuildContext context) {
    if(AdMob.isNoAds() == false){
      myBanner.load();
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness:Brightness.dark,
        statusBarIconBrightness:Brightness.dark,
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                Container(
                  child: SharedPrefs.getAdPositionTop()
                      ? AdMob.adContainer(myBanner)
                      : Container(),
                ),
                Expanded(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    body: Visibility(
                      visible: isVisible,
                      child: Column(
                        children: [
                          Expanded(child: _pageWidgets.elementAt(_currentIndex)),
                          Container(
                              child: SharedPrefs.getAdPositionTop()
                                  ? Container()
                                  : AdMob.adContainer(myBanner)
                          ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                            icon: Icon(MdiIcons.noteTextOutline), label: 'メモ'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: '設定'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.settings), label: '設定')
                      ],
                      iconSize: 20.0,
                      selectedFontSize: 10.0,
                      unselectedFontSize: 8.0,
                      elevation: 1.0,
                      currentIndex: _currentIndex,
                      fixedColor: App.primary_color,
                      // fixedColor: Colors.blueAccent,
                      onTap: _onItemTapped,
                      type: BottomNavigationBarType.fixed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);
}
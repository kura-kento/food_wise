import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_wise/pages/card/form.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'bottom_navigation.dart';
import 'common/Custom_There.dart';
import 'common/pass_lock.dart';
import 'common/shared_prefs.dart';
import 'model/database_help.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      RestartWidget(
          child: ProviderScope(child: MyApp()),
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/card_form': (BuildContext context) => CardForm(),
        '/pass': (BuildContext context) => const PassLock(),
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
         // AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja','JP'),Locale('en','US')],
      theme: ThemeData.light().copyWith( // ライト用テーマ
        primaryColor: Color(int.parse(SharedPrefs.getCustomColor())),
        buttonTheme: ButtonThemeData(
            buttonColor: HSLColor.fromColor(CustomTheme.primaryColor)
                .withLightness(0.75,)
                .toColor()
        ),
        scaffoldBackgroundColor: Colors.grey[100], //デフォルト背景色
        backgroundColor: Colors.white,
        // hoverColor: Color(0xFFFFFFF),
      ),
      darkTheme: ThemeData.dark().copyWith( // ダーク用テーマ
        primaryColor: Color(int.parse(SharedPrefs.getCustomColor())),
        buttonTheme: ButtonThemeData(
          buttonColor: HSLColor.fromColor(CustomTheme.primaryColor)
            .withLightness(0.75,)
            .toColor()
        ),
        backgroundColor: const Color(0xFF5D656D),
        hoverColor: const Color(0xFF767E86),
      ),
      home: FutureBuilder(
        //AsyncSnapshot = future:　の中
        builder: (BuildContext context ,AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            return snapshot.data;
          }else{
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: setting(),
      ),
    );
  }
  Future<Widget> setting() async {
    await SharedPrefs.setInstance();
    DatabaseHelper.db = await DatabaseHelper.initializeDatabase();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    //広告
    MobileAds.instance.initialize();

    if(SharedPrefs.getIsPassword()) {
      return  PassLock(returnPage: HomePage());
    } else {
      return HomePage();
    }
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

//一回タップで広がる + タップ状態でもう一度タップ編集
//一行目　タイトル　太字少し大きく　２行目まで表示　通常文字
//:TODO　N行目まで表示　設定
//:TODO　文字選択時のタップ適応範囲を広げる
//:TODO　フォルダー分け(パスワード管理,仕事関係など　に分類できるようにタグ付けとかでもいいかも)
//:TODO　ファイル分け用のテーブル追加？
//:TODO　ボタンの並び替え機能　テーブル追加(updateでsortを書き換える)



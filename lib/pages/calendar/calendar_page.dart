import 'dart:async';
import 'dart:io';
import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_wise/common/layout/appbar.dart';
import '../../common/app.dart';
import '../../common/shared_prefs.dart';
import '../../common/utils.dart';
import '../../model/database_help.dart';
import '../input/input.dart';
import 'Widget/daySquare.dart';
import 'Widget/form.dart';
import 'Widget/week.dart';
import 'package:intl/intl.dart';


final selectDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final addMonthProvider = StateProvider<int>((ref) => 0);

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  // List<Calendar> calendarList = <Calendar>[];

  //表示月
  int selectMonthValue = 0;
  final DateTime _today = DateTime.now();
  // //選択している日
  DateTime selectDay = DateTime.now();
  late int addMonth;

  PageController pageController = PageController(initialPage: App.infinityPage);

  @override
  void initState() {
    // tracking();
    // pageController.addListener(() {
    //   print(pageController.page);
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _infinityPageControllerList.dispose();
    // _infinityPageController.dispose();
    super.dispose();
  }

  // Future<void> tracking() async {
  //   await Admob.requestTrackingAuthorization();
  // }

  void reviewCount() {
    print(SharedPrefs.getLoginCount());
    SharedPrefs.setLoginCount(SharedPrefs.getLoginCount()+1);

    if (Platform.isIOS && SharedPrefs.getLoginCount() % 10 == 0) {
      AppReview.requestReview.then((onValue) {
        print(onValue);
      });
    }else if (Platform.isAndroid && SharedPrefs.getLoginCount() % 20 == 0){
      AppReview.requestReview.then((onValue) {
        print(onValue);
        // showDialog(
        //   context: context,
        //   builder: (_) {
        //     return AlertDialog(
        //       title: Text("このアプリは満足していますか？"),
        //       // content: Text("このアプリは満足していますか？"),
        //       actions: <Widget>[
        //         // ボタン領域
        //         FlatButton(
        //           child: Text("いいえ"),
        //           onPressed: () {
        //             Navigator.pop(context);
        //           },
        //         ),
        //         FlatButton(
        //           child: Text("はい"),
        //           onPressed: () {
        //             Navigator.pop(context);
        //             print(onValue);
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    selectDay = ref.watch(selectDayProvider);
    addMonth = ref.watch(addMonthProvider);

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[300],
            child: SafeArea(
              child: Scaffold(
                body: Column(
                  //上から合計額、カレンダー、メモ
                  children: <Widget>[
                    CustomAppBar(
                      title: 'タイトル',
                      rightButton: IconButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return DishForm();
                              },
                            ),
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.add, color: Colors.white,),
                      ),
                    ),
                    CustomAppBar(
                      title: DateFormat('yyyy年MM月').format(selectOfMonth(addMonth)),
                      color: Colors.black12,
                      fontColor: Colors.black87,
                      leftButton: IconButton(
                        onPressed: () {
                          pageController.animateToPage(
                            App.infinityPage + addMonth - 1, // 変更したいページのインデックス
                            duration: const Duration(milliseconds: 300), // アニメーションの時間
                            curve: Curves.ease, // アニメーションのカーブ
                          );
                          // setState(() {});
                        },
                        iconSize: 45, icon: const Icon(Icons.arrow_left, color: Colors.black87,),
                      ),
                      rightButton: IconButton(
                        onPressed: () {
                          pageController.animateToPage(
                            App.infinityPage + addMonth + 1, // 変更したいページのインデックス
                            duration: const Duration(milliseconds: 300), // アニメーションの時間
                            curve: Curves.ease, // アニメーションのカーブ
                          );
                        },
                        iconSize: 45, icon: const Icon(Icons.arrow_right, color: Colors.black87,),
                      ),
                    ),
                    Week(),// 曜日
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) { //引数では移動先のインデックスを受け取る
                          ref.read(addMonthProvider.notifier).state = index - App.infinityPage;
                          ref.read(selectDayProvider.notifier).state = selectOfMonth(index - App.infinityPage);
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              DaySquare(),
                              dishesWidget(),
                            ],
                          ); // 日付ごとの四角の枠;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // カレンダー下の料理リスト
  Widget dishesWidget()  {
    return FutureBuilder(
        future: DatabaseHelper().selectDayDishes(selectDay), // Future<T> 型を返す非同期処理
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
           var  dish = snapshot.data;
            return Expanded(
              child: ListView.builder(
                itemCount: dish.length,
                itemBuilder: (itemBuilder, index) {
                  return Slidable(
                    endActionPane:  ActionPane(
                      extentRatio: 1/5,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            dishDelete(dish[index]['id']);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: InkWell(
                      child: Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1, color: Colors.black26),),),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(dish[index]['dish_name']),
                              Text('${Utils.formatNumber(dish[index]['sum_price'] ?? 0)}円'),
                            ],
                          ),
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return DishForm(dishId: dish[index]['dish_id']);
                            },
                          ),
                        );
                      },
                    ),
                  );
              }),
            );
          } else {
            return const CircularProgressIndicator();
          }
      });
  }

  Future<void> dishDelete(id) async {
    DatabaseHelper().deleteDish(id);
    setState(() {});
  }

//iとjから日程のデータを出す（Date型）
  DateTime calendarDay(int i,int j) {
    final startDay = DateTime(_today.year, _today.month + selectMonthValue, 1);
    final weekNumber = startDay.weekday;
    final calendarStartDay =
    startDay.add(Duration(days: -(weekNumber % 7) + (i + 7 * j)));
    return calendarStartDay;
  }
//月末の日を取得（来月の１日を取得して１引く）
  int endOfMonth() {
    final startDay = DateTime(_today.year, _today.month + 1 + selectMonthValue, 1);
    final endOfMonth = startDay.add(const Duration(days: -1));
    final _endOfMonth = Utils.toInt(endOfMonth.day);
    return _endOfMonth;
  }
//選択中の月をdate型で出す。
  DateTime selectOfMonth(int value) {
    final _selectOfMonth = DateTime(_today.year, _today.month + value, 1);
    return  _selectOfMonth;
  }

  Future <void> _delete(int id) async {
    // await databaseHelper.deleteCalendar(id);
  }

}
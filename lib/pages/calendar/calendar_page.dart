import 'dart:async';
import 'dart:io';
import 'package:app_review/app_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:food_wise/common/layout/appbar.dart';
import 'package:intl/intl.dart';
import '../../common/app.dart';
import '../../common/shared_prefs.dart';
import '../../common/utils.dart';
import '../../model/FoodStorage.dart';
import 'Widget/daySquare.dart';
import 'Widget/week.dart';

final selectDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // List<Calendar> calendarList = <Calendar>[];

  //表示月
  int selectMonthValue = 0;
  final DateTime _today = DateTime.now();
  // //選択している日
  DateTime selectDay = DateTime.now();
  // int _initialPage = 0;
  // int _scrollIndex = 0;
  // Map<String,dynamic> monthMap;
  // var yearSum;
  // Map<String,dynamic> yearMap;
  // int calendarClose = 0;
  // int _realIndex= 1000000000;

  bool isLoading = true;


  @override
  void initState() {
    // tracking();
    updateListViewCategory();
    // _infinityPageControllerList = InfinityPageController(initialPage: 0);
    // _infinityPageController = InfinityPageController(initialPage: 0);
    dataUpdate();
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
                          // await Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return EditForm(selectDay: selectDay,inputMode: InputMode.create);
                          //     },
                          //   ),
                          // );
                          // updateListViewCategory();
                          // dataUpdate();
                          // reviewCount();
                        },
                        icon: const Icon(Icons.add, color: Colors.white,),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Week(),// 曜日
                          DaySquare(), // 日付ごとの四角の枠
                          ...memoList(),
                        ],
                      )
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

  final List<String> _title =['month','year','both','monthDouble', 'yearDouble'];

  // Map<String,Widget> appbarWidgetsMap() {
  //   final _widgets = <String,Widget>{};
  //   final _string = <String>[
  //     // monthMap["SUM"]
  //     // yearSum
  //     "合計値(月)：${Utils.commaSeparated(100)}${SharedPrefs.getUnit()}",
  //     '合計値：${Utils.commaSeparated(200)}${SharedPrefs.getUnit()}',
  //   ];
  //   for(var i=0;i<2;i++){
  //     _widgets[_title[i]]=(
  //         Center(
  //             child: Text(
  //               _string[i],
  //               maxLines: 1,
  //               style: const TextStyle(fontSize: 25),
  //             )
  //         )
  //     );
  //   }
  //   _widgets['both']=(
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: <Widget>[
  //               Text('${AppLocalizations.of(context).annualTotal}：',style: const TextStyle(fontSize: 12.5),),
  //               Text('${AppLocalizations.of(context).monthlyTotal}：',style: const TextStyle(fontSize: 12.5),)
  //             ],
  //           ),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: <Widget>[
  //               Text('${Utils.commaSeparated(yearSum)}${SharedPrefs.getUnit()}',
  //                 style: const TextStyle(fontSize: 12.5),),
  //               Text("${Utils.commaSeparated(monthMap["SUM"])}${SharedPrefs.getUnit()}",
  //                   style: const TextStyle(fontSize: 12.5)),
  //             ],
  //           ),
  //         ],
  //       )
  //   );
  //   _widgets['monthDouble']=(
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Column(
  //             children: [
  //               Text('${AppLocalizations.of(context).monthlyTotalPlus}：',style: const TextStyle(fontSize: 12.5)),
  //               Text('${AppLocalizations.of(context).monthlyTotalMinus}：',style: const TextStyle(fontSize: 12.5)),
  //             ],
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: <Widget>[
  //               Text("${Utils.commaSeparated(monthMap["PLUS"])}${SharedPrefs.getUnit()}",
  //                 style: TextStyle(fontSize: 12.5, color: App.plusColor),),
  //               Text("${Utils.commaSeparated(monthMap["MINUS"])}${SharedPrefs.getUnit()}",
  //                   style: TextStyle(fontSize: 12.5, color: App.minusColor)),
  //             ],
  //           ),
  //         ],
  //       )
  //   );
  //
  //   _widgets['yearDouble']=(
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Column(
  //             children: [
  //               Text('${AppLocalizations.of(context).annualTotal}：',style: const TextStyle(fontSize: 12.5)),
  //               Text('${AppLocalizations.of(context).annualTotal}：',style: const TextStyle(fontSize: 12.5)),
  //             ],
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: <Widget>[
  //               Text("${Utils.commaSeparated(yearMap["PLUS"])}${SharedPrefs.getUnit()}",
  //                 style: TextStyle(fontSize: 12.5, color: App.plusColor),),
  //               Text("${Utils.commaSeparated(yearMap["MINUS"])}${SharedPrefs.getUnit()}",
  //                   style: TextStyle(fontSize: 12.5, color:App.minusColor)),
  //             ],
  //           ),
  //         ],
  //       )
  //   );
  //   return _widgets;
  //
  
//カレンダーの日付部分（2行目以降）
//   List<Widget> dayList() {
//     final resultWeekList = <Widget>[];
//     for (var j = 0; j < 6; j++) {
//       final resultWeek = <Widget>[];
//       for (var i = 0; i < 7; i++) {
//         resultWeek.add(
//           Expanded( flex: 1, child: calendarSquare(calendarDay(i, j)),),
//         );
//       }
//       resultWeekList.add(Row(children: resultWeek));
//       //土曜日の月が選択月でない　または、月末の場合は終わる。
//       if (Utils.toInt(calendarDay(6, j).month) != selectOfMonth(selectMonthValue).month
//           || endOfMonth() == Utils.toInt(calendarDay(6, j).day)) {
//         break;
//       }
//     }
//     return resultWeekList;
//   }

//カレンダー１日のマス（その月以外は空白にする）
//   Widget calendarSquare(DateTime date) {
//     if(date.month == selectOfMonth(selectMonthValue).month) {
//       return Container(
//         color: Colors.grey[100],
//         height: 50.0,
//         child: Stack(
//           children: <Widget>[
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: Colors.white),
//                 color:  DateFormat.yMMMd().format(selectDay) ==  DateFormat.yMMMd().format(date)  ? Colors.yellow[300] : Colors.transparent ,
//               ),
//               child: Column(
//                   children: squareValue(date)
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(2.0),
//               child: Row(
//                 // crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       height: 46/3,
//                       color: DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(_today) ? Colors.red[300] : Colors.transparent ,
//                       child: Center(
//                         child: Text(
//                           '${Utils.toInt(date.day)}',
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             fontSize: Utils.parseSize(context, 10.0),
//                             color: DateFormat.yMMMd().format(date) ==  DateFormat.yMMMd().format(_today) ? Colors.white : Colors.black87 ,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Spacer(flex: 3,)
//                 ],
//               ),
//             ),
//             //クリック時選択表示する。
//             TextButton(
//               child: Container(),
//               onPressed: () async {
//                 // if(selectDay == date) {
//                 //   await Navigator.of(context).push(
//                 //     MaterialPageRoute(
//                 //       builder: (context) {
//                 //         return EditForm(selectDay: selectDay,inputMode: InputMode.create);
//                 //       },
//                 //     ),
//                 //   );
//                 //   updateListViewCategory();
//                 //   dataUpdate();
//                 //   reviewCount();
//                 // }else{
//                 //   selectDay = date;
//                 //   setState((){});
//                 // }
//               },
//             ),
//           ],
//         ),
//       );
//     }else{
//       return Container(
//         color: Colors.grey[200],
//         height: 50.0,
//       );
//     }
//   }

  // //１日のマスの中身
  // List<Widget> squareValue(DateTime date) {
  //   final resultWeekList = <Widget>[Expanded(flex: 1, child: Container())];
  //   for(var i =0; i<2; i++){
  //     resultWeekList.add(
  //       Expanded(
  //           flex: 1,
  //           child: Container(
  //               child: Align(
  //                   alignment: Alignment.centerRight,
  //                   child: Text(
  //                     moneyOfDay(i,date),
  //                     style: TextStyle(
  //                       // color: i == 0 ? App.plusColor:App.minusColor
  //                     ),
  //                     maxLines: 1,
  //                   )
  //               )
  //           )
  //       ),
  //     );
  //   }
  //   return resultWeekList;
  // }

  //一日のリスト（カレンダー下）
  List<Widget> memoList() {
    final resultWeekList = <Widget>[];
    var calendarList = [];
    for(var i = 0; i < calendarList.length ; i++) {
      if(DateFormat.yMMMd().format(calendarList[i].date) == DateFormat.yMMMd().format(selectDay)) {
        resultWeekList.add(
          InkWell(
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom:BorderSide(width: 1, color: Colors.black26),
                ),
              ),
              child: Slidable(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('調整前'),
                    Center(
                      child: Text(
                          '${Utils.commaSeparated(calendarList[i].money)}${SharedPrefs.getUnit()}　',
                          style: const TextStyle(
                              // color: calendarList[i].money >= 0 ? App.plusColor : App.minusColor
                          )
                      ),
                    ),
                  ],
                ),
                // TODO:      secondaryActions: <Widget>[
                //         IconSlideAction(
                //             caption: '削除',
                //             color: Colors.red,
                //             icon: Icons.delete,
                //             onTap: () {
                //               _delete(calendarList[i].id);
                //               dataUpdate();
                //             }
                //          )
                // ]
              ),
            ),
            onTap: () async {
              // await Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return EditForm(selectCalendarList: calendarList[i],inputMode: InputMode.edit,);
              //     },
              //   ),
              // );
              // updateListViewCategory();
              // dataUpdate();
            },
          ),
        );
      }
    }
    return resultWeekList;
  }

  Future<void> updateListView(DateTime month) async {
//全てのDBを取得
//     calendarList = await databaseHelper.getCalendarMonthList(month);
    setState(() {});
  }

  Future<void> updateListViewCategory() async {
//収支どちらか全てのDBを取得
//     this.categoryList = await databaseHelperCategory.getCategoryListAll();
    setState(() {});
  }
  Future<void> dataUpdate() async {
    // final selectMonthDate = DateTime(_today.year, _today.month + selectMonthValue+_scrollIndex, 1);
    // monthMap = await databaseHelper.getCalendarMonthInt(selectMonthDate);
    // yearSum = await databaseHelper.getCalendarYearDouble(selectMonthDate);
    // yearMap = await databaseHelper.getCalendarYearMap(selectMonthDate);
    // isLoading = false;
    // updateListView(selectOfMonth(selectMonthValue));
    // print(selectMonthDate);
    // print(monthMap);
    // setState(() {});
  }
//カレンダー表示している日の合計
  String moneyOfDay(int _index, DateTime date) {
    return '調整前';
    // double _plusMoney = 0;
    // double _minusMoney = 0;
    // for (var index = 0; index < calendarList.length; index++) {
    //   if (DateFormat.yMMMd().format(calendarList[index].date) == DateFormat.yMMMd().format(date)) {
    //     if (calendarList[index].money > 0) {
    //       _plusMoney += calendarList[index].money;
    //     } else {
    //       _minusMoney += calendarList[index].money;
    //     }
    //   }
    // }
    // return   '${Utils.commaSeparated(_index == 0 ? _plusMoney : _minusMoney*(-1) )}${SharedPrefs.getUnit()}';
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
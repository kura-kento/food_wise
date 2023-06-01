import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/app.dart';
import '../../../common/utils.dart';
import '../calendar_page.dart';


class DaySquare extends ConsumerStatefulWidget {
  const DaySquare({Key? key}) : super(key: key);

  @override
  DaySquareState createState() => DaySquareState();
}

class DaySquareState extends ConsumerState<DaySquare> {
  int selectMonthValue = 0; //表示月
  final DateTime _today = DateTime.now();
  // //選択している日
  late DateTime selectDay;

  @override
  Widget build(BuildContext context) {
    selectDay = ref.watch(selectDayProvider);

    final resultWeekList = <Widget>[];
    for (var j = 0; j < 6; j++) {
      final resultWeek = <Widget>[];
      for (var i = 0; i < 7; i++) {
        resultWeek.add(
          Expanded( flex: 1, child: calendarSquare(calendarDay(i, j)),),
        );
      }
      resultWeekList.add(Row(children: resultWeek));
      //土曜日の月が選択月でない　または、月末の場合は終わる。
      if (Utils.toInt(calendarDay(6, j).month) != selectOfMonth(selectMonthValue).month
          || endOfMonth() == Utils.toInt(calendarDay(6, j).day)) {
        break;
      }
    }
    return Column(children: resultWeekList);
  }

  //カレンダー１日のマス（その月以外は空白にする）
  Widget calendarSquare(DateTime date) {
    if(date.month == selectOfMonth(selectMonthValue).month) {
      return Container(
        color: Colors.grey[100],
        height: 50.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                color:  DateFormat.yMMMd().format(selectDay) ==  DateFormat.yMMMd().format(date)  ? Colors.yellow[300] : Colors.transparent ,
              ),
              child: Column(
                  children: squareValue(date)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 46/3,
                      color: DateFormat.yMMMd().format(date) == DateFormat.yMMMd().format(_today) ? Colors.red[300] : Colors.transparent ,
                      child: Center(
                        child: Text(
                          '${Utils.toInt(date.day)}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: Utils.parseSize(context, 10.0),
                            color: DateFormat.yMMMd().format(date) ==  DateFormat.yMMMd().format(_today) ? Colors.white : Colors.black87 ,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(flex: 3,)
                ],
              ),
            ),
            //クリック時選択表示する。
            TextButton(
              child: Container(),
              onPressed: () async {
                if(selectDay == date) {
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
                  // setState((){});
                }else{
                  // ref.read(selectDayProvider.state) = date;
                  selectDay = date;
setState((){});
                }
              },
            ),
          ],
        ),
      );
    }else{
      return Container(
        color: Colors.grey[200],
        height: 50.0,
      );
    }
  }

  //１日のマスの中身
  List<Widget> squareValue(DateTime date) {
    final resultWeekList = <Widget>[Expanded(flex: 1, child: Container())];
    for(var i =0; i<2; i++){
      resultWeekList.add(
        Expanded(
            flex: 1,
            child: Container(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      moneyOfDay(i,date),
                      style: TextStyle(
                        color: i == 0 ? App.plusColor : App.minusColor ,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                    )
                )
            )
        ),
      );
    }
    return resultWeekList;
  }

  //カレンダー表示している日の合計
  String moneyOfDay(int _index, DateTime date) {
    return '金額0円';

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
}

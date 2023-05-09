import 'package:flutter/cupertino.dart';

class InputForm extends StatefulWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
 String text =
'''
  登録機 0134 塘路樹No1046
  鶏肉          ¥200
  醤油1000ml          ¥1,200
  *ロッテパイの実73g     ¥98
  6650 金額 ¥535
  承認番号　税送料  ¥535
  ポイント対応　¥496
''';

 @override
  void initState() {
    // TODO: implement initState
   textReplace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  List<Map> textReplace() {
    /*
    ①行ごとにリスト化(お金の単位が入っている)
    ②リストから各要素（名前,お金,単位をMAPに）
    数字＋単位　￥数字 3,00コンマ　
    ＊●とかの記号で税が決まる
    */
    // text.replaceAll(from, replace)
    return [{}];
  }
}

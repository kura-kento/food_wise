import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/appbar.dart';
import '../../model/Food.dart';
import '../../model/database_help.dart';
import '../../widget/FoodForm.dart';

class InputForm extends ConsumerStatefulWidget {
  const InputForm({Key? key}) : super(key: key);

  @override
  InputFormState createState() => InputFormState();
}

class InputFormState extends ConsumerState<InputForm> {
  List<Food> sharedFoods = [];

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

 late var insertFoodStorages;
 @override
  void initState() {
   textReplace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   insertFoodStorages = ref.watch(insertFoodStoragesProvider);
    return Column(
      children: [
        CustomAppBar(
            title: '',
            // leftButton:
            rightButton:  IconButton(
              icon: const Icon(Icons.save_as, color: Colors.white, size: 30),
              onPressed: () {
                _save();
                setState(() {});
              },
            )
        ),
        Expanded(
            child: FoodFormWidget(foodStorages: [], onButtonPressed: (_){}, isFoodStorages: true)),
      ],
    );
  }

 Future<void> _save() async {
    if(insertFoodStorages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('１つ以上入力して下さい'),
        ),
      );
    } else {
      await DatabaseHelper().insertStorage(insertFoodStorages);
      insertFoodStorages.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存に成功しました。'),
        ),
      );
    }
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


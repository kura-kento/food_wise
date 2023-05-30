import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/app.dart';
import '../../common/layout/appbar.dart';
import '../../enum/Unit.dart';
import '../../model/FoodStorage.dart';
import '../../model/database_help.dart';
import '../../widget/FoodForm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DishForm extends ConsumerStatefulWidget {
  const DishForm({Key? key}) : super(key: key);

  @override
  DishFormState createState() => DishFormState();
}

class DishFormState extends ConsumerState<DishForm> {
  double padding = 10.0;
  EdgeInsets formPadding = const EdgeInsets.only(top:10.0, left:10.0, right:10.0);
  var focusNode = FocusNode();
  TextEditingController dishController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  List<FoodStorage> foodStorages = [];
  double sumPrice = 0;
  late var insertFoodStorages;

  @override
  void initState() {
    selectStorage();
    super.initState();
  }

  void updateMessage(newMessage) {
    sumPrice = newMessage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    insertFoodStorages = ref.watch(insertFoodStoragesProvider);

    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () { FocusScope.of(context).requestFocus(FocusNode()); print("tap");},
          child: Visibility(
            visible: App.isVisible,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    customAppBar(),// アップバー
                    dishTitle(),
                    FoodFormWidget(foodStorages: foodStorages, onButtonPressed: updateMessage, isFoodStorages: false,),
                    memo(), // メモ
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // アップバー
  Widget customAppBar() {
    return CustomAppBar(
        title: '金額:$sumPrice円',
        leftButton: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: App.btn_color),
          onPressed: () { Navigator.of(context).pop(); },
        ),
        rightButton: const Text('保存', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),),
        onTap:() {
          _save();
          Navigator.pop(context);
          setState(() {});
        }
    );
  }

  // 料理名
  Widget dishTitle() {
    return Container(
      padding: formPadding,
      child: TextField(
        controller: dishController,
        decoration: InputDecoration(
          labelText: '料理名',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  // メモ
  Widget memo() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: TextField(
        controller: memoController,
        decoration: InputDecoration(
          labelText: 'メモ',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        minLines: 5,
        maxLines: null,
      ),
    );
  }

  // 選択した食材を配列に入れる
  Future<void> selectStorage() async {
    foodStorages = await DatabaseHelper().getFoodStorage();
    if(foodStorages.isNotEmpty) {
      foodStorages.insertAll(0, [FoodStorage(0, '入力',Unit.piece, 0, 0, 'null', 0, null, null)]);
    }
    setState(() {});
  }

  Widget customAnimatedContainer(String title, {bool isSelected = false, double iconSize = 24}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        border: Border.all(
          width: 2,
          color: Colors.pink,
        ),
        color: isSelected ? Colors.pink : null,
      ),
      child:
      title == '入力'  ?
      Icon(
        Icons.edit,
        size: iconSize,
        color: isSelected ? Colors.white : Colors.pink,
      )
          :
      Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
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
}

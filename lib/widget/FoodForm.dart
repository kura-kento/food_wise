import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:icofont_flutter/icofont_flutter.dart';
import '../enum/Unit.dart';
import '../model/Food.dart';
import '../model/FoodStorage.dart';

class FoodFormWidget extends StatefulWidget {
  FoodFormWidget({Key? key, required this.foodStorages, required this.onButtonPressed}) : super(key: key);
  List<FoodStorage> foodStorages;
  final Function(double) onButtonPressed;

  @override
  State<FoodFormWidget> createState() => _FoodFormWidgetState();
}

class _FoodFormWidgetState extends State<FoodFormWidget> {
  double padding = 10.0;
  EdgeInsets formPadding = const EdgeInsets.only(top:10.0, left:10.0, right:10.0);
  var focusNode = FocusNode();

  TextEditingController foodNameController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');
  TextEditingController volumeController = TextEditingController(text: '0');

  List<Food> foodList = [];
  FoodStorage? selectedFood;
  Volume? selectVolume;
  double sumPrice = 0;

  Unit? selectUnitKind;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        foodListWidget(), //選択中の食材名
        foodTags(),// 料理名
        unitTags(),
        volumeTags(), //　②「量」
        SizedBox(height: 50, child: addButton() ,),// 追加ボタン
      ],
    );
  }

  // 選択中の一覧
  Widget foodListWidget() {
    if(foodList.isEmpty) {
      return Container();
    }

    return Container(
      padding: formPadding,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: foodList.length,
        itemBuilder: (BuildContext context, int index) {
          Food _food = foodList[index];
          return Row(
            children: [
              Expanded(flex: 2, child: Text(_food.foodName, overflow: TextOverflow.ellipsis)),
              Expanded(flex: 1,
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(_food.quantity.toMixedFraction().toString().replaceAll(' 0/1', '').replaceAll('0/1', '0') + (_food.unitKind.typeName ?? ''))),
              ),
              Expanded(flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${(_food.price.isNaN ? priceController.text :_food.price )}円'),
                ),
              ),
              SizedBox(
                width: 30.0,
                height: 30.0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    foodList.removeAt(index);
                    priceSum();
                    setState(() {});
                  },
                  icon: const Icon(IcoFontIcons.close, color: Colors.pink),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  // 料理名
  Widget foodTags() {
    return Container(
      padding: formPadding,
      child: Row(children: foodChildren())
    );
  }

  // 食材名
  List<Widget> foodChildren() {
    final List<FoodStorage> _foodStrages = [...widget.foodStorages];

    _foodStrages.removeWhere((food) { return foodList.any((value) => value.foodName == food.foodName); });
    return [
      const SizedBox(width: 60, child: Text('食品名：')),
      ...(selectedFood != null ? [selectedFood] : _foodStrages).map((food) {
        return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          onTap: () {
            if(selectedFood?.id == food?.id) {
              selectedFood = null;
            } else {
              selectedFood = food;
            }
            selectClear(); // 現在の条件によって選択をクリアする
            setState(() {});
          },
          child: customAnimatedContainer(
            food?.foodName ?? '',
            isSelected: selectedFood?.id == food?.id,
          ),
        );
      }).toList(),
      // 食材名入力フォーム
      ...((selectedFood?.id == 0 || _foodStrages.isEmpty) ? [Expanded(child: foodName())] : []),
    ];
  }

  Widget foodName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        controller: foodNameController,
        decoration: InputDecoration(
          labelText: '食材名',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10,),
        ),
        // minLines: 5,
        // maxLines: null,
      ),
    );
  }

  //②単位
  Widget unitTags() {
    if (selectedFood?.id == null) {
      return Container();
    } else if(selectedFood?.id != 0) {
      selectUnitKind = selectedFood?.unitKind;
    }
print(selectUnitKind);
    return Container(
      padding: formPadding,
      child: Row(
        children: [
          const SizedBox(width: 60, child: Text('単位：')),
          Wrap(
            runSpacing: 4,
            spacing: 4,
            children: [
              //「単位」が未選択の時、全て表示
              ...(selectUnitKind != null ? [selectUnitKind] : Unit.values).map((unit) {
                return InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    onTap: () {
                      selectUnitKind = (selectUnitKind == null ? unit : null);
                      setState(() {});
                    },
                    child: customAnimatedContainer(
                      unit?.typeName ?? '',
                      iconSize: 24.0,
                      isSelected: selectUnitKind != null,
                      color: selectedFood?.id != 0 ? Colors.grey : Colors.pink,
                    )
                );
              }).toList()
            ]),
        ],
      ),
    );   //単位種別
  }

  // ②「量」の選択肢
  Widget volumeTags() {
    //（食材名が空だと）
    if (selectUnitKind == null) {
      return Container();
    }

    print('③量の表示' + selectUnitKind.toString());

    List? tags = UnitMap.volumeMap[selectUnitKind?.name] ?? [];

    return Container(
      width: double.infinity, padding: formPadding,
      child: Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          Container(
            // height:40,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 60, child: Text('量：')),
                  customAnimatedContainer(
                    double.parse(volumeController.text).toMixedFraction().toString().replaceAll(' 0/1', '').replaceAll('0/1', '0'),
                    isSelected: true,
                  ),
                  // ②「量」　入力フォーム
                  selectVolume == UnitMap.manualVolume ? Expanded(child: volumeName()) : Container(),
                  ...(double.parse(volumeController.text) != 0 ? [ eraserAltIcon() ] : []
                  ),
                ],
              ),
            ),
          ),
          ...tags.map((tag) {
            return InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                onTap: () {
                  if(tag.volume == null) {
                    selectVolume = UnitMap.manualVolume;
                  }
                  // 選択中と
                  else if(selectVolume == UnitMap.manualVolume && tag.volume == null) {
                    selectVolume = null;
                  } else {
                    selectVolume = tag;
                    var _sum = double.parse(volumeController.text);
                    _sum += tag.volume;
                    volumeController.text = _sum.toString();
                  }
                  //TODO ボタンを光るように
                  setState(() {});
                },
                child: customAnimatedContainer(
                    tag?.name ?? '',
                    iconSize: 20.0
                )
            );
          }).toList()
        ],
      ),
    );
  }

  Widget volumeName() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: TextField(
        controller: volumeController,
        // onChanged: (text) {setState(() {});},
        decoration: InputDecoration(
          labelText: '量',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10,),
        ),
        // minLines: 5,
        // maxLines: null,
      ),
    );
  }

  Widget price() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: TextField(
        controller: volumeController,
        decoration: InputDecoration(
          labelText: '食材名',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  Widget addButton() {
    return  volumeController.text == '0'
        ?
    Container()
        :
    IconButton(
      icon: const Icon(Icons.add, color: Colors.pink,size: 30),
      onPressed: () {
        foodList.add(
            Food(
              selectedFood?.id == 0 ? foodNameController.text : selectedFood?.foodName ?? '', // 名前
              selectedFood?.unitKind ?? Unit.ml, // 単位？
              double.parse(volumeController.text),
              (selectedFood?.price ?? 0) / (selectedFood?.quantity ?? 0) * double.parse(volumeController.text), // 購入価格 / 全体数量 * 使用数量
            )
        );
        // init();
        selectClear(clearAll: true);
        priceSum();
        setState(() {});
      },
    );
  }

  // 現在の条件によって選択をクリアする
  void selectClear({bool clearAll = false}) {
    if (clearAll) {
      selectedFood = null;
      selectUnitKind = null;
      selectVolume = null;
      priceController.text = '0';
      volumeController.text = '0';
    }
    // ①「料理」が未選択
    else if (selectedFood == null) {
      selectVolume = null;
      selectUnitKind = null;
      priceController.text = '0';
      volumeController.text = '0';
    }
    // ①「料理」が「入力」なら
    else if(selectedFood?.id == 0) {
      // selectVolume = UnitMap.manualVolume;
    }
  }

  Widget customAnimatedContainer(String title, {bool isSelected = false, double iconSize = 24, Color color = Colors.pink}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        border: Border.all(
          width: 2,
          color: color,
        ),
        color: isSelected ? color : null,
      ),
      child:
      title == '入力'  ?
      Icon(
        Icons.edit,
        size: iconSize,
        color: isSelected ? Colors.white : color,
      )
          :
      Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void priceSum() {
    sumPrice = 0;
    for (var food in foodList) { sumPrice += food.price; }
    widget.onButtonPressed(sumPrice);
  }

  Widget eraserAltIcon() {
    return SizedBox(
      height: 25,
      width: 25,
      child: IconButton(
        padding: const EdgeInsets.only(left: 5.0),
        icon: const Icon(IcoFontIcons.eraserAlt, color: Colors.pink),
        onPressed: () {
          volumeController.text = '0';
          setState(() {});
        }
      ),
    );
  }
}

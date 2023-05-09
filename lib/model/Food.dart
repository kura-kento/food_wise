import '../enum/Unit.dart';

class Food {
  Food(
      this.foodName,
      this.unitKind,
      this.quantity,
      this.price,
      );

  late String foodName; //食品名前
  late Unit unitKind; //単位
  late double quantity; //数量
  late double price; //金額

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['food_name'] = foodName;
    map['unit_kind'] = unitKind.name;
    map['quantity'] = quantity;
    map['price'] = price;
    return map;
  }

  Food.fromMapObject(Map<String, dynamic> map) {
    foodName = map['food_name'];
    unitKind = UnitMap.toUnit(map['unit_kind']);
    quantity = map['quantity'];
    price = map['price'];
  }
}
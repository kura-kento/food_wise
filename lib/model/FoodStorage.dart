import 'package:intl/intl.dart';

import '../enum/Unit.dart';
import 'Food.dart';

class FoodStorage extends Food {
  FoodStorage(
      this.id,
      String foodName, //食品名前
      Unit unitKind, //単位
      double quantity, //数量
      double price, //金額
      this.memo,
      this.sort,
      this.createdAt,
      this.deletedAt
  ) : super(foodName, unitKind, quantity, price);

  int? id;
  String? memo;
  int? sort;
  DateTime? createdAt;
  DateTime? deletedAt;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = super.toMap();
    map['id'] = id;
    map['memo'] = memo;
    map['sort'] = sort;
    map['created_at'] = DateFormat('yyyy-MM-dd HH:mm').format(createdAt!);
    map['deleted_at'] = deletedAt == null ? null : DateFormat('yyyy-MM-dd HH:mm').format(deletedAt!);
    return map;
  }

  FoodStorage.fromMapObject(Map<String, dynamic> map) : super.fromMapObject(map) {
    id = map['id'];
    memo = map['memo'];
    sort = map['sort'];
    createdAt = DateTime.parse(map['created_at']);
    deletedAt = map['deleted_at'] == null ? null : DateTime.parse(map['deleted_at']);
  }
}
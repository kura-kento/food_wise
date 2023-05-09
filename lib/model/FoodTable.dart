import 'package:intl/intl.dart';

import '../enum/Unit.dart';
import 'Food.dart';

class FoodTable extends Food {
  FoodTable(
      this.foodStorageId,
      String foodName,
      Unit unitKind,
      double quantity,
      double price,
      this.memo,
      this.sort,
      this.createdAt,
      this.deletedAt
      ) : super(foodName, unitKind, quantity, price);

  int? id;
  int? foodStorageId; // 食糧庫に紐づくID
  String? memo;
  int? sort;
  DateTime? createdAt;
  DateTime? deletedAt;

  //親メソッドの上書き
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap(); //継承元のfoodを初期設定している。
    // Map<String, dynamic> map = {};
    map['id'] = id;
    map['food_storage_id'] = foodStorageId;
    map['memo'] = memo;
    map['sort'] = sort;
    map['created_at'] = DateFormat('yyyy-MM-dd HH:mm').format(createdAt!);
    map['deleted_at'] = deletedAt == null ? null : DateFormat('yyyy-MM-dd HH:mm').format(deletedAt!);
    return map;
  }

  @override
  FoodTable.fromMapObject(Map<String, dynamic> map): super.fromMapObject(map) {
    // print(map['deleted_at']);
    id = map['id'];
    foodStorageId = map['food_storage_id'];
    memo = map['memo'];
    sort = map['sort'];
    createdAt = DateTime.parse(map['created_at']);
    deletedAt = map['deleted_at'] == null ? null : DateTime.parse(map['deleted_at']);
  }
}
import 'package:intl/intl.dart';

class Dish {
  Dish(
    this.id,
    // this.foodId,
    this.dishName,
    this.isFavorite,
    this.memo,
    this.sort,
    this.createdAt,
    this.deletedAt
  );

  int? id;
  // late int foodId;
  late String dishName;
  late bool isFavorite;
  String? memo;
  int? sort;
  DateTime? createdAt;
  DateTime? deletedAt;

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    // map['food_id'] = foodId;
    map['dish_name'] = dishName;
    map['is_favorite'] = isFavorite;
    map['memo'] = memo;
    map['sort'] = sort;
    map['created_at'] = DateFormat('yyyy-MM-dd HH:mm').format(createdAt!);
    map['deleted_at'] = deletedAt == null ? null : DateFormat('yyyy-MM-dd HH:mm').format(deletedAt!);
    return map;
  }

// MapオブジェクトからCalendarオブジェクトを抽出する
  Dish.fromMapObject(Map<String, dynamic> map) {
//    print(map);
    id = map['id'];
    // foodId = map['food_id'];
    dishName = map['dish_name'];
    isFavorite = map['is_favorite'];
    memo = map['memo'];
    sort = map['sort'];
    createdAt = DateTime.parse(map['created_at']);
    deletedAt = map['deleted_at'] == null ? null : DateTime.parse(map['deleted_at']);
  }
}

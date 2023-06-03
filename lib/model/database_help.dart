import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../enum/Unit.dart';
import 'Dish.dart';
import 'Food.dart';
import 'FoodStorage.dart';
import 'UsedFoodTable.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {

  static DatabaseHelper? _databaseHelper;    // Singleton DatabaseHelper
  static late Database db;             // Singleton Database

  // 食糧庫
  static String storageTable = 'food_storages';
  static String colFoodName = 'food_name';
  static String colUnitKind = 'unit_kind';
  static String colQuantity = 'quantity';
  static String colPrice = 'price';

  // 料理
  static String dishTable = 'dishes';
  static String dishName = 'dish_name';
  static String isFavorite = 'is_favorite';

  // 使用済　食材
  static String usedFoodTable = 'used_foods';
  static String dishId = 'dish_id';
  static String foodStorageId = 'food_storage_id';

  //カテゴリー
  static String tableName3 = 'tags';
  // this.id,
  // this.foodId,
  // this.dishName,
  // this.isFavorite,
  // this.memo,
  // this.sort,
  // this.createdAt,
  // this.deletedAt

  //【共通】
  static String colId = 'id';
  static String colSort = 'sort';
  static String colMemo = 'memo';
  static String colCreatedAt = 'created_at';
  static String colDeletedAt = 'deleted_at';

  DatabaseHelper._createInstance(); // DatabaseHelperのインスタンスを作成するための名前付きコンストラクタ

  factory DatabaseHelper() {
    return _databaseHelper ??= DatabaseHelper._createInstance();
  }
  Database get database { return db; }

  static Future<Database> initializeDatabase() async {
    // データベースを保存するためのAndroidとiOSの両方のディレクトリパスを取得する
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/path.db';

    // Open/指定されたパスにデータベースを作成する
    final taskDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return taskDatabase;
  }

  static void _createDb(Database db, int newVersion) async {
    // 食糧庫テーブル作成
    await db.execute('CREATE TABLE $storageTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colFoodName TEXT, $colUnitKind TEXT, $colQuantity REAL, $colPrice REAL, $colMemo TEXT, $colSort INTEGER, $colCreatedAt TEXT, $colDeletedAt TEXT)');
    await db.insert(storageTable, FoodStorage(null, 'キャベツ', Unit.piece, 1, 200, 'メモ', 1 , DateTime.now(), null).toMap());
    await db.insert(storageTable, FoodStorage(null, '卵', Unit.piece, 10, 320, 'メモ', 1 , DateTime.now(), null).toMap());
    await db.insert(storageTable, FoodStorage(null, '鶏肉', Unit.g, 2000, 2000, 'メモ', 1 , DateTime.now(), null).toMap());
    await db.insert(storageTable, FoodStorage(null, '酒', Unit.ml, 1000, 180, 'メモ', 1 , DateTime.now(), null).toMap());
    await db.insert(storageTable, FoodStorage(null, '醤油', Unit.ml, 1000, 250, 'メモ', 1 , DateTime.now(), null).toMap());
    await db.insert(storageTable, FoodStorage(null, 'もやし', Unit.g, 200, 40, 'メモ', 1 , DateTime.now(), null).toMap());

    // 料理テーブル
    await db.execute('CREATE TABLE $dishTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $dishName TEXT, $isFavorite INTEGER, $colMemo TEXT, $colSort INTEGER, $colCreatedAt TEXT, $colDeletedAt TEXT)');
    await db.insert(dishTable, Dish(null, 'キャベツ焼', false, 'メモ', 1 , DateTime.now(), null).toMap());

    // 使用済　食材テーブル
    await db.execute('CREATE TABLE $usedFoodTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $dishId INTEGER, $foodStorageId INTEGER, $colFoodName TEXT, $colUnitKind TEXT, $colQuantity REAL, $colPrice REAL, $colMemo TEXT, $colSort INTEGER, $colCreatedAt TEXT, $colDeletedAt TEXT)');
    await db.insert(usedFoodTable, UsedFood(null, 1, 1, 'キャベツ', Unit.piece, 1, 100, 'メモ', 1 , DateTime.now(), null).toMap());

  }
//---------食糧庫 START---------------
  // 全て取得
  Future<List<FoodStorage>> getFoodStorage() async {
    final result = await database.query(storageTable, orderBy: '$colCreatedAt DESC');
    // debugPrint(result.toString());
    return result.map((Map<String, dynamic> food) => FoodStorage.fromMapObject(food)).toList();
  }

  /*
  * 【INSERT】 食糧庫 リストを全て登録
   */
  Future<void> insertStorage(List<FoodStorage> foodStorages) async {
    // await DatabaseHelper().insertStorage(card);
    database.transaction((txn) async {
      foodStorages.forEach((foodStorage) async {
        final storage = FoodStorage(
          null,
          foodStorage.foodName, //食品名前
          foodStorage.unitKind, //単位
          foodStorage.quantity, //数量
          foodStorage.price, //金額
          null,
          1,
          DateTime.now(),
          null
        );
        await txn.insert(storageTable, storage.toMap());
      });
    });
  }

  /*
  * 【INSERT】 使用した食糧 リストを全て登録
   */
  Future<void> insertUseFoods(List<FoodStorage> foodStorages,String dishName) async {
    // await DatabaseHelper().insertStorage(card);
    database.transaction((txn) async {
      // 料理名
      Dish dish = Dish(null, dishName, false, '', 1, DateTime.now(), null);
      int dishId = await txn.insert(usedFoodTable, dish.toMap());

      foodStorages.forEach((foodStorage) async {
        UsedFood usedFood = UsedFood(
          null,
          dishId, // 料理ID
          foodStorage.id, // 食糧庫ID
          foodStorage.foodName, //食品名前
          foodStorage.unitKind, //単位
          foodStorage.quantity, //数量
          foodStorage.price, //金額
          null,
          1,
          DateTime.now(),
          null
        );
        await txn.insert(usedFoodTable, usedFood.toMap());
      });
    });
  }

  /*
  * 【SELECT】 選択日の料理リストと金額一覧
   */
  Future<List> selectDayDishes(DateTime _date) async {
      String date = DateFormat('yyyy-MM-dd').format(_date);
      final result = await database.rawQuery(
      '''
        SELECT * FROM dishes
        LEFT OUTER JOIN 
        (
          SELECT SUM(price) AS sum_price, dish_id
          FROM used_foods
          GROUP BY dish_id
        ) AS used_foods
        ON dishes.id = used_foods.dish_id
        WHERE dishes.created_at LIKE '$date%'
      '''
      );
    return result;
  }

  Future<void> updateStorage(FoodStorage storage) async {
    database.transaction((txn) async {
      await txn.update(storageTable, storage.toMap(), where: '$colId = ?', whereArgs: [storage.id]);
      // await txn.update(listTable, list.toMap(), where: '$colId = ?', whereArgs: [list.id]);
    });
  }

  // 削除
  Future<void> deleteStorage(int id) async {
    database.transaction((txn) async {
      await txn.rawDelete('DELETE FROM $storageTable WHERE $colId = $id');
      // await txn.rawDelete('DELETE FROM $cardTable WHERE $colListId = $id');
    });
  }

//---------食糧庫 END---------------
  // リストの一枚目のカードデータを取得
  // Future<List> getCardListMap() async {
  //   // final results = await database.query(listTable, orderBy: '$colCreatedAt DESC');
  //   final result = await database.rawQuery(
  //   '''
  //     SELECT cards.id AS card_id, * FROM lists
  //     JOIN cards ON cards.$colListId = lists.$colId
  //     ORDER BY list_sort ASC, lists.$colCreatedAt DESC
  //   '''
  //   );
  //   // debugPrint(result.toString());
  //   return result;
  // }

  //ソートして並び替え //TODO: where tag_id = $tagId
  // Future<void> updateListSort(List ids) async{
  //   await database.rawQuery(
  //       '''
  //     UPDATE lists
  //     SET $colListSort = ROW_NUMBER()
  //     WHERE id IN ${ids.join(',')}
  //   ''');
  // }

  //リストに対応する　全て取得
//   Future<List<CreditCard>> getCardList(id) async {
// //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//     final result = await database.query(cardTable, where: '$colListId = ?',whereArgs: [id], orderBy: '$colCreatedAt DESC');
//     int count = result.length;
//     final cardList = <CreditCard>[];
//     for (var i = 0; i < count; i++) {
//       cardList.add(CreditCard.fromMapObject(result[i]));
//     }
//     return cardList;
//   }

  //IDを指定して１つだけ取得
  // Future<List<Object>> getCard(id) async {
  //   final result = await database.rawQuery('SELECT * FROM $cardTable WHERE id = ?', [id]);
  //   return result;
  // }

  //挿入　更新　削除
    // Insert Operation: Insert a Note object to database
    // Future<void> insertCard(CreditCard card,ListTable list) async {
    //   database.transaction((txn) async {
    //     final result =  await txn.insert(listTable, list.toMap());// debugPrint('インサート時：$result');
    //     var cardMap = card.toMap(); //IDをカードカードリストに反映
    //     cardMap['list_id'] = result;
    //     await await txn.insert(cardTable, cardMap);
    //   });
    // }

    // Future<void> updateCard(CreditCard card,ListTable list) async {
    //   database.transaction((txn) async {
    //     await txn.update(cardTable, card.toMap(), where: '$colId = ?', whereArgs: [card.id]);
    //     await txn.update(listTable, list.toMap(), where: '$colId = ?', whereArgs: [list.id]);
    //   });
    // }
}
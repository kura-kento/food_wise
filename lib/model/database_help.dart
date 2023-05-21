import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import '../enum/Unit.dart';
import 'Food.dart';
import 'FoodStorage.dart';
import 'FoodTable.dart';

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
  static String cardTable = 'cards';
  static String colListId = 'list_id';
  static String colFrontPath = 'frontPath';
  static String colBackPath = 'backPath';
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

    // //カードテーブル作成
    // await db.execute('CREATE TABLE $cardTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colListId INTEGER, $colFrontPath TEXT, $colBackPath TEXT, $colCardSort INTEGER, $colCreatedAt TEXT, $colDeletedAt TEXT)');
    // await db.insert(cardTable, CreditCard(1, null, null, 1 , DateTime.now(), null).toMap());
    //カテゴリー
  }
//---------食糧庫 START---------------
  // 全て取得
  Future<List<FoodStorage>> getFoodStorage() async {
    final result = await database.query(storageTable, orderBy: '$colCreatedAt DESC');
    debugPrint(result.toString());
    return result.map((Map<String, dynamic> food) => FoodStorage.fromMapObject(food)).toList();
  }


  /*
  * 【INSERT】 食糧庫 リストを全て登録
   */
  Future<void> insertStorage(List<Food> foods) async {
    // await DatabaseHelper().insertStorage(card);
    database.transaction((txn) async {
      foods.forEach((food) async {
        final storage = FoodStorage(
          null,
          food.foodName, //食品名前
          food.unitKind, //単位
          food.quantity, //数量
          food.price, //金額
          null,
          1,
          DateTime.now(),
          null
        );
        await txn.insert(storageTable, storage.toMap());
      });
      // final result =  await txn.insert(storageTable, storageList.toMap()); // debugPrint('インサート時：$result');
      // await txn.insert(storageTable, storage.toMap());
      // var cardMap = card.toMap(); //IDをカードカードリストに反映
      // cardMap['list_id'] = result;
      // await await txn.insert(cardTable, cardMap);
    });
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
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final String dbName = 'kashew.db';
  static final int dbVersion = 1;
  static Database? _database;
  static DatabaseHelper? _dbHelper;

  static DatabaseHelper get dbHelper {
    _dbHelper ??= DatabaseHelper();
    return _dbHelper!;
  }

  Future<Database> _initDb() async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
        path, version: dbVersion,
        onCreate: (db, version) async {
          final String tableCategory =
              "CREATE TABLE IF NOT EXISTS ${CategoryModel.tableCategories} ("
              "${CategoryModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${CategoryModel.colCategoryName} TEXT NOT NULL)";
          final String tableTopic =
              "CREATE TABLE IF NOT EXISTS ${TopicModel.tableTopics} ("
              "${TopicModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${TopicModel.colName} TEXT NOT NULL,"
              "${TopicModel.colDescription} TEXT,"
              "${TopicModel.colDateTime} INTEGER NOT NULL,"
              "${TopicModel.colCurrency} TEXT,"
              "${TopicModel.colIsSystem} INTEGER DEFAULT ${Constants.falsch})";
          final String tableExpense =
              "CREATE TABLE IF NOT EXISTS ${ExpenseModel.tableExpenses} ("
              "${ExpenseModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${ExpenseModel.colTitle} TEXT NOT NULL,"
              "${ExpenseModel.colAmount} REAL NOT NULL,"
              "${ExpenseModel.colDateTime} INTEGER NOT NULL,"
              "${ExpenseModel.colCategoryId} INTEGER,"
              "${ExpenseModel.colTopicId} INTEGER,"
              "${ExpenseModel.colNote} TEXT,"
              "FOREIGN KEY(${ExpenseModel.colCategoryId}) REFERENCES ${CategoryModel.tableCategories}(${CategoryModel.colId}),"
              "FOREIGN KEY(${ExpenseModel.colTopicId}) REFERENCES ${TopicModel.tableTopics}(${TopicModel.colId}))";

          await db.execute(tableCategory);
          await db.execute(tableTopic);
          await db.execute(tableExpense);
          await insertBatchCategories(db);
          await insertDefaultTopic(db);
        });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<void> insertBatchCategories(Database db) async {

    await db.insert(CategoryModel.tableCategories, CategoryModel(id: Constants.defaultCategoryId, categoryName: CategoryModel.catOthers).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catDining).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catDrinking).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catBeverage).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catClothes).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catGroceries).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catGifts).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catHealth).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catRepair).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catCharges).toMap());
    await db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catTransport).toMap());
  }

  Future<void> insertDefaultTopic(Database db) async {

    Map<String, dynamic> values = {
      TopicModel.colId: Constants.defaultTopicId,
      TopicModel.colName: Constants.defaultTopic,
      TopicModel.colDescription: "All general and uncategorized expenses.",
      TopicModel.colDateTime: DateTime.now().millisecondsSinceEpoch,
      TopicModel.colCurrency: CurrencyModel.xxx,
      TopicModel.colIsSystem: Constants.wahr,
    };
    await db.insert(TopicModel.tableTopics, values);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {

    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs, String? orderBy, int? limit}) async {

    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {

    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {

    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

}

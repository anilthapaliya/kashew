import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/topic_model.dart';
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
              "${CategoryModel.colCategoryName} TEXT NOT NULL )";
          final String tableTopic =
              "CREATE TABLE IF NOT EXISTS ${TopicModel.tableTopics} ("
              "${TopicModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${TopicModel.colName} TEXT NOT NULL,"
              "${TopicModel.colDescription} TEXT,"
              "${TopicModel.colDateTime} INTEGER NOT NULL,"
              "${TopicModel.colCurrency} TEXT NOT NULL)";
          final String tableExpense =
              "CREATE TABLE IF NOT EXISTS ${ExpenseModel.tableExpenses} ("
              "${ExpenseModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${ExpenseModel.colTitle} TEXT NOT NULL,"
              "${ExpenseModel.colAmount} REAL NOT NULL,"
              "${ExpenseModel.colDateTime} INTEGER NOT NULL,"
              "${ExpenseModel.colCategoryId} INTEGER,"
              "${ExpenseModel.colTopicId} INTEGER,"
              "${ExpenseModel.colNote} TEXT ,"
              "FOREIGN KEY(${ExpenseModel.colCategoryId}) REFERENCES ${CategoryModel.tableCategories}(${CategoryModel.colId}),"
              "FOREIGN KEY(${ExpenseModel.colTopicId}) REFERENCES ${TopicModel.tableTopics}(${TopicModel.colId}))";

          await db.execute(tableCategory);
          await db.execute(tableTopic);
          await db.execute(tableExpense);
          await insertBatchCategories(db);
        });
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<void> insertBatchCategories(Database db) async {

    insertCategory(CategoryModel(categoryName: CategoryModel.catDining));
    insertCategory(CategoryModel(categoryName: CategoryModel.catBeverage));
    insertCategory(CategoryModel(categoryName: CategoryModel.catClothes));
    insertCategory(CategoryModel(categoryName: CategoryModel.catGroceries));
    insertCategory(CategoryModel(categoryName: CategoryModel.catGifts));
    insertCategory(CategoryModel(categoryName: CategoryModel.catHealth));
    insertCategory(CategoryModel(categoryName: CategoryModel.catRepair));
    insertCategory(CategoryModel(categoryName: CategoryModel.catCharges));
    insertCategory(CategoryModel(categoryName: CategoryModel.catTransport));
    insertCategory(CategoryModel(categoryName: CategoryModel.catOthers));
  }

  Future<int> insertCategory(CategoryModel category) async {

    final db = await database;
    return await db.insert(CategoryModel.tableCategories, category.toMap());
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

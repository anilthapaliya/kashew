import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/settings_model.dart';
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
              "${TopicModel.colIsSystem} INTEGER DEFAULT ${Constants.falsch},"
              "${TopicModel.colLastUpdated} INTEGER NOT NULL)";
          final String tableExpense =
              "CREATE TABLE IF NOT EXISTS ${ExpenseModel.tableExpenses} ("
              "${ExpenseModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${ExpenseModel.colTitle} TEXT NOT NULL,"
              "${ExpenseModel.colAmount} REAL NOT NULL,"
              "${ExpenseModel.colDateTime} INTEGER NOT NULL,"
              "${ExpenseModel.colCategoryId} INTEGER,"
              "${ExpenseModel.colTopicId} INTEGER,"
              "${ExpenseModel.colNote} TEXT,"
              "${ExpenseModel.colCurrency} TEXT,"
              "FOREIGN KEY(${ExpenseModel.colCategoryId}) REFERENCES ${CategoryModel.tableCategories}(${CategoryModel.colId}),"
              "FOREIGN KEY(${ExpenseModel.colTopicId}) REFERENCES ${TopicModel.tableTopics}(${TopicModel.colId}))";

          final String tableSettings =
              "CREATE TABLE IF NOT EXISTS ${SettingsModel.tableSettings} ("
              "${SettingsModel.colKey} TEXT PRIMARY KEY,"
              "${SettingsModel.colValue} TEXT NOT NULL)";

          await db.execute(tableCategory);
          await db.execute(tableTopic);
          await db.execute(tableExpense);
          await db.execute(tableSettings);
          await insertBatchCategories(db);
          await insertDefaultTopic(db);
          await insertDefaultCurrency(db);
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
      TopicModel.colLastUpdated: DateTime.now().millisecondsSinceEpoch,
      TopicModel.colCurrency: CurrencyModel.npr,
      TopicModel.colIsSystem: Constants.wahr,
    };
    await db.insert(TopicModel.tableTopics, values);
  }

  Future<void> insertDefaultCurrency(Database db) async {

    Map<String, String> values = {
      SettingsModel.colKey: Constants.settingsCurrency,
      SettingsModel.colValue: CurrencyModel.npr,
    };
    await db.insert(SettingsModel.tableSettings, values);
  }

  Future<int> insert(String table, Map<String, dynamic> data, {ConflictAlgorithm? conflictAlgorithm}) async {

    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: conflictAlgorithm);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql) async {

    final db = await database;
    return await db.rawQuery(sql);
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

  Future<Map<int, double>> totalExpenseByTopic() async {

    final db = await database;
    final result = await db.rawQuery("SELECT ${ExpenseModel.colTopicId},"
        " SUM(${ExpenseModel.colAmount}) as ${Constants.dataTotal} FROM ${ExpenseModel.tableExpenses}"
        " GROUP BY ${ExpenseModel.colTopicId}");
    Map<int, double> totals = {};
    for (var row in result) {
      totals[row[ExpenseModel.colTopicId] as int] = (row[Constants.dataTotal] ?? 0) as double;
    }

    return totals;
  }

  Future<double> totalExpenseForTopic(int topicId) async {

    final db = await database;
    final result = await db
        .rawQuery("SELECT SUM(${ExpenseModel.colAmount}) AS ${Constants.dataTotal} FROM "
        "${ExpenseModel.tableExpenses} WHERE ${ExpenseModel.colTopicId} = $topicId");
    return (result.first[Constants.dataTotal] as double);
  }

  Future<double> totalExpenseOfTheMonth(int start, int end) async {

    final db = await database;
    final query = "SELECT SUM(${ExpenseModel.colAmount}) AS ${Constants.dataTotal} FROM "
        "${ExpenseModel.tableExpenses} WHERE ${ExpenseModel.colDateTime} >= ? AND ${ExpenseModel.colDateTime} < ?";
    final result = await db.rawQuery(query, [start, end]);
    return (result.first[Constants.dataTotal] ?? 0.0) as double;
  }

  Future<Map<String, dynamic>?> getTopCategory(int start, int end) async {

    final db = await database;
    final query = "SELECT ${ExpenseModel.colCategoryId}, c.${CategoryModel.colCategoryName} AS category, "
        "SUM(${ExpenseModel.colAmount}) AS ${Constants.dataTotal} "
        "FROM ${ExpenseModel.tableExpenses} e JOIN ${CategoryModel.tableCategories} c "
        "ON e.${ExpenseModel.colCategoryId} = c.${CategoryModel.colId} "
        "WHERE ${ExpenseModel.colDateTime} >= ? AND "
        "${ExpenseModel.colDateTime} < ? GROUP BY ${ExpenseModel.colTopicId} ORDER BY ${Constants.dataTotal} DESC LIMIT 1";
    final result = await db.rawQuery(query, [start, end]);
    if (result.isEmpty) return null;

    Map<String, dynamic> response = {
      ExpenseModel.colCategoryId: result.first[ExpenseModel.colCategoryId],
      Constants.dataTotal: result.first[Constants.dataTotal],
      Constants.dataCategory: result.first[Constants.dataCategory]
    };

    return response;
  }

}

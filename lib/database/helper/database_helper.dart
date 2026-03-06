import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static final String dbName = 'kashew.db';
  static final int dbVersion = 1;
  static Database? _database;

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
              "${TopicModel.colDateTime} INTEGER NOT NULL )";
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
          await insertInitialCategories(db);
        });
  }

  Future<void> insertInitialCategories(Database db) async {

    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catDining).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catDrinking).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catBeverage).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catClothes).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catGroceries).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catGifts).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catHealth).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catRepair).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catCharges).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catTransport).toMap());
    db.insert(CategoryModel.tableCategories, CategoryModel(categoryName: CategoryModel.catOthers).toMap());
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<int> insertCategory(CategoryModel category) async {

    final db = await database;
    return await db.insert(CategoryModel.tableCategories, category.toMap());
  }

  Future<List<CategoryModel>> getCategories() async {

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CategoryModel.tableCategories);
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(CategoryModel category) async {

    final db = await database;
    return await db.update(
      CategoryModel.tableCategories,
      category.toMap(),
      where: '${CategoryModel.colId} = ?',
      whereArgs: [category.id]
    );
  }

  Future<int> deleteCategory(int id) async {

    final db = await database;
    return await db.delete(
      CategoryModel.tableCategories,
      where: '${CategoryModel.colId} = ?',
      whereArgs: [id]
    );
  }

  Future<int> insertTopic(TopicModel topic) async {

    final db = await database;
    return await db.insert(TopicModel.tableTopics, topic.toMap());
  }

  Future<List<TopicModel>> getTopics() async {

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(TopicModel.tableTopics);
    return List.generate(maps.length, (i) {
      return TopicModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTopic(TopicModel topic) async {

    final db = await database;
    return await db.update(
      TopicModel.tableTopics,
      topic.toMap(),
      where: '${TopicModel.colId} = ?',
      whereArgs: [topic.id]
    );
  }

  Future<int> deleteTopic(int id) async {

    final db = await database;
    return await db.delete(
      TopicModel.tableTopics,
      where: '${TopicModel.colId} = ?',
      whereArgs: [id]
    );
  }

  Future<int> insertExpense(ExpenseModel expense) async {

    final db = await database;
    return await db.insert(ExpenseModel.tableExpenses, expense.toMap());
  }

  Future<List<ExpenseModel>> getExpenses() async {

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ExpenseModel.tableExpenses);
    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  Future<int> updateExpense(ExpenseModel expense) async {

    final db = await database;
    return await db.update(
      ExpenseModel.tableExpenses,
      expense.toMap(),
      where: '${ExpenseModel.colId} = ?',
      whereArgs: [expense.id]
    );
  }

  Future<int> deleteExpense(int id) async {

    final db = await database;
    return await db.delete(
      ExpenseModel.tableExpenses,
      where: '${ExpenseModel.colId} = ?',
      whereArgs: [id]
    );
  }

}

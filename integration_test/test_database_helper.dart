import 'package:kashew/models/settings_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestDatabaseHelper {

  static final String dbName = 'kashew.db';
  static Database? _database;
  static TestDatabaseHelper? _dbHelper;

  static TestDatabaseHelper get dbHelper {
    _dbHelper ??= TestDatabaseHelper();
    return _dbHelper!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1);
  }

  Future<int> insert(String table, Map<String, dynamic> data, {ConflictAlgorithm? conflictAlgorithm}) async {

    final db = await database;
    return await db.insert(table, data, conflictAlgorithm: conflictAlgorithm);
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {

    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> setSetting(String key, String value) async {

    await dbHelper.insert(SettingsModel.tableSettings, {
      SettingsModel.colKey: key,
      SettingsModel.colValue: value
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void resetDatabase(bool value) async {

    if (value) {
      await delete(SettingsModel.tableSettings, "${SettingsModel.colKey} = ?", [Constants.settingsFirstRun]);
    }
    else {
      await setSetting(Constants.settingsLanguage, 'en');
      await setSetting(Constants.settingsCurrency, 'USD');
      await setSetting(Constants.settingsFirstRun, "YES");
    }
  }

}
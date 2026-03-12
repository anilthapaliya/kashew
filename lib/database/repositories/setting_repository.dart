import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/settings_model.dart';
import 'package:sqflite/sqflite.dart';

class SettingsRepository {

  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> setSetting(String key, String value) async {

    await dbHelper.insert(SettingsModel.tableSettings, {
      SettingsModel.colKey: key,
      SettingsModel.colValue: value
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getSetting(String key) async {

    final result = await dbHelper.query(SettingsModel.tableSettings, where: "${SettingsModel.colKey} = ?", whereArgs: [key]);
    if (result.isNotEmpty) {
      return result.first[SettingsModel.colValue];
    }

    return null;
  }

}
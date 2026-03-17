import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/database/repositories/setting_repository.dart';

class TestSettingsRepository implements SettingsRepository {

  String? value;

  TestSettingsRepository({ this.value });

  @override
  // TODO: implement dbHelper
  DatabaseHelper get dbHelper => throw UnimplementedError();

  @override
  Future<String?> getSetting(String key) async {
    return value;
  }

  @override
  Future<void> setSetting(String key, String value) async {
    //
  }

}
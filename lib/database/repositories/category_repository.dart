import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/category_model.dart';

class CategoryRepository {

  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<List<CategoryModel>> getCategories() async {

    final List<Map<String, dynamic>> maps = await dbHelper.query(CategoryModel.tableCategories);
    return List.generate(maps.length, (i) {
      return CategoryModel.fromMap(maps[i]);
    });
  }

}
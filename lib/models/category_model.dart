class CategoryModel {

  static final String tableCategories = "categories";
  static final String colId = "id";
  static final String colCategoryName = "category_name";
  static final String colIcon = "icon";

  final int? id;
  final String categoryName;
  final String? icon;

  CategoryModel({ this.id, required this.categoryName, this.icon });

  Map<String, dynamic> toMap() {
    return {
      //colId : id,
      colCategoryName : categoryName,
      colIcon : icon
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
        id: map[colId],
        categoryName: map[colCategoryName],
        icon: map[colIcon]
    );
  }

}

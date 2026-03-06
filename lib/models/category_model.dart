import 'package:flutter/material.dart';

class CategoryModel {

  static final String tableCategories = "categories";
  static final String colId = "id";
  static final String colCategoryName = "category_name";
  static final String colCategoryNote = "category_note";

  final int? id;
  final String categoryName;
  final String? categoryNote;

  CategoryModel({ this.id, required this.categoryName, this.categoryNote });

  Map<String, dynamic> toMap() {
    return {
      //colId : id,
      colCategoryName: categoryName,
      colCategoryNote: colCategoryNote,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[colId],
      categoryName: map[colCategoryName],
      categoryNote: map[colCategoryNote],
    );
  }

  final Map<String, IconData> iconMap = {
    catDining: Icons.fastfood_rounded,
    catDrinking: Icons.wine_bar_rounded,
    catBeverage: Icons.coffee_rounded,
    catClothes: Icons.shopping_bag_rounded,
    catGroceries: Icons.shopping_cart_rounded,
    catGifts: Icons.card_giftcard_rounded,
    catHealth: Icons.health_and_safety_rounded,
    catRepair: Icons.handyman_rounded,
    catCharges: Icons.money,
    catTransport: Icons.directions_bus,
    catOthers: Icons.monetization_on_rounded,
  };

  IconData get icon => iconMap[categoryName] ?? Icons.help;

  static final String catDining = "Dining";
  static final String catDrinking = "Drinking";
  static final String catBeverage = "Beverage";
  static final String catClothes = "Clothes";
  static final String catGroceries = "Groceries";
  static final String catGifts = "Gifts";
  static final String catHealth = "Health";
  static final String catRepair = "Repair and Maintenance";
  static final String catCharges = "Charges and Fees";
  static final String catTransport = "Transport";
  static final String catOthers = "Others";

}

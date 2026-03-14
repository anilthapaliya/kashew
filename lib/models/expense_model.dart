class ExpenseModel {

  static final String tableExpenses = "expenses";
  static final String colId = "id";
  static final String colTitle = "title";
  static final String colAmount = "amount";
  static final String colDateTime = "date_time";
  static final String colCategoryId = "category_id";
  static final String colTopicId = "topic_id";
  static final String colNote = "note";
  static final String colCurrency = "currency";

  int? id;
  String title;
  double amount;
  int dbDateTime;
  int? categoryId;
  int? topicId;
  String? note;
  String? currency;
  final DateTime? readableDateTime;

  ExpenseModel({ this.id, required this.title, required this.amount,
    required this.dbDateTime, required this.categoryId, required this.topicId,
    this.note, this.readableDateTime, this.currency });

  Map<String, dynamic> toMap() {
    return {
      //colId: id,
      colTitle: title,
      colAmount: amount,
      colDateTime: dbDateTime,
      colCategoryId: categoryId,
      colTopicId: topicId,
      colNote: note,
      colCurrency: currency
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        id: map[colId],
        title: map[colTitle],
        amount: map[colAmount],
        dbDateTime: map[colDateTime],
        readableDateTime: DateTime.fromMillisecondsSinceEpoch(map[colDateTime]),
        categoryId: map[colCategoryId],
        topicId: map[colTopicId],
        note: map[colNote],
        currency: map[colCurrency]
    );
  }

}

import 'package:kashew/utils/common_utils.dart';

class TopicModel {

  static final String tableTopics = "topics";
  static final String colId = "id";
  static final String colName = "topic_name";
  static final String colDescription = "topic_description";
  static final String colCurrency = "currency";
  static final String colDateTime = "date_time";

  int? id;
  String name;
  String? description;
  String currency;
  int dbDateTime;

  TopicModel({ this.id, required this.name, this.description, required this.currency,
    required this.dbDateTime });

  Map<String, dynamic> toMap() {
    return {
      //colId: id,
      colName: name,
      colDescription: description,
      colCurrency: currency,
      colDateTime: dbDateTime
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
        id: map[colId],
        name: map[colName],
        description: map[colDescription],
        currency: map[colCurrency],
        dbDateTime: map[colDateTime],
    );
  }

  String get readableDateTime => CommonUtils.getReadableDateFromMs(dbDateTime);

}

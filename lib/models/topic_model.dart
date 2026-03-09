import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';

class TopicModel {

  static final String tableTopics = "topics";
  static final String colId = "id";
  static final String colName = "topic_name";
  static final String colDescription = "topic_description";
  static final String colCurrency = "currency";
  static final String colDateTime = "date_time";
  static final String colIsSystem = "is_system";

  int? id;
  String name;
  String? description;
  String? currency;
  int dbDateTime;
  int? isSystem;

  TopicModel({ this.id, required this.name, this.description,
    this.currency, required this.dbDateTime, this.isSystem = 0 });

  Map<String, dynamic> toMap() {
    return {
      //colId: id,
      colName: name,
      colDescription: description,
      colCurrency: currency,
      colDateTime: dbDateTime,
      colIsSystem: isSystem
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
        id: map[colId],
        name: map[colName],
        description: map[colDescription],
        currency: map[colCurrency],
        dbDateTime: map[colDateTime],
        isSystem: map[colIsSystem],
    );
  }

  String get readableDateTime => CommonUtils.getReadableDateFromMs(dbDateTime);

}

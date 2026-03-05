class TopicModel {

  static final String tableTopics = "topics";
  static final String colId = "id";
  static final String colName = "topic_name";
  static final String colDescription = "topic_description";
  static final String colDateTime = "date_time";

  final int? id;
  final String name;
  final String? description;
  final int dbDateTime;
  final DateTime? readableDateTime;

  TopicModel({ this.id, required this.name, this.description, required this.dbDateTime,
    this.readableDateTime });

  Map<String, dynamic> toMap() {
    return {
      //colId: id,
      colName: name,
      colDescription: description,
      colDateTime: dbDateTime
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
        id: map[colId],
        name: map[colName],
        description: map[colDescription],
        dbDateTime: map[colDateTime],
        readableDateTime: DateTime.fromMillisecondsSinceEpoch(map[colDateTime])
    );
  }

}

import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/topic_model.dart';

class TopicRepository {

  final DatabaseHelper dbHelper = DatabaseHelper.dbHelper;

  Future<int> insertTopic(TopicModel topic) async {

    return await dbHelper.insert(TopicModel.tableTopics, topic.toMap());
  }

  Future<List<TopicModel>> getLatestTopics() async {

    final List<Map<String, dynamic>> maps = await dbHelper
        .query(TopicModel.tableTopics, orderBy: "${TopicModel.colLastUpdated} DESC", limit: 10);
    return List.generate(maps.length, (i) {
      return TopicModel.fromMap(maps[i]);
    });
  }

  Future<List<TopicModel>> getAllTopics() async {

    final List<Map<String, dynamic>> maps = await dbHelper.query(TopicModel.tableTopics, orderBy: "${TopicModel.colLastUpdated} DESC");
    return List.generate(maps.length, (i) {
      return TopicModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTopic(TopicModel topic) async {

    return await dbHelper.update(TopicModel.tableTopics, topic.toMap(),
        '${TopicModel.colId} = ?', [topic.id]);
  }

  Future<int> deleteTopic(int topicId) async {

    return await dbHelper.delete(TopicModel.tableTopics,
        '${TopicModel.colId} = ?', [topicId]);
  }

}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kashew/database/helper/database_helper.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';

class TopicViewModel extends ChangeNotifier {

  DatabaseHelper dbHelper = DatabaseHelper();
  List<TopicModel>? topics;
  bool isTopicLoading = false;
  bool isTopicAdding = false;
  bool isError = false;
  String? errorMessage = "";

  Future<void> loadTopics() async {

    if (topics != null) return;

    isTopicLoading = true;
    topics ??= await dbHelper.getTopics();
    notifyListeners();
    isTopicLoading = false;
  }

  Future<int> addTopic(TopicModel model) async {

    if (model.name.isEmpty || model.name.length < 3) {
      isError = true;
      errorMessage = Constants.errTopicName;
      notifyListeners();
      return Constants.failure;
    }

    isTopicAdding = true;
    isError = false;
    errorMessage = null;
    notifyListeners();

    model.name = CommonUtils.titleCase(model.name);
    await Future.delayed(const Duration(seconds: 2));
    //final id = await dbHelper.insertTopic(model);
    final id = 0;

    if (id > 0) {
      topics!.add(model);
      isTopicAdding = false;
      notifyListeners();
      return Constants.success;
    }

    isTopicAdding = false;
    notifyListeners();
    return Constants.failure;
  }

}
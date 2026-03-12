import 'package:flutter/material.dart';
import 'package:kashew/database/repositories/topic_repository.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';

class TopicViewModel extends ChangeNotifier {

  TopicRepository topicRepo = TopicRepository();
  List<TopicModel>? topics;
  TopicModel? _selectedTopic;
  bool isTopicLoading = false;
  bool isTopicAdding = false;
  bool isError = false;
  String? errorMessage = "";

  TopicModel? get selectedTopic => _selectedTopic;

  void setSelectedTopic(TopicModel? model, {bool notify = false}) {

    _selectedTopic = model;
    if (notify) notifyListeners();
  }

  Future<void> loadTopics() async {

    isTopicLoading = true;
    topics = await topicRepo.getLatestTopics();
    notifyListeners();
    isTopicLoading = false;
  }

  Future<void> updateLastUpdated(TopicModel model) async {

    model.lastUpdated = DateTime.now().millisecondsSinceEpoch;
    await topicRepo.updateTopic(model);
    await loadTopics();
    notifyListeners();
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
    //await Future.delayed(const Duration(seconds: 1)); // Remove delay later
    final id = await topicRepo.insertTopic(model);

    if (id > 0) {
      model.id = id;
      topics!.add(model);
      topics!.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
      isTopicAdding = false;
      notifyListeners();
      return Constants.success;
    }

    isTopicAdding = false;
    notifyListeners();
    return Constants.failure;
  }

  Future<int> saveTopic(TopicModel model) async {

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
    final count = await topicRepo.updateTopic(model);

    if (count > 0) {
      int index = topics!.indexWhere((i) => i.id == model.id);
      if (index != -1) topics![index] = model;
      isTopicAdding = false;
      notifyListeners();
      return Constants.success;
    }

    isTopicAdding = false;
    notifyListeners();
    return Constants.failure;
  }

  Future<int> deleteTopic(int id) async {

    final count = await topicRepo.deleteTopic(id);

    if (count > 0) {
      int index = topics!.indexWhere((i) => i.id == id);
      if (index != -1) topics!.removeAt(index);
      notifyListeners();
      return Constants.success;
    }

    return Constants.failure;
  }

}
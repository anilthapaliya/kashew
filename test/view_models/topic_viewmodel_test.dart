import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/utils/constants.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/database/repositories/topic_repository.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/l10n/app_localizations.dart';
@GenerateMocks([TopicRepository, TopicModel, AppLocalizations])
import 'topic_viewmodel_test.mocks.dart';

void main() {

  late TopicViewModel viewModel;
  late MockTopicRepository mockRepo;
  bool notified = false;

  setUp(() {
    mockRepo = MockTopicRepository();
    viewModel = TopicViewModel(topicRepo: mockRepo);
    viewModel.addListener(() {
      notified = true;
    });
  });

  group("Topic Activities", () {

    group("Loading topics:", () {

      test("should load topics", () async {
        final topics = [TopicModel(name: "One", dbDateTime: DateTime.now().millisecondsSinceEpoch,
            lastUpdated: DateTime.now().millisecondsSinceEpoch, id: 1),
          TopicModel(name: "Two", dbDateTime: DateTime.now().millisecondsSinceEpoch,
              lastUpdated: DateTime.now().millisecondsSinceEpoch, id: 2)];
        when(mockRepo.getLatestTopics()).thenAnswer((_) async => topics);
        when(mockRepo.getTotalExpensesTopicWise()).thenAnswer((_) async =>
        {
          1: 100,
          2: 200
        });
        await viewModel.loadTopics();
        expect(viewModel.topics, isA<List<TopicModel>>());
        expect(notified, true);
      });
    });

    group("Adding a topic:", () {

      test("should add a topic and return success.", () async {
        final model = TopicModel(name: "One", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        viewModel.topics = [];
        when(mockRepo.insertTopic(model)).thenAnswer((_) async => 1);
        final lang = MockAppLocalizations();
        int result = await viewModel.addTopic(lang, model);
        expect(result, Constants.success);
        expect(notified, true);
      });

      test("should not add a topic given empty name and return failure.", () async {
        final model = TopicModel(name: "", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        int result = await viewModel.addTopic(lang, model);
        expect(result, Constants.failure);
        expect(notified, true);
      });

      test("should not add a topic given short name and return failure.", () async {
        final model = TopicModel(name: "xx", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        int result = await viewModel.addTopic(lang, model);
        expect(result, Constants.failure);
        expect(notified, true);
      });

      test("should not add a topic given add to database failed and return failure.", () async {
        final model = TopicModel(name: "xxx", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        when(mockRepo.insertTopic(model)).thenAnswer((_) async => -1);
        int result = await viewModel.addTopic(lang, model);
        expect(result, Constants.failure);
        expect(notified, true);
      });
    });

    group("Updating a topic:", () {

      test("should update a topic and return success.", () async {
        viewModel.topics = [];
        final model = TopicModel(name: "xxx", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        when(mockRepo.updateTopic(model)).thenAnswer((_) async => 1);
        int result = await viewModel.saveTopic(lang, model);
        expect(result, Constants.success);
        expect(notified, true);
      });

      test("should not update topic given invalid name and return failure.", () async {
        viewModel.topics = [];
        final model = TopicModel(name: "", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        when(mockRepo.updateTopic(model)).thenAnswer((_) async => 1);
        int result = await viewModel.saveTopic(lang, model);
        expect(result, Constants.failure);
        expect(notified, true);
      });

      test("should not update topic given database failure and return failure.", () async {
        viewModel.topics = [];
        final model = TopicModel(name: "Xxx", dbDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch);
        final lang = MockAppLocalizations();
        when(lang.errTopicName).thenReturn("some-error");
        when(mockRepo.updateTopic(model)).thenAnswer((_) async => -1);
        int result = await viewModel.saveTopic(lang, model);
        expect(result, Constants.failure);
        expect(notified, true);
      });
    });

    group("Deleting a topic:", () {

      test("should delete a topic.", () async {
        viewModel.topics = [];
        when(mockRepo.deleteTopic(any)).thenAnswer((_) async => 1);
        int result = await viewModel.deleteTopic(1);
        expect(result, Constants.success);
        expect(notified, true);
      });

      test("should not delete a topic.", () async {
        viewModel.topics = [];
        when(mockRepo.deleteTopic(any)).thenAnswer((_) async => 0);
        int result = await viewModel.deleteTopic(1);
        expect(result, Constants.failure);
        expect(notified, false);
      });
    });
  });

}
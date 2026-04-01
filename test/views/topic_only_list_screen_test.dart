import 'package:flutter/material.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/views/topic_only_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kashew/utils/constants.dart';
import 'topic_only_list_screen_test.mocks.dart';
@GenerateMocks([TopicViewModel])

void main() {

  late MockTopicViewModel mockTopicVM;

  setUp(() {
    mockTopicVM = MockTopicViewModel();
    List<TopicModel> topics = [];
    for (int i = 1; i <= 15; i++) {
      int time = DateTime.now().millisecondsSinceEpoch;
      topics.add(TopicModel(name: "Topic$i", dbDateTime: time, lastUpdated: time));
    }
    when(mockTopicVM.topics).thenReturn(topics);
  });

  testWidgets("Topic List Screen UI", (tester) async {

    await tester.pumpWidget(
        MultiProvider(providers: [
          ChangeNotifierProvider<TopicViewModel>.value(value: mockTopicVM)
        ], child: MaterialApp(
                routes: {
                  Constants.home : (_) => const Scaffold(body: Text("Home"))
                },
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('en'),
                home: MediaQuery(data: const MediaQueryData(size: Size(1080, 1920)),
                    child: Builder(builder: (context) {
                      R.init(context);
                      return const TopicListScreen();
                    }))
            ))
    );

    // Check item visibility
    expect(find.byKey(const Key("topicsLabel")), findsOneWidget);
    final listFinder = find.byKey(const Key("topic-list"));
    expect(listFinder, findsOneWidget);

    // Check for items
    expect(find.text("Topic1"), findsOneWidget);

    // Check scroll
    final item = find.byKey(const Key("topic-Topic10"));
    await tester.scrollUntilVisible(item, 300);
    expect(item, findsOneWidget);
    await tester.tap(item);
    await tester.pumpAndSettle();
    expect(find.text("Topic10"), findsNothing);

  });

}

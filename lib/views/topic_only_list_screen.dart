import 'package:flutter/material.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';

class TopicListScreen extends StatelessWidget {

  const TopicListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.lang.lblAppBarTopicList, overflow: TextOverflow.fade,
            textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
      ),
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: HexColor.fromHex(Constants.warmWhiteColor)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                child: Text(
                  context.lang.lblTopics,
                  key: const Key('topicsLabel'),
                  style: TextStyle(
                    fontFamily: Constants.fontBody, fontSize: R.sp(14),
                    fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor)),
                ),
              ),

              SizedBox(height: R.h(10)),

              Expanded(
                child: Consumer<TopicViewModel>(
                  builder: (context, vm, _) {
                    final topics = vm.topics ?? [];

                    return Card(
                      elevation: 0,
                      color: HexColor.fromHex(Constants.pureWhiteColor),
                      child: ListView.separated(
                        key: const Key('topic-list'),
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          final topic = topics[index];
                          return TopicItem(
                            topic: topic,
                            onTap: () => Navigator.pop(context, topic),
                          );
                        },
                        separatorBuilder: (_, _) => Divider(
                          height: 1, indent: R.w(20), endIndent: R.w(20),
                          color: HexColor.fromHex(Constants.dividerColor)),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class TopicItem extends StatelessWidget {

  final TopicModel topic;
  final VoidCallback onTap;

  const TopicItem({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      key: Key('topic-${topic.name}'),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: R.h(15),
          horizontal: R.w(20),
        ),
        child: Text(
          topic.name,
          key: Key('topicText_${topic.name}'),
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontFamily: Constants.fontBody,
            fontSize: R.sp(14),
            color: HexColor.fromHex(Constants.darkBgColor),
          ),
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(Constants.lblAppBarTopicList, overflow: TextOverflow.fade,
              textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                  fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
        ),
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
        decoration: BoxDecoration(
          color: HexColor.fromHex(Constants.warmWhiteColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: R.w(20)),
              child: Text(Constants.lblTopics, overflow: TextOverflow.fade,
                  textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                      fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
            ),
            SizedBox(height: R.h(10)),
            Consumer<TopicViewModel>(
                builder: (context, topicViewModel, child) {
                  return Card(
                    elevation: 0,
                    color: HexColor.fromHex(Constants.pureWhiteColor),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount: topicViewModel.topics!.length,
                              itemBuilder: (context, index) {
                                return singleTopic(topicViewModel.topics![index]);
                                },
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, indent: R.w(20), endIndent: R.w(20), color: HexColor.fromHex(Constants.dividerColor))),
                        ]),
                    );
                }),
          ],
        ),
      ),
    );
  }

  Widget singleTopic(TopicModel topic) {

    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(20)),
        child: Text(topic.name, overflow: TextOverflow.fade,
            textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';
import 'package:provider/provider.dart';

class TopicsWidget extends StatefulWidget {
  const TopicsWidget({super.key});

  @override
  State<TopicsWidget> createState() => _TopicsWidgetState();
}

class _TopicsWidgetState extends State<TopicsWidget> {

  TopicViewModel? topicViewModel;

  @override
  void initState() {

    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      topicViewModel = context.read<TopicViewModel>();
      topicViewModel!.loadTopics();
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
        child: Consumer<TopicViewModel>(
          builder: (context, topicViewModel, child) {

            return Row(
                children: [
                  addTopicCard(),
                  ... (topicViewModel.isTopicLoading) ? [const Center(child: CircularProgressIndicator())]:
                  (topicViewModel.topics == null || topicViewModel.topics!.isEmpty) ?
                  [noTopicFound()] :
                  List.generate(topicViewModel.topics!.length, (index) => topicCard(topicViewModel.topics![index])),
                ]);
          },
        ),
      ),
    );
  }

  Widget addTopicCard() {

    return Card(
      margin: EdgeInsets.only(right: R.w(10)),
      elevation: 0,
      color: HexColor.fromHex(Constants.warmWhiteColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(17)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => showAddTopicPopup(context),
              child: Container(
                width: R.w(30), height: R.h(30),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: HexColor.fromHex(Constants.lightGrayColor)),
                child: Icon(Icons.add, color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topicCard(TopicModel model) {

    return InkWell(
      onTap: () => Navigator.pushNamed(context, Constants.topicDetails, arguments: model),
      child: SizedBox(
        width: R.w(150),
        height: R.h(150),
        child: Card(
          margin: EdgeInsets.only(right: R.w(20)),
          elevation: 1,
          color: HexColor.fromHex(Constants.pureWhiteColor),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(17)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: R.w(30), height: R.h(30),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: HexColor.fromHex(Constants.lightGrayColor)),
                  child: Icon(Icons.flight, color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
                ),
                SizedBox(height: R.h(10)),
                Text(model.name, overflow: TextOverflow.fade,
                  style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold),),
                Text(CommonUtils.getReadableDateFromMs(model.dbDateTime), style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor))),
                SizedBox(height: R.h(10)),
                Text('\$0', style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(10), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noTopicFound() {

    return Text(Constants.lblNoTopics,
        style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12),
            color: HexColor.fromHex(Constants.textSecondaryColor)));
  }

  void showAddTopicPopup(BuildContext context) async {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddTopicWidget());
  }

}

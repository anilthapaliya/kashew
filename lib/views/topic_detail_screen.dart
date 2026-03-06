import 'package:flutter/material.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {

  @override
  Widget build(BuildContext context) {

    final TopicModel topicModel =
    ModalRoute.of(context)!.settings.arguments as TopicModel;

    return Scaffold(
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(topicModel.name, overflow: TextOverflow.fade,
                textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
            Text(topicModel.readableDateTime, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor))),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => showTopicOptions(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Top Summary Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w((15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Constants.lblTotalExpense.toUpperCase(),
                    style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.w500)),
                Text('\$9867.4',
                    style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(25), fontWeight: FontWeight.bold))
              ],
            ),
          ),

          // Topics Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Constants.lblExpenses, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                //Text(Constants.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showAddExpensePopup(context),
          shape: const CircleBorder(),
          backgroundColor: HexColor.fromHex(Constants.primaryColor),
          child: Icon(Icons.add, color: HexColor.fromHex(Constants.warmWhiteColor))),
    );
  }

  void showAddExpensePopup(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddExpenseWidget());
  }

  void showTopicOptions(BuildContext context) {

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: R.h(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(Constants.menuEditTopic,
                      style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))),
                  onTap: () {
                    Navigator.pop(context);
                    //editTopic();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: Text(
                    Constants.menuDeleteTopic,
                    style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15), color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showDeleteDialog(context);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteDialog(BuildContext context) async {

    final bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Topic", style: TextStyle(fontFamily: Constants.fontTitle, fontWeight: FontWeight.bold, fontSize: R.sp(18))),
          content: Text(
              "Are you sure you want to delete this topic?\n"
                  "All related expenses will also be removed.",
              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Delete",
                style: TextStyle(fontFamily: Constants.fontBody, fontWeight: FontWeight.bold, fontSize: R.sp(15), color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      //deleteTopic();
    }
  }

}

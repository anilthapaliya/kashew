import 'package:flutter/material.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';
import 'package:provider/provider.dart';

class TopicDetailScreen extends StatefulWidget {
  const TopicDetailScreen({super.key});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {

  late TopicModel topicModel;
  TopicViewModel? topicViewModel;
  ExpenseViewModel? expenseViewModel;
  bool isReturnedFromUpdate = false;
  bool _expensesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    expenseViewModel = context.read<ExpenseViewModel>();
    topicViewModel = context.read<TopicViewModel>();

    if (!isReturnedFromUpdate) {
      topicModel = ModalRoute
          .of(context)!.settings.arguments as TopicModel;
    }

    if (!_expensesLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        expenseViewModel!.loadExpenses(topicModel.id!);
        expenseViewModel!.setCurrentTopicId(topicModel.id!);
        _expensesLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

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
            onPressed: () => showTopicOptions(context, topicModel),
          ),
        ],
      ),
      body: Consumer2<TopicViewModel, ExpenseViewModel>(
          builder: (context, topicViewModel, expenseViewModel, child) {

            return Column(
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

                // Expenses Section
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
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
                      child: Column(
                        children: [
                          ... (expenseViewModel.isExpenseLoading) ? [const Center(child: CircularProgressIndicator())]:
                          (expenseViewModel.expenses == null || expenseViewModel.expenses!.isEmpty) ?
                          [noExpenseFound()] :
                          List.generate(expenseViewModel.expenses!.length, (index) => expenseCard(expenseViewModel.expenses![index])).reversed,
                        ]
                      ),
                    ),
                  ),
                ),

              ],
            );
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showAddExpensePopup(context),
          shape: const CircleBorder(),
          backgroundColor: HexColor.fromHex(Constants.primaryColor),
          child: Icon(Icons.add, color: HexColor.fromHex(Constants.warmWhiteColor))),
    );
  }

  Widget expenseCard(ExpenseModel expense) {

    return Card(
      margin: EdgeInsets.only(bottom: R.w(10)),
      elevation: 1,
      color: HexColor.fromHex(Constants.pureWhiteColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(Constants.stdMargin)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: R.w(10)),
              width: R.w(30), height: R.h(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: HexColor.fromHex(Constants.warmWhiteColor)),
              child: Icon(Icons.emoji_food_beverage, color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title, style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(13), fontWeight: FontWeight.bold),),
                Text(CommonUtils.getReadableDateFromMs(expense.dbDateTime), style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor))),
              ],
            ),
            Expanded(child: Container()),
            Text(expense.amount.toString(), style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: Colors.red)),

          ],
        ),
      ),
    );
  }

  Widget noExpenseFound() {

    return Center(
      child: Text(Constants.lblNoExpenses,
          style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12),
              color: HexColor.fromHex(Constants.textSecondaryColor))),
    );
  }

  void showAddExpensePopup(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddExpenseWidget(topicModel: topicModel));
  }

  void showTopicOptions(BuildContext context, TopicModel model) {

    final parentContext = context;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: R.h(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.edit, color: (model.isSystem == Constants.wahr) ? HexColor.fromHex(Constants.textSecondaryColor) : HexColor.fromHex(Constants.darkBgColor)),
                  title: Text(Constants.menuEditTopic,
                      style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15), color: (model.isSystem == Constants.wahr) ? HexColor.fromHex(Constants.textSecondaryColor) : HexColor.fromHex(Constants.darkBgColor))),
                  enabled: (model.isSystem == Constants.wahr) ? false : true,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    showEditTopicPopup(sheetContext, model);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: (model.isSystem == Constants.wahr) ? HexColor.fromHex(Constants.textSecondaryColor) : Colors.red),
                  title: Text(
                    Constants.menuDeleteTopic,
                    style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15),
                        color: (model.isSystem == Constants.wahr) ? HexColor.fromHex(Constants.textSecondaryColor) :  Colors.red),
                  ),
                  enabled: (model.isSystem == Constants.wahr) ? false : true,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final result = await showDeleteDialog(parentContext);
                    if (result != null && result && mounted) {
                      Navigator.pop(parentContext);
                    }
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

  Future<bool?> showDeleteDialog(BuildContext context) async {

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Constants.dialogDeleteTitle, style: TextStyle(fontFamily: Constants.fontTitle, fontWeight: FontWeight.bold, fontSize: R.sp(18))),
          content: Text(Constants.dialogDeleteMessage,
              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Constants.dialogCancel, style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                Constants.dialogDeleteConfirm,
                style: TextStyle(fontFamily: Constants.fontBody, fontWeight: FontWeight.bold, fontSize: R.sp(15), color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed && topicViewModel != null) {
        topicViewModel!.deleteTopic(topicModel.id!);
    }
    return confirmed;
  }

  void showEditTopicPopup(BuildContext context, TopicModel model) async {

    final updatedTopicModel = (await showModalBottomSheet<TopicModel>(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddTopicWidget(topicModel: model)));

    if (updatedTopicModel != null) {
      isReturnedFromUpdate = true;
      setState(() {
        topicModel = updatedTopicModel;
      });
    }
  }

  @override
  void dispose() {

    if (expenseViewModel != null) expenseViewModel!.expenses = null;
    super.dispose();
  }

}

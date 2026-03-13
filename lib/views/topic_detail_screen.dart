import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';
import 'package:kashew/views/widgets/date_header.dart';
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
  CategoryViewModel? categoryViewModel;
  bool isReturnedFromUpdate = false;
  bool _expensesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    categoryViewModel = context.read<CategoryViewModel>();
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
                      Text(context.lang.lblTotalExpense.toUpperCase(),
                          style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.w500)),
                      Text(expenseViewModel.getTotalExpenses(topicModel.id!).toString(),
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
                      Text(context.lang.lblExpenses, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                      //Text(Constants.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
                    child: (expenseViewModel.isExpenseLoading) ? const Center(child: CircularProgressIndicator()):
                    (expenseViewModel.groupExpenses == null || expenseViewModel.groupExpenses!.isEmpty) ?
                    noExpenseFound() :
                    ListView.builder(
                        itemCount: expenseViewModel.groupExpenses!.length,
                        itemBuilder: (context, index) {
                          final group = expenseViewModel.groupExpenses![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateHeader(date: group.date),
                              Card(
                                margin: EdgeInsets.only(bottom: R.h(10)),
                                elevation: 0,
                                color: HexColor.fromHex(Constants.pureWhiteColor),
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      itemCount: group.expenses.length,
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) => Divider(height: 1, indent: R.w(20), endIndent: R.w(20), color: HexColor.fromHex(Constants.dividerColor)),
                                      itemBuilder: (context, index) {
                                        final expense = group.expenses[index];
                                        return Slidable(
                                          key: ValueKey(expense.id),
                                          endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              children: [
                                                CustomSlidableAction(
                                                  flex: 1,
                                                  autoClose: true,
                                                  onPressed: (context) => showEditExpensePopup(expense),
                                                  child: Container(
                                                      margin: EdgeInsets.only(bottom: R.h(10), left: R.w(3), right: R.w(3)),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: Center(
                                                        child: Icon(Icons.edit, size: R.w(25), color: HexColor.fromHex(Constants.pureWhiteColor)),
                                                      )),
                                                ),
                                                CustomSlidableAction(
                                                  flex: 1,
                                                  autoClose: true,
                                                  onPressed: (context) => showExpenseDeleteDialog(context, expense),
                                                  child: Container(
                                                      margin: EdgeInsets.only(bottom: R.h(10), left: R.w(3), right: R.w(3)),
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(20)),
                                                      child: Center(
                                                        child: Icon(Icons.delete, size: R.w(25), color: HexColor.fromHex(Constants.pureWhiteColor)),
                                                      )),
                                                ),
                                              ]
                                          ),
                                          child: expenseCard(expense, categoryViewModel!.getIconByCategoryId(expense.categoryId!)),
                                        );
                                      },
                                    ),
                                  ]
                                )
                              ),
                            ],
                          );
                        }),
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

  Widget expenseCard(ExpenseModel expense, IconData icon) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(Constants.stdMargin)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: R.w(10)),
            width: R.w(30), height: R.h(30),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: HexColor.fromHex(Constants.warmWhiteColor)),
            child: Icon(icon, color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
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
    );
  }

  Widget noExpenseFound() {

    return Center(
      child: Text(context.lang.lblNoExpenses,
          style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12),
              color: HexColor.fromHex(Constants.textSecondaryColor))),
    );
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
                  title: Text(context.lang.menuEditTopic,
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
                    context.lang.menuDeleteTopic,
                    style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15),
                        color: (model.isSystem == Constants.wahr) ? HexColor.fromHex(Constants.textSecondaryColor) :  Colors.red),
                  ),
                  enabled: (model.isSystem == Constants.wahr) ? false : true,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final result = await showTopicDeleteDialog(parentContext);
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

  Future<bool?> showTopicDeleteDialog(BuildContext context) async {

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.lang.dialogTopicDeleteTitle, style: TextStyle(fontFamily: Constants.fontTitle, fontWeight: FontWeight.bold, fontSize: R.sp(18))),
          content: Text(context.lang.dialogTopicDeleteMessage,
              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.lang.dialogCancel, style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                context.lang.dialogDeleteConfirm,
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

  void showAddExpensePopup(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddExpenseWidget(topicModel: topicModel));
  }

  void showEditExpensePopup(ExpenseModel model) async {

    await showModalBottomSheet<TopicModel>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddExpenseWidget(topicModel: topicModel, expenseModel: model));
  }

  Future<bool?> showExpenseDeleteDialog(BuildContext context, ExpenseModel expense) async {

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.lang.dialogExpenseDeleteTitle, style: TextStyle(fontFamily: Constants.fontTitle, fontWeight: FontWeight.bold, fontSize: R.sp(18))),
          content: Text(context.lang.dialogExpenseDeleteMessage,
              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.lang.dialogCancel, style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(15))),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                context.lang.dialogDeleteConfirm,
                style: TextStyle(fontFamily: Constants.fontBody, fontWeight: FontWeight.bold, fontSize: R.sp(15), color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != null && confirmed && expenseViewModel != null) {
      expenseViewModel!.deleteExpense(expense.id!);
    }
    return confirmed;
  }

  @override
  void dispose() {

    if (expenseViewModel != null) expenseViewModel!.groupExpenses = null;
    super.dispose();
  }

}

import 'package:flutter/material.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/expense_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/expense_viewmodel.dart';
import 'package:kashew/view_models/home_viewmodel.dart';
import 'package:kashew/views/home/topics_widget.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  late CategoryViewModel categoryViewModel;
  late CurrencyViewModel currencyViewModel;
  late CurrencyModel currencyModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    categoryViewModel = context.read<CategoryViewModel>();
    currencyViewModel = context.read<CurrencyViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseViewModel>().loadRecentExpenses();
      context.read<HomeViewModel>().loadStats();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      context.read<ExpenseViewModel>().loadRecentExpenses();
      context.read<HomeViewModel>().loadStats();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton.filled(
              icon: Icon(Icons.settings, size: R.w(18), color: HexColor.fromHex(Constants.textSecondaryColor)),
              style: IconButton.styleFrom(backgroundColor: HexColor.fromHex(Constants.lightGrayColor)),
              onPressed: () => Navigator.pushNamed(context, Constants.settings)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Top Summary/Stats Section
          Consumer<HomeViewModel>(
              builder: (context, homeViewModel, child) {

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor.fromHex(Constants.pureWhiteColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: R.h(20), horizontal: R.w((15))),
                  margin: EdgeInsets.symmetric(vertical: R.h(10), horizontal: R.w((15))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (homeViewModel.topCategory != null)
                        Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Top Category".toUpperCase(),
                                  style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), fontWeight: FontWeight.w500, color: HexColor.fromHex(Constants.textSecondaryColor))),
                              Text(homeViewModel.topCategory!,
                                  style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(20), fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: R.w(50), height: R.h(50),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: HexColor.fromHex(Constants.warmWhiteColor)),
                            child: Icon(categoryViewModel.getIconByCategoryId(homeViewModel.categoryId!), color: HexColor.fromHex(Constants.textSecondaryColor), size: R.w(15)),
                          )
                        ],
                      ),

                      SizedBox(height: R.h(15)),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(Constants.kUnit,
                              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.primaryColor))),
                          SizedBox(width: R.w(5)),
                          Text(homeViewModel.totalMonthlyExpense != null ?"${homeViewModel.totalMonthlyExpense}" : "0.00",
                              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(30), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.primaryColor))),
                          SizedBox(width: R.w(8)),
                          Text("this month",
                              style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.w500)),
                          SizedBox(width: R.w(5)),
                          Tooltip(
                              message: "kU (Kashew Unit) is an internal unit that sums expenses from different currencies. It represents spending activity, not real money.",
                              triggerMode: TooltipTriggerMode.tap,
                              showDuration: const Duration(seconds: 10),
                              margin: EdgeInsets.symmetric(horizontal: R.w(20)),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6)
                              ),
                              child: Icon(Icons.info, size: R.w(15), color: HexColor.fromHex(Constants.textSecondaryColor)))
                        ],
                      ),

                    ],
                  ),
                );
              }),

          // Topics Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.lang.lblTopics, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                Text(context.lang.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
              ],
            ),
          ),
          TopicsWidget(),

          // Recent Expenses
          Padding(
            padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.lang.lblRecentExpenses, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                Text(context.lang.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
                child: Consumer<ExpenseViewModel>(builder: (context, expenseViewModel, child) {
                  return Column(
                    children: [
                      ... (expenseViewModel.isExpenseLoading) ? [const Center(child: CircularProgressIndicator())]:
                      (expenseViewModel.recentExpenses == null || expenseViewModel.recentExpenses!.isEmpty) ?
                      [noExpenseFound()] :
                      List.generate(expenseViewModel.recentExpenses!.length, (index) => expenseCard(expenseViewModel.recentExpenses![index])),
                    ],
                  );
                }),
              ),
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

  Widget expenseCard(ExpenseModel expense) {

    currencyModel = currencyViewModel.getCurrencyFromCode(expense.currency!);
    IconData icon = currencyModel.symbol!;
    return Card(
      margin: EdgeInsets.only(bottom: R.w(10)),
      elevation: 0,
      color: HexColor.fromHex(Constants.pureWhiteColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: R.h(8), horizontal: R.w(Constants.stdMargin)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: R.w(10)),
              width: R.w(30), height: R.h(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: HexColor.fromHex(Constants.warmWhiteColor)),
              child: Icon(categoryViewModel.getIconByCategoryId(expense.categoryId!), color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title, style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(13), fontWeight: FontWeight.bold),),
                Text(CommonUtils.getReadableDateFromMs(expense.dbDateTime), style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor))),
              ],
            ),
            Expanded(child: Container()),
            RichText(text: TextSpan(
                style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: Colors.red),
                children: [
                  if (icon == CurrencyModel.fallbackIcon)
                    TextSpan(text: currencyModel.currency)
                  else
                    WidgetSpan(child: Icon(icon, size: R.w(15), color: Colors.red)),
                  WidgetSpan(child: SizedBox(width: R.w(2))),
                  TextSpan(text: expense.amount.toString()),
                ]
            )),
          ],
        ),
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

  void showAddExpensePopup(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) => AddExpenseWidget());
  }

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}

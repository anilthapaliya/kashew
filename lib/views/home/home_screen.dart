import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/views/home/topics_widget.dart';
import 'package:kashew/views/widgets/add_expense_widget.dart';
import 'package:kashew/views/widgets/add_topic_widget.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
    });
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
              onPressed: () {}),
          ],
        ),
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
                Text(Constants.lblMonthlyExpense.toUpperCase(),
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
                Text(Constants.lblTopics, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                Text(Constants.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
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
                Text(Constants.lblRecentExpenses, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                Text(Constants.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
                child: Column(
                  children: List.generate(6, (index) => expenseCard()),
                ),
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

  Widget expenseCard() {

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
                Text('Uber Ride', style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(13), fontWeight: FontWeight.bold),),
                Text('Transport, Today', style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor))),
              ],
            ),
            Expanded(child: Container()),
            Text('\$74', style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: Colors.red)),

          ],
        ),
      ),
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

}

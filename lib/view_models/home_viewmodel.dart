import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

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
                Text(Constants.lblTopics, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                Text(Constants.lblViewAll, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor)),),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(5)),
              child: Row(
                children: [
                  addTopic(),
                  ... List.generate(5, (index) => topicCard()),
                ]
              ),
            ),
          ),

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
          onPressed: () => showAddExpense(context),
          shape: const CircleBorder(),
          backgroundColor: HexColor.fromHex(Constants.primaryColor),
          child: Icon(Icons.add, color: HexColor.fromHex(Constants.warmWhiteColor))),
    );
  }

  Widget addTopic() {

    return Card(
      margin: EdgeInsets.only(right: R.w(10)),
      elevation: 0,
      color: HexColor.fromHex(Constants.warmWhiteColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(17)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: R.w(30), height: R.h(30),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: HexColor.fromHex(Constants.lightGrayColor)),
              child: Icon(Icons.add, color: HexColor.fromHex(Constants.darkBgColor), size: R.w(15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget topicCard() {

    return Card(
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
            Text('Europe\'s Trip', style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.bold),),
            Text('Jan 2026', style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor))),
            SizedBox(height: R.h(10)),
            Text('\$1000', style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(10), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
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

  void showAddExpense(BuildContext context) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Top Row
                Row(
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                    const Expanded(child: SizedBox()),
                    Text(Constants.lblAppBarAddTopic, textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                    const Expanded(child: SizedBox()),
                    IconButton(onPressed: () {}, icon: Icon(Icons.circle, color: HexColor.fromHex(Constants.warmWhiteColor))),
                  ],
                ),

                SizedBox(height: R.h(40)),
                Text(Constants.lblTopicName, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                    fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                TextField(
                  decoration: InputDecoration(
                      hintText: Constants.hintTopic,
                      filled: true,
                      fillColor: HexColor.fromHex(Constants.lightGrayColor),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                ),

                SizedBox(height: R.h(20)),
                Text(Constants.lblStartDate, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                    fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                TextField(
                  decoration: InputDecoration(
                      hintText: Constants.hintToday,
                      suffixIcon: Icon(Icons.calendar_month),
                      filled: true,
                      fillColor: HexColor.fromHex(Constants.lightGrayColor),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                ),

                SizedBox(height: R.h(20)),
                Row(
                  children: [
                    Text(Constants.lblDescription, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                    const Expanded(child: SizedBox()),
                    Text(Constants.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  minLines: 4,
                  maxLength: 100,
                  decoration: InputDecoration(
                      hintText: Constants.hintDescription,
                      filled: true,
                      fillColor: HexColor.fromHex(Constants.lightGrayColor),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                ),

                SizedBox(height: R.h(70)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_rounded, size: R.w(20)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: R.h(10), horizontal: R.w(30)),
                        backgroundColor: HexColor.fromHex(Constants.primaryColor),
                        foregroundColor: HexColor.fromHex(Constants.warmWhiteColor),
                        iconAlignment: IconAlignment.end,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      label: Text(Constants.btnCreateTopic, style: TextStyle(
                          fontFamily: Constants.fontBody, fontSize: R.sp(16), fontWeight: FontWeight.bold))
                  ),
                ),

                SizedBox(height: R.h(10)),
                Center(
                  child: Text(Constants.lblTopicHelp, style: TextStyle(
                      fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor)
                  )),
                ),
              ],
            ),
          );
    });
  }

}

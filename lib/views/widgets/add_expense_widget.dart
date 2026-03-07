import 'package:flutter/material.dart';
import 'package:kashew/models/category_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:provider/provider.dart';

class AddExpenseWidget extends StatefulWidget {

  final TopicModel? topicModel;
  const AddExpenseWidget({super.key, this.topicModel});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();

}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {

  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController dateController;
  late final TextEditingController noteController;
  late final TextEditingController topicController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {

    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
    dateController = TextEditingController();
    noteController = TextEditingController();
    topicController = TextEditingController();

    Future.microtask(() {
      if (!mounted) return;
      context.read<CategoryViewModel>().loadCategories();
      dateController.text = CommonUtils.getReadableDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryViewModel>(
        builder: (context, categoryViewModel, child) {
          if (categoryViewModel.categories == null || categoryViewModel.categories!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

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
                    Text(Constants.lblAppBarAddExpense, textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                    const Expanded(child: SizedBox()),
                    IconButton(onPressed: () {}, icon: Icon(Icons.circle, color: HexColor.fromHex(Constants.warmWhiteColor))),
                  ],
                ),

                // Expense Title
                SizedBox(height: R.h(40)),
                Text(Constants.lblExpenseTitle, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                    fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      hintText: Constants.hintExpenseTitle,
                      filled: true,
                      fillColor: HexColor.fromHex(Constants.lightGrayColor),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                ),

                // Expense Amount
                SizedBox(height: R.h(20)),
                Text(Constants.lblExpenseAmount, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                    fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: Constants.hintToday,
                      suffixIcon: Icon(Icons.payments),
                      filled: true,
                      fillColor: HexColor.fromHex(Constants.lightGrayColor),
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                ),

                // Choose Category and Date
                SizedBox(height: R.h(20)),
                Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            Text(Constants.lblCategory, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                            const Expanded(child: SizedBox()),
                            Text(Constants.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                          ],
                        )),
                    Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Text(Constants.lblDate, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                            const Expanded(child: SizedBox()),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: DropdownMenu<CategoryModel>(
                        leadingIcon: categoryViewModel.selectedCategory != null ?
                        Icon(categoryViewModel.selectedCategory!.icon, color: HexColor.fromHex(Constants.accentColor)) : null,
                        hintText: categoryViewModel.selectedCategory!.categoryName,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: HexColor.fromHex(Constants.lightGrayColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownMenuEntries: categoryViewModel.categories!.map((cat) {
                          return DropdownMenuEntry<CategoryModel>(
                            value: cat,
                            label: cat.categoryName,
                            leadingIcon: Icon(cat.icon, color: HexColor.fromHex(Constants.accentColor)),
                          );
                        }).toList(),
                        onSelected: (value) {},
                      ),
                    ),

                    Expanded(flex: 1, child: SizedBox()),

                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        onTap: _datePicker,
                        decoration: InputDecoration(
                            hintText: Constants.hintToday,
                            suffixIcon: Icon(Icons.calendar_month),
                            filled: true,
                            fillColor: HexColor.fromHex(Constants.lightGrayColor),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                  ],
                ),

                // Link to a Topic
                SizedBox(height: R.h(20)),
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Row(
                          children: [
                            Text(Constants.lblTopic, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                            const Expanded(child: SizedBox()),
                            Text(Constants.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                          ],
                        )),
                    Expanded(flex: 0, child: SizedBox()),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextField(
                        controller: topicController,
                        onTap: () => Navigator.pushNamed(context, Constants.topicOnlyList),
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: Constants.hintLinkTopic,
                            prefixIcon: Icon(Icons.link_rounded),
                            suffixIcon: Icon(Icons.keyboard_arrow_right_rounded),
                            filled: true,
                            fillColor: HexColor.fromHex(Constants.lightGrayColor),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                    Expanded(flex: 0, child: SizedBox()),
                  ],
                ),

                // Notes
                SizedBox(height: R.h(20)),
                Row(
                  children: [
                    Text(Constants.lblNotes, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                    const Expanded(child: SizedBox()),
                    Text(Constants.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                        fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                  ],
                ),
                TextField(
                  controller: noteController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 3,
                  maxLength: 100,
                  decoration: InputDecoration(
                      hintText: Constants.hintNotes,
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
                      label: Text(Constants.btnAddExpense, style: TextStyle(
                          fontFamily: Constants.fontBody, fontSize: R.sp(16), fontWeight: FontWeight.bold))
                  ),
                ),

              ],
            ),
          );
        });
  }

  Future<void> _datePicker() async {

    final today = DateTime.now();
    final firstDate = today.subtract(Duration(days: 30));
    final lastDate = today.add(Duration(days: 30));
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      selectedDate = date;
      dateController.text = CommonUtils.getReadableDate(selectedDate);
    }
  }

}

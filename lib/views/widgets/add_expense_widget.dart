import 'package:flutter/material.dart';
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
import 'package:kashew/view_models/home_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';

class AddExpenseWidget extends StatefulWidget {

  final TopicModel? topicModel;
  final ExpenseModel? expenseModel; // Needed to edit an expense.
  final Future<TopicModel?> Function()? onSelectTopic;
  const AddExpenseWidget({super.key, this.topicModel, this.expenseModel, this.onSelectTopic});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();

}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {

  CategoryViewModel? categoryViewModel;
  TopicViewModel? topicViewModel;
  ExpenseViewModel? expenseViewModel;

  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController dateController;
  late final TextEditingController noteController;
  late final TextEditingController topicController;
  late DateTime selectedDate;
  bool _initialized = false;

  @override
  void initState() {

    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
    dateController = TextEditingController();
    noteController = TextEditingController();
    topicController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    categoryViewModel = context.read<CategoryViewModel>();
    topicViewModel = context.read<TopicViewModel>();
    expenseViewModel = context.read<ExpenseViewModel>();
    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  void initialize() {

    categoryViewModel!.loadCategories();
    if (widget.topicModel != null) {
      topicViewModel!.setSelectedTopic(widget.topicModel!);
      topicController.text = widget.topicModel!.name;
    }
    selectedDate = DateTime.now();
    if (widget.expenseModel != null) {
      titleController.text = widget.expenseModel!.title;
      amountController.text = widget.expenseModel!.amount.toString();
      selectedDate = DateTime.fromMillisecondsSinceEpoch(widget.expenseModel!.dbDateTime);
      noteController.text = widget.expenseModel!.note!;
      categoryViewModel!.selectCategoryById(widget.expenseModel!.categoryId!);
    }
    dateController.text = CommonUtils.getReadableDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer3<CategoryViewModel, TopicViewModel, ExpenseViewModel>(
          builder: (sheetContext, categoryViewModel, topicViewModel, expenseViewModel, child) {

            if (categoryViewModel.categories == null || categoryViewModel.categories!.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox.expand(
              child: SingleChildScrollView(
                key: const Key('scroll-view'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Top Row
                      Row(
                        children: [
                          IconButton(key: const Key("close-button"), onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                          const Expanded(child: SizedBox()),
                          Expanded(
                            child: Text(key: const Key("header"), context.lang.lblAppBarAddExpense, textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                          ),
                          const Expanded(child: SizedBox()),
                          widget.expenseModel != null ?
                          InkWell(
                            onTap: widget.expenseModel != null ? () async {
                              if (!expenseViewModel.isExpenseAdding) {
                                String title = titleController.text;
                                String amount = amountController.text;
                                DateTime date = selectedDate;
                                String note = noteController.text;
                                int categoryId = (categoryViewModel.selectedCategory != null)
                                    ? categoryViewModel.selectedCategory!.id! : Constants.defaultCategoryId;
                                int topicId = widget.topicModel!.id!;
                                int result = await expenseViewModel.updateExpenseByValue(context.lang, widget.expenseModel!.id!, title, amount, date, note, topicViewModel.selectedTopic!.currency!, categoryId, topicId);
                                reloadStats();
                                if (result == Constants.success && mounted) Navigator.pop(sheetContext);
                              }
                            } : null,
                            child: Text(context.lang.lblAppBarSave,
                                textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                                    fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor))),) :
                          IconButton(onPressed: null, icon: Icon(Icons.circle, color: HexColor.fromHex(Constants.warmWhiteColor))),
                        ],
                      ),

                      // Expense Title
                      SizedBox(height: R.h(40)),
                      Text(context.lang.lblExpenseTitle, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                          fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                      TextField(
                        key: const Key('title-text-field'),
                        controller: titleController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: context.lang.hintExpenseTitle,
                            errorText: expenseViewModel.isError ? expenseViewModel.errorTitle : null,
                            filled: true,
                            fillColor: HexColor.fromHex(Constants.lightGrayColor),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                      ),

                      // Expense Amount
                      SizedBox(height: R.h(20)),
                      Text(context.lang.lblExpenseAmount, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                          fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                      TextField(
                        key: const Key('amount-text-field'),
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: context.lang.hintAmount,
                            errorText: expenseViewModel.isError ? expenseViewModel.errorAmount : null,
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
                                  Expanded(
                                    child: Text(context.lang.lblCategory, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                        fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Text(context.lang.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                        fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                                  ),
                                ],
                              )),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 4,
                              child: Text(context.lang.lblDate, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                  fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor)))),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: DropdownMenu<CategoryModel>(
                              key: const Key('category-dropdown'),
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
                              onSelected: (value) {
                                if (value != null) categoryViewModel.selectCategory(value);
                              },
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              key: const Key('date-text-field'),
                              controller: dateController,
                              readOnly: true,
                              onTap: _datePicker,
                              decoration: InputDecoration(
                                  hintText: context.lang.hintToday,
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
                                  Text(context.lang.lblTopic, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                                      fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                                  const Expanded(child: SizedBox()),
                                  Text(context.lang.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
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
                              key: const Key('topic-text-field'),
                              controller: topicController,
                              enabled: (widget.expenseModel == null) ? true : false,
                              onTap: () async {
                                final result = await widget.onSelectTopic?.call();
                                if (result != null) {
                                  topicViewModel.setSelectedTopic(result, notify: true);
                                  topicController.text = result.name;
                                }
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                  hintText: context.lang.hintLinkTopic,
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
                          Text(context.lang.lblNotes, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                              fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                          const Expanded(child: SizedBox()),
                          Text(context.lang.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                              fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                        ],
                      ),
                      TextField(
                        key: const Key('notes-text-field'),
                        controller: noteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        minLines: 3,
                        maxLength: 100,
                        decoration: InputDecoration(
                            hintText: context.lang.hintNotes,
                            filled: true,
                            fillColor: HexColor.fromHex(Constants.lightGrayColor),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
                      ),

                      // Button
                      if (widget.expenseModel == null)
                      SizedBox(height: R.h(70)),
                      if (widget.expenseModel == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            key: const Key('add-expense-button'),
                            onPressed: _handleAddExpense,
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
                            label: Text(context.lang.btnAddExpense, style: TextStyle(
                                fontFamily: Constants.fontBody, fontSize: R.sp(16), fontWeight: FontWeight.bold))
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          });
  }

  Future<void> _handleAddExpense() async {

    if (expenseViewModel!.isExpenseAdding) return;
    String title = titleController.text;
    String amount = amountController.text;
    DateTime date = selectedDate;
    String note = noteController.text;
    int topicId = (topicViewModel!.selectedTopic != null)
        ? topicViewModel!.selectedTopic!.id! : Constants.defaultTopicId;
    int categoryId = (categoryViewModel!.selectedCategory != null)
        ? categoryViewModel!.selectedCategory!.id! : Constants.defaultCategoryId;

    int result = await expenseViewModel!.addExpenseByValue(context.lang, title, amount, date, note, topicViewModel!.selectedTopic!.currency!, categoryId, topicId);
    if (result == Constants.success) {
      await topicViewModel!.updateLastUpdated(topicViewModel!.selectedTopic!);
      reloadStats();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _datePicker() async {

    final today = DateTime.now();
    var firstDate = today.subtract(Duration(days: 7));
    var initialDate = today;
    if (widget.topicModel != null) {
      initialDate =
          DateTime.fromMillisecondsSinceEpoch(widget.topicModel!.dbDateTime);
    }

    final lastDate = today.add(Duration(days: 30));
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      selectedDate = date;
      dateController.text = CommonUtils.getReadableDate(selectedDate);
    }
  }

  void reloadStats() {

    context.read<HomeViewModel>().loadStats();
  }

  @override
  void dispose() {

    titleController.dispose();
    amountController.dispose();
    dateController.dispose();
    noteController.dispose();
    topicController.dispose();

    super.dispose();
  }

}

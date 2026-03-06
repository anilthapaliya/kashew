import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../utils/constants.dart';
import '../../utils/hex_color.dart';
import '../../utils/responsive.dart';

class AddTopicWidget extends StatefulWidget {
  const AddTopicWidget({super.key});

  @override
  State<AddTopicWidget> createState() => _AddTopicWidgetState();
}

class _AddTopicWidgetState extends State<AddTopicWidget> {

  TopicViewModel? topicViewModel;
  late final TextEditingController topicController;
  late final TextEditingController dateController;
  late final TextEditingController descriptionController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {

    super.initState();
    topicController = TextEditingController();
    dateController = TextEditingController();
    descriptionController = TextEditingController();

    Future.microtask(() {
      if (!mounted) return;
      context.read<CurrencyViewModel>();
      context.read<CategoryViewModel>().loadCategories();
      topicViewModel = context.read<TopicViewModel>();
      dateController.text = "${CommonUtils.getReadableDate(selectedDate)} (Today)";
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer3<CategoryViewModel, CurrencyViewModel, TopicViewModel>(
      builder: (context, CategoryViewModel categoryViewModel, CurrencyViewModel currencyViewModel,
          TopicViewModel topicVideModel, child) {

        if (categoryViewModel.categories == null || categoryViewModel.categories!.isEmpty ||
            currencyViewModel.currencies.isEmpty) {
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
                  Text(Constants.lblAppBarAddTopic, textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                      fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                  const Expanded(child: SizedBox()),
                  IconButton(onPressed: () {}, icon: Icon(Icons.circle, color: HexColor.fromHex(Constants.warmWhiteColor))),
                ],
              ),

              // Topic
              SizedBox(height: R.h(40)),
              Text(Constants.lblTopicName, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                  fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
              TextField(
                controller: topicController,
                maxLength: 30,
                decoration: InputDecoration(
                    hintText: Constants.hintTopic,
                    errorText: (topicViewModel != null && topicViewModel!.isError) ? topicViewModel!.errorMessage : null,
                    errorStyle: TextStyle(fontFamily: Constants.fontBody, color: Colors.red, fontSize: R.sp(10)),
                    filled: true,
                    fillColor: HexColor.fromHex(Constants.lightGrayColor),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
              ),

              // Start date
              SizedBox(height: R.h(20)),
              Text(Constants.lblStartDate, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                  fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
              TextField(
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

              // Choose Category and Currency
              SizedBox(height: R.h(20)),
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Text(Constants.lblCurrency, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                              fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                          const Expanded(child: SizedBox()),
                          Text(Constants.lblOptional, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                              fontSize: R.sp(10), color: HexColor.fromHex(Constants.darkBgColor))),
                        ],
                      )),
                  Expanded(flex: 5, child: SizedBox()),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: DropdownMenu<CurrencyModel>(
                      leadingIcon: currencyViewModel.defaultCurrency!.symbol != null ?
                      Icon(currencyViewModel.defaultCurrency!.symbol, color: HexColor.fromHex(Constants.accentColor)) : null,
                      hintText: currencyViewModel.defaultCurrency!.currency,
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: HexColor.fromHex(Constants.lightGrayColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownMenuEntries: currencyViewModel.currencies.map((cur) {
                        return DropdownMenuEntry<CurrencyModel>(
                          value: cur,
                          label: cur.currency!,
                          leadingIcon: Icon(cur.symbol, color: HexColor.fromHex(Constants.accentColor)),
                        );
                      }).toList(),
                      onSelected: (value) {
                        currencyViewModel.selectCurrency(value!);
                      },
                    ),
                  ),
                  Expanded(flex: 5, child: SizedBox()),
                ],
              ),

              // Description
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
                controller: descriptionController,
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

              // Button
              SizedBox(height: R.h(70)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: topicVideModel.isTopicAdding ? null : () async {
                      TopicModel model = TopicModel(
                        name: topicController.text,
                        description: descriptionController.text,
                        currency: currencyViewModel.defaultCurrency!.code,
                        dbDateTime: selectedDate.millisecondsSinceEpoch,
                      );
                      int status = await topicViewModel!.addTopic(model);
                      if (status == Constants.success && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: topicVideModel.isTopicAdding ? CircularProgressIndicator()
                        : Icon(Icons.arrow_forward_rounded, size: R.w(20)),
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

              // Help text
              SizedBox(height: R.h(10)),
              Center(
                child: Text(Constants.lblTopicHelp, style: TextStyle(
                    fontFamily: Constants.fontBody, fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor)
                )),
              ),

            ],
          ),
        );
      }
    );
  }

  Future<void> _datePicker() async {

    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );

    if (date != null) {
      selectedDate = date;
      dateController.text = CommonUtils.getReadableDate(selectedDate);
    }
  }

  @override
  void dispose() {

    topicController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

}

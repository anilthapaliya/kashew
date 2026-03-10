import 'package:flutter/material.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/topic_model.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart';
import '../../utils/hex_color.dart';
import '../../utils/responsive.dart';

class AddTopicWidget extends StatefulWidget {

  final TopicModel? topicModel; // Needed to edit and delete a topic.
  const AddTopicWidget({super.key, this.topicModel});

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<CurrencyViewModel>();
    context.read<CategoryViewModel>().loadCategories();
    topicViewModel = context.read<TopicViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (widget.topicModel != null) {
        topicController.text = widget.topicModel!.name;
        dateController.text = widget.topicModel!.readableDateTime;
        descriptionController.text = widget.topicModel!.description!;
      }

      if (widget.topicModel == null) dateController.text = "${CommonUtils.getReadableDate(selectedDate)} (Today)";
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
                  Text(widget.topicModel != null ? Constants.lblAppBarEditTopic : Constants.lblAppBarAddTopic,
                      textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                      fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
                  const Expanded(child: SizedBox()),
                  widget.topicModel != null ?
                  InkWell(
                    onTap: widget.topicModel != null ? () async {
                      if (!topicVideModel.isTopicAdding) {
                        TopicModel model = TopicModel(
                            id: widget.topicModel!.id,
                            name: topicController.text,
                            description: descriptionController.text,
                            currency: currencyViewModel.defaultCurrency!.code,
                            dbDateTime: selectedDate.millisecondsSinceEpoch);
                        int status = await topicVideModel.saveTopic(model);
                        if (status == Constants.success && context.mounted) Navigator.pop(context, model);
                      }
                  } : null,
                  child: Text(Constants.lblAppBarSave,
                      textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontTitle,
                          fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.textSecondaryColor))),) :
                  IconButton(onPressed: null, icon: Icon(Icons.circle, color: HexColor.fromHex(Constants.warmWhiteColor))),
                ],
              ),

              // Topic
              SizedBox(height: R.h(40)),
              Text(Constants.lblTopicName, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                  fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
              TextField(
                controller: topicController,
                enabled: !topicVideModel.isTopicAdding,
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
              /*SizedBox(height: R.h(20)),
              Text(Constants.lblStartDate, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                  fontSize: R.sp(12), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: !topicVideModel.isTopicAdding ? _datePicker : null,
                decoration: InputDecoration(
                    hintText: Constants.hintToday,
                    suffixIcon: Icon(Icons.calendar_month),
                    filled: true,
                    fillColor: HexColor.fromHex(Constants.lightGrayColor),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(4))),
              ),*/

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
                enabled: !topicVideModel.isTopicAdding,
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

              // Choose Currency
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
                      enabled: !topicVideModel.isTopicAdding,
                      leadingIcon: widget.topicModel != null ? Icon(CurrencyModel.iconMap[widget.topicModel!.currency], color: HexColor.fromHex(Constants.accentColor))
                          : currencyViewModel.defaultCurrency!.symbol != null ?
                      Icon(currencyViewModel.defaultCurrency!.symbol, color: HexColor.fromHex(Constants.accentColor)) : null,
                      hintText: widget.topicModel != null ? CurrencyModel.currencyMap[widget.topicModel!.currency] : currencyViewModel.defaultCurrency!.currency,
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

              // Button
              if (widget.topicModel == null) SizedBox(height: R.h(70)),
              if (widget.topicModel == null)
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
              if (widget.topicModel == null) SizedBox(height: R.h(10)),
              if (widget.topicModel == null)
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

  @override
  void dispose() {

    topicController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

}

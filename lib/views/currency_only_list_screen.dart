import 'package:flutter/material.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:provider/provider.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {

  late CurrencyViewModel currencyViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currencyViewModel = Provider.of<CurrencyViewModel>(context, listen: false);
    currencyViewModel.loadDefaultCurrency();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.lblAppBarTopicList, overflow: TextOverflow.fade,
            textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
      ),
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
        decoration: BoxDecoration(
          color: HexColor.fromHex(Constants.warmWhiteColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: R.w(20)),
              child: Text(Constants.lblTopics, overflow: TextOverflow.fade,
                  textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                      fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
            ),
            SizedBox(height: R.h(10)),
            Consumer<CurrencyViewModel>(
                builder: (context, currencyViewModel, child) {
                  return Card(
                    elevation: 0,
                    color: HexColor.fromHex(Constants.pureWhiteColor),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount: currencyViewModel.currencies.length,
                              itemBuilder: (context, index) {
                                return singleTopic(currencyViewModel.currencies[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  Divider(height: 1, indent: R.w(20), endIndent: R.w(20), color: HexColor.fromHex(Constants.dividerColor))),
                        ]),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget singleTopic(CurrencyModel currency) {

    return InkWell(
      onTap: () {
        currencyViewModel.setDefaultCurrency(currency);
        Navigator.pop(context, currency);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(20)),
        child: Row(
          children: [
            Icon(currency.symbol!, color: HexColor.fromHex(Constants.textSecondaryColor)),
            SizedBox(width: R.w(20)),
            Text("${currency.currency!} (${currency.code})", overflow: TextOverflow.fade,
                textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                    fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
          ],
        ),
      ),
    );
  }

}

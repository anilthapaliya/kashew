import 'package:flutter/material.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:provider/provider.dart';

class CurrencyListScreen extends StatelessWidget {

  const CurrencyListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.lang.lblAppBarCurrencyList, overflow: TextOverflow.fade,
            textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
      ),
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: R.h(30),
          horizontal: R.w(Constants.stdMargin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: R.w(20)),
              child: Text(context.lang.lblCurrencies, overflow: TextOverflow.fade,
                  textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                      fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
            ),

            SizedBox(height: R.h(10)),

            Expanded(
              child: Consumer<CurrencyViewModel>(
                  builder: (context, currencyViewModel, child) {
                    return Card(
                      elevation: 0,
                      color: HexColor.fromHex(Constants.pureWhiteColor),
                      child: ListView.separated(
                          key: const Key('currency-list'),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: currencyViewModel.currencies.length,
                          itemBuilder: (context, index) {
                            final currency = currencyViewModel.currencies[index];

                            return _CurrencyItem(
                                key: Key('currency-item-${currency.code}'),
                                currency: currency,
                                onTap: () {
                                  currencyViewModel.selectCurrency(currency);
                                  Navigator.pop(context, currency);
                                });
                          },
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, indent: R.w(20), endIndent: R.w(20),
                                  color: HexColor.fromHex(Constants.dividerColor))),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

}

class _CurrencyItem extends StatelessWidget {

  final CurrencyModel currency;
  final VoidCallback onTap;

  const _CurrencyItem({
    super.key,
    required this.currency,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(20)),
        child: Row(
          children: [
            Icon(currency.symbol!, color: HexColor.fromHex(Constants.textSecondaryColor)),
            SizedBox(width: R.w(20)),
            Flexible(
              child: Text("${currency.currency!} (${currency.code})", overflow: TextOverflow.fade,
                  softWrap: false, textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                      fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
            ),
          ],
        ),
      ),
    );
  }

}

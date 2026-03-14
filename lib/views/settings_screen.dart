import 'package:flutter/material.dart';
import 'package:kashew/l10n/app_localizations.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.lang.lblAppBarSettings, overflow: TextOverflow.fade,
            textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontTitle,
                fontSize: R.sp(16), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Preferences
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: R.h(10), horizontal: R.w((15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                      child: Text(context.lang.lblPreferences, overflow: TextOverflow.fade,
                          textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                              fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
                    ),
                    getPreferenceCard(),
                  ],
                ),
              ),

              // Help and Support
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: R.h(10), horizontal: R.w((15))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: R.w(20)),
                      child: Text(context.lang.lblAboutApp, overflow: TextOverflow.fade,
                          textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                              fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
                    ),
                    getSupportCard(),
                  ],
                ),
              ),

            ],
      )),
    );
  }

  Widget getPreferenceCard() {

    return Card(
        margin: EdgeInsets.only(top: R.h(10), bottom: R.w(10)),
        elevation: 0,
        color: HexColor.fromHex(Constants.pureWhiteColor),
        child: Column(
          children: [
            settingsRow(context.lang.lblAppearance, Icons.dark_mode, null, changeAppearance),
            Divider(height: 1, indent: R.w(5), endIndent: R.w(5), color: HexColor.fromHex(Constants.dividerColor)),
            Consumer<CurrencyViewModel>(builder: (context, currencyViewModel, child) {
              return settingsRow(context.lang.lblCurrencySettings, Icons.money,
                  sideWidget(currencyViewModel.defaultCurrency.currency!), showCurrencyList);
            }),
            Consumer<LanguageViewmodel>(builder: (context, languageViewModel, child) {
              return settingsRow(context.lang.lblLanguage, Icons.language,
                  sideWidget(languageViewModel.locale.languageCode), showLanguageList);
            }),
          ],
        )
    );
  }

  Widget getSupportCard() {

    return Card(
        margin: EdgeInsets.only(top: R.h(10), bottom: R.w(10)),
        elevation: 0,
        color: HexColor.fromHex(Constants.pureWhiteColor),
        child: Column(
          children: [
            settingsRow(context.lang.lblHelpSupport, Icons.help, null, (){}),
            Divider(height: 1, indent: R.w(10), endIndent: R.w(10), color: HexColor.fromHex(Constants.dividerColor)),
            settingsRow("App Version ${context.lang.appVersion}", Icons.info, null, changeAppearance),
          ],
        )
    );
  }

  Widget settingsRow(String title, IconData icon, Widget? sideWidget, Function onTap) {

    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(Constants.stdMargin)),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: R.w(10)),
              width: R.w(30), height: R.h(20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: HexColor.fromHex(Constants.warmWhiteColor)),
              child: Icon(icon, color: HexColor.fromHex(Constants.textSecondaryColor), size: R.w(15)),
            ),
            Text(title, overflow: TextOverflow.fade,
                textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                    fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
            if (sideWidget != null)
            const Spacer(),
            ?sideWidget,
          ],
        ),
      ),
    );
  }

  void changeAppearance() {
    print("Appearance");
  }

  Widget sideWidget(String value) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(13), color: HexColor.fromHex(Constants.textSecondaryColor)),
        ),
        SizedBox(width: R.w(4)),
        Icon(Icons.keyboard_arrow_right_rounded, color: HexColor.fromHex(Constants.textSecondaryColor)),
      ],
    );
  }

  void showCurrencyList() async {

    Navigator.pushNamed(context, Constants.currencyOnlyList);
  }

  void showLanguageList() async {

    Navigator.pushNamed(context, Constants.languageOnlyList);
  }

}

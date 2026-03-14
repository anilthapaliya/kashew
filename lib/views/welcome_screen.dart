import 'package:flutter/material.dart';
import 'package:kashew/models/currency_model.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:kashew/view_models/welcome_viewmodel.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WelcomeViewModel welcomeViewModel = context.read<WelcomeViewModel>();
      welcomeViewModel.currencyModel = context.read<CurrencyViewModel>().defaultCurrency;
      welcomeViewModel.languageModel = context.read<LanguageViewmodel>().getLanguage(Constants.langEng);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      ),
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Consumer3<WelcomeViewModel, LanguageViewmodel, CurrencyViewModel>(
          builder: (context, welcomeViewModel, languageViewModel, currencyViewModel, child) {

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w(Constants.stdMargin)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  // Top Welcome Section
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: R.h(30), horizontal: R.w((15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(context.lang.lblWelcome, textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(25), fontWeight: FontWeight.bold)),
                        SizedBox(height: R.h(10)),
                        Text(context.lang.lblWelcomeMessage, textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: Constants.fontBody, fontSize: R.sp(12), fontWeight: FontWeight.w500, color: HexColor.fromHex(Constants.textSecondaryColor))),
                      ],
                    ),
                  ),

                  // Language Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.lang.lblSelectLanguage, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<LanguageModel>(
                          width: double.infinity,
                          initialSelection: languageViewModel.getLanguage(languageViewModel.locale.languageCode),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: HexColor.fromHex(Constants.lightGrayColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                        ),
                        dropdownMenuEntries: languageViewModel.languages.map((lang) {
                          return DropdownMenuEntry<LanguageModel>(
                            value: lang,
                            label: lang.language,
                          );
                        }).toList(),
                        onSelected: (value) {
                          languageViewModel.changeLanguage(value!.code);
                          welcomeViewModel.setLanguage(value);
                        },
                      ),
                      ),
                    ],
                  ),

                  // Currency Section
                  SizedBox(height: R.h(20)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: R.w(15), vertical: R.h(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.lang.lblSelectCurrency, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: R.sp(18), fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<CurrencyModel>(
                          width: double.infinity,
                          leadingIcon: currencyViewModel.defaultCurrency.symbol != null ?
                          Icon(currencyViewModel.defaultCurrency.symbol, color: HexColor.fromHex(Constants.accentColor)) : null,
                          initialSelection: currencyViewModel.defaultCurrency,
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
                            welcomeViewModel.setCurrency(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: R.h(70)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          await welcomeViewModel.saveSettings();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, Constants.home);
                          }
                        },
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
                        label: Text(context.lang.btnGetStarted, style: TextStyle(
                            fontFamily: Constants.fontBody, fontSize: R.sp(16), fontWeight: FontWeight.bold))
                    ),
                  ),

                  // Bottom Info Section
                  SizedBox(height: R.h(10)),
                  Center(
                    child: Text(context.lang.lblTermsOfService,
                        textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.fontBody,
                            fontSize: R.sp(10), color: HexColor.fromHex(Constants.textSecondaryColor)
                    )),
                  ),

              ],
            ),
          ),
        );
      })
      );
  }

}

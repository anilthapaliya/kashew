import 'package:flutter/material.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:provider/provider.dart';

class LanguageListScreen extends StatefulWidget {
  const LanguageListScreen({super.key});

  @override
  State<LanguageListScreen> createState() => _LanguageListScreenState();
}

class _LanguageListScreenState extends State<LanguageListScreen> {

  late LanguageViewmodel languageViewmodel;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    languageViewmodel = Provider.of<LanguageViewmodel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.lang.lblAppBarLanguageList, overflow: TextOverflow.fade,
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
              child: Text(context.lang.lblLanguage, overflow: TextOverflow.fade,
                  textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                      fontSize: R.sp(14), fontWeight: FontWeight.bold, color: HexColor.fromHex(Constants.darkBgColor))),
            ),
            SizedBox(height: R.h(10)),
            Consumer<LanguageViewmodel>(
                builder: (context, languageViewModel, child) {
                  return Card(
                    elevation: 0,
                    color: HexColor.fromHex(Constants.pureWhiteColor),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount: languageViewModel.languages.length,
                              itemBuilder: (context, index) {
                                return singleTopic(languageViewModel.languages[index]);
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

  Widget singleTopic(LanguageModel language) {

    return InkWell(
      onTap: () {
        languageViewmodel.changeLanguage(language.code);
        Navigator.pop(context, language);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: R.h(15), horizontal: R.w(20)),
        child: Row(
          children: [
            //Icon(language.symbol!, color: HexColor.fromHex(Constants.textSecondaryColor)),
            //SizedBox(width: R.w(20)),
            Text(language.language, overflow: TextOverflow.fade,
                textAlign: TextAlign.left, style: TextStyle(fontFamily: Constants.fontBody,
                    fontSize: R.sp(14), color: HexColor.fromHex(Constants.darkBgColor))),
          ],
        ),
      ),
    );
  }

}

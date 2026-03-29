import 'package:flutter/material.dart';
import 'package:kashew/models/language_model.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/localization_extension.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:provider/provider.dart';

class LanguageListScreen extends StatelessWidget {

  const LanguageListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final languageViewmodel = Provider.of<LanguageViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.lang.lblAppBarLanguageList,
          overflow: TextOverflow.fade,
          style: TextStyle(
            fontFamily: Constants.fontTitle,
            fontSize: R.sp(16),
            fontWeight: FontWeight.bold,
            color: HexColor.fromHex(Constants.darkBgColor),
          ),
        ),
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
              child: Text(
                context.lang.lblLanguage,
                style: TextStyle(
                  fontFamily: Constants.fontBody,
                  fontSize: R.sp(14),
                  fontWeight: FontWeight.bold,
                  color: HexColor.fromHex(Constants.darkBgColor),
                ),
              ),
            ),

            SizedBox(height: R.h(10)),

            Expanded(
              child: Consumer<LanguageViewModel>(
                builder: (context, languageViewModel, child) {
                  return Card(
                    elevation: 0,
                    color: HexColor.fromHex(Constants.pureWhiteColor),

                    child: ListView.separated(
                      key: const Key('language-list'),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: languageViewModel.languages.length,
                      itemBuilder: (context, index) {
                        final lang = languageViewModel.languages[index];

                        return _LanguageItem(
                          key: Key('language-item-${lang.code}'), // ✅ stable finder
                          language: lang,
                          onTap: () {
                            languageViewmodel.changeLanguage(lang.code);
                            Navigator.pop(context, lang);
                          },
                        );
                      },

                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        indent: R.w(20),
                        endIndent: R.w(20),
                        color: HexColor.fromHex(Constants.dividerColor)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _LanguageItem extends StatelessWidget {

  final LanguageModel language;
  final VoidCallback onTap;

  const _LanguageItem({
    super.key,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: R.h(15),
          horizontal: R.w(20),
        ),
        child: Row(
          children: [
            Text(
              language.language,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontFamily: Constants.fontBody,
                fontSize: R.sp(14),
                color: HexColor.fromHex(Constants.darkBgColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
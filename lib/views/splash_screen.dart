import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/language_viewmodel.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();
    Future.microtask(() async {

      if (!mounted) return;
      Provider.of<LanguageViewmodel>(context, listen: false).loadLanguage();
      final viewModel = Provider.of<SplashViewModel>(context, listen: false);
      await viewModel.initializeApp();

      if (!mounted) return;
      if (viewModel.initialized) {
        Navigator.pushReplacementNamed(context, Constants.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor.fromHex(Constants.warmWhiteColor),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Constants.imgLogo, width: R.w(120)),
            SizedBox(height: R.h(20)),
            /*Text(Constants.lblSubtitle.toUpperCase(), style: TextStyle(fontFamily: Constants.fontBody,
                color: HexColor.fromHex(Constants.textSecondaryColor), fontSize: R.sp(15), fontWeight: FontWeight.w500)),*/
          ],
        ),
      ),
    );
  }

}

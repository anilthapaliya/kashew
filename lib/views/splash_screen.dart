import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      Provider.of<LanguageViewmodel>(context, listen: false).loadLanguage();
      Provider.of<CurrencyViewModel>(context, listen: false).loadDefaultCurrency();
      final viewModel = Provider.of<SplashViewModel>(context, listen: false);
      await viewModel.initializeApp(Constants.splashDelay);

      if (!mounted) return;
      if (viewModel.showWelcome) {
        Navigator.pushReplacementNamed(context, Constants.welcome);
      }
      else {
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

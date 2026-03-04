import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
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
            Image.asset(Constants.imgLogo, width: 120),
            const SizedBox(height: 20),
            Text(Constants.appTitle, style: TextStyle(fontFamily: Constants.fontTitle,
                color: HexColor.fromHex(Constants.primaryColor), fontSize: 28, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

}

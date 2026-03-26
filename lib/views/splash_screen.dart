import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/hex_color.dart';
import 'package:kashew/utils/responsive.dart';
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
      final viewModel = context.read<SplashViewModel>();
      final route = await viewModel.initializeApp(Constants.splashDelay);

      if (mounted) Navigator.pushReplacementNamed(context, route);
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
            Image.asset(
                key: const Key("splash-image"),
                Constants.imgLogo, width: R.w(120)),
            SizedBox(height: R.h(20)),
          ],
        ),
      ),
    );
  }

}

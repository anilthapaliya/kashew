import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/view_models/home_viewmodel.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:kashew/views/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel())
      ],
          child: const KashewApp()
      ));
}

class KashewApp extends StatelessWidget {

  const KashewApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appTitle,
      routes: {
        Constants.home: (context) => const HomeScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: Constants.fontBody,
      ),
      home: const SplashScreen(),
    );
  }

}

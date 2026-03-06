import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';
import 'package:kashew/view_models/category_viewmodel.dart';
import 'package:kashew/view_models/currency_viewmodel.dart';
import 'package:kashew/view_models/topic_viewmodel.dart';
import 'package:kashew/views/home/home_screen.dart';
import 'package:kashew/view_models/splash_viewmodel.dart';
import 'package:kashew/views/splash_screen.dart';
import 'package:kashew/views/topic_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => CurrencyViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => TopicViewModel()),
      ],
          child: const KashewApp())
  );
}

class KashewApp extends StatelessWidget {

  const KashewApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Initialize the Responsive class.
    R.init(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appTitle,
      routes: {
        Constants.home: (context) => const HomeScreen(),
        Constants.topicDetails: (context) => const TopicDetailScreen(),
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: Constants.fontBody,
      ),
      home: const SplashScreen(),
    );
  }

}

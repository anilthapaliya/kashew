import 'package:flutter/material.dart';
import 'package:kashew/utils/constants.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.lblAppBarHome, style: TextStyle(fontFamily: Constants.fontTitle, fontSize: 20)),
      ),
      body: Center(
        child: Text("Home Screen", style: TextStyle(fontFamily: Constants.fontTitle, fontSize: 25)),
      ),
    );
  }

}

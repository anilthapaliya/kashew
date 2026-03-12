import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kashew/utils/common_utils.dart';
import 'package:kashew/utils/constants.dart';
import 'package:kashew/utils/responsive.dart';

class DateHeader extends StatelessWidget {

  final DateTime date;

  const DateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: R.w(10)),
      child: Text(
        CommonUtils.formatDateHeader(date),
        style: TextStyle(
          fontFamily: Constants.fontTitle, fontSize: R.sp(12), fontWeight: FontWeight.bold),
      ),
    );
  }

}
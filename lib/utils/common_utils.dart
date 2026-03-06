import 'package:intl/intl.dart';

class CommonUtils {

  static const smallWords = {
    'and', 'or', 'the', 'a', 'an', 'in', 'on', 'at', 'to', 'for', 'with', 'but', 'by', 'of'
  };

  static String titleCase(String input) {

    if (input.isEmpty) return input;

    final words = input.toLowerCase().split(' ');

    for (var i = 0; i < words.length; i++) {
      if (i == 0 || !smallWords.contains(words[i])) {
        // capitalize only the first letter
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  static String getReadableDate(DateTime date) {

    return DateFormat('d MMM, yyyy').format(date);
  }

  static String getReadableDateFromMs(int date) {

    return DateFormat('d MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(date));
  }

}
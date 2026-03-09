import 'package:intl/intl.dart';

class CommonUtils {

  static const smallWords = {
    'and', 'or', 'the', 'a', 'an', 'in', 'on', 'at', 'to', 'for', 'with', 'but', 'by', 'of'
  };

  static String titleCase(String input) {

    if (input.isEmpty) return input;

    final words = input.split(' ');

    for (var i = 0; i < words.length; i++) {
      final word = words[i];

      // Preserve acronyms like MBC, USA
      if (word == word.toUpperCase()) continue;

      // find first alphabetic character
      final match = RegExp(r'[A-Za-z]').firstMatch(word);
      if (match == null) continue;

      final letterIndex = match.start;
      final pureWord = word.substring(letterIndex).toLowerCase();

      if (i == 0 || !smallWords.contains(pureWord)) {
        words[i] =
            word.substring(0, letterIndex) +
                word[letterIndex].toUpperCase() +
                word.substring(letterIndex + 1).toLowerCase();
      } else {
        words[i] =
            word.substring(0, letterIndex) +
                word.substring(letterIndex).toLowerCase();
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

  static String capitalizeFirst(String text) {

    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

}
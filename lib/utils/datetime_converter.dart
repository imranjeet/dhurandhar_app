import 'package:intl/intl.dart';

String dateTimeConverter(DateTime dateTime) {
  String formattedDateTime = DateFormat('dd MMMM yyyy \'at\' hh:mm a').format(dateTime);

  return formattedDateTime; // Output: 26 March 2024 at 11:51 PM
}

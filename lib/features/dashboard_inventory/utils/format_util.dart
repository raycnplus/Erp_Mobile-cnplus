String formatShortNumber(dynamic value) {
  double number = 0;
  if (value is num) {
    number = value.toDouble();
  } else {
    number = double.tryParse(value.toString()) ?? 0;
  }

  if (number >= 1e9) {
    return '${(number / 1e9).toStringAsFixed((number % 1e9 == 0) ? 0 : 1)}B';
  } else if (number >= 1e6) {
    return '${(number / 1e6).toStringAsFixed((number % 1e6 == 0) ? 0 : 1)}M';
  } else if (number >= 1e3) {
    return '${(number / 1e3).toStringAsFixed((number % 1e3 == 0) ? 0 : 1)}K';
  } else {
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2);
  }
}
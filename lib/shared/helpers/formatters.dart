import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatCurrency(double value, {bool withPrefix = true}) {
  String prefix = withPrefix ? 'Rp ' : '';
  if (value >= 1_000_000_000) {
    return '$prefix${(value / 1_000_000_000).toStringAsFixed(1).replaceAll('.0', '')} B';
  } else if (value >= 1_000_000) {
    return '$prefix${(value / 1_000_000).toStringAsFixed(1).replaceAll('.0', '')} M';
  } else if (value >= 1_000) {
    return '$prefix${(value / 1_000).toStringAsFixed(1).replaceAll('.0', '')} K';
  } else {
    return '$prefix${value.toStringAsFixed(0)}';
  }
}

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

String formatPrice(double value) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(value);
}

double parsePrice(String value) {
  final cleaned = value.replaceAll(',', '').trim();
  return double.tryParse(cleaned) ?? 0.0;
}

class PriceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    final number = int.tryParse(digitsOnly);
    if (number == null) {
      return oldValue;
    }

    final formatter = NumberFormat('#,##0', 'en_US');
    final formatted = formatter.format(number);

    int cursorPosition = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
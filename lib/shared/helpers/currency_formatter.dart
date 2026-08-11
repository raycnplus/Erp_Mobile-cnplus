import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatCurrencyDisplay(double value) {
  final formatter = NumberFormat('#,##0.00');
  return formatter.format(value);
}

double parseCurrency(String value) {
  final cleaned = value.replaceAll(',', '').trim();
  return double.tryParse(cleaned) ?? 0.0;
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    int dotCount = '.'.allMatches(cleaned).length;
    if (dotCount > 1) {
      cleaned = cleaned.substring(0, cleaned.lastIndexOf('.'));
    }

    List<String> parts = cleaned.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    String formatted = _formatWithCommas(integerPart);

    if (cleaned.contains('.')) {
      formatted += '.$decimalPart';
    }

    int selectionIndex = formatted.length;
    
    if (newValue.selection.baseOffset < newValue.text.length) {
      int oldCommas = ','.allMatches(oldValue.text).length;
      int newCommas = ','.allMatches(formatted).length;
      int commasDiff = newCommas - oldCommas;
      
      selectionIndex = newValue.selection.baseOffset + commasDiff;
      selectionIndex = selectionIndex.clamp(0, formatted.length);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _formatWithCommas(String value) {
    if (value.isEmpty) return '';
    
    int? number = int.tryParse(value);
    if (number == null) return value;
    
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(number);
  }
}
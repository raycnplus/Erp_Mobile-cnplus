String formatQty(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  // Tampilkan hingga 2 desimal, buang trailing zero
  String formatted = value.toStringAsFixed(2);
  formatted = formatted.replaceAll(RegExp(r'0+$'), '');
  formatted = formatted.replaceAll(RegExp(r'\.$'), '');
  return formatted;
}

String humanizeEnum(String value) {
  const exceptions = {'fifo': 'FIFO'};
  if (exceptions.containsKey(value)) return exceptions[value]!;
  return value
      .split('_')
      .map(
        (word) =>
            word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}

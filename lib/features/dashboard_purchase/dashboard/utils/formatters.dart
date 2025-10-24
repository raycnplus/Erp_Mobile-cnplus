

String formatCurrency(double value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1).replaceAll('.0', '')} B';
  } else if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1).replaceAll('.0', '')} M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '')} K';
  } else {
    return value.toStringAsFixed(0);
  }
}
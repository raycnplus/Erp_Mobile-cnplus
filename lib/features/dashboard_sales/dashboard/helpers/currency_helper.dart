String formatCurrency(double value) {
  if (value >= 1000000) {
    return 'Rp ${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    return 'Rp ${(value / 1000).toStringAsFixed(1)}K';
  } else {
    return 'Rp ${value.toStringAsFixed(0)}';
  }
}
import 'package:flutter/material.dart';
import '../utils/format_util.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;
  final double? width;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
    this.valueStyle,
    this.titleStyle,
    this.width,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalValueStyle =
        valueStyle ??
            TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: valueColor);
    final finalTitleStyle =
        titleStyle ?? const TextStyle(fontSize: 14, color: Colors.black54);

    String displayValue = value;
    // Cek apakah value bisa di-parse sebagai angka sebelum memformat
    if (num.tryParse(value) != null) {
      displayValue = formatShortNumber(value);
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  displayValue,
                  style: finalValueStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: finalTitleStyle,
                    ),
                  ),
                ),
                // --- AKHIR PERUBAHAN ---
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;
  final double? width;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
    this.valueStyle,
    this.titleStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final finalValueStyle =
        valueStyle ??
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor);
    final finalTitleStyle =
        titleStyle ?? const TextStyle(fontSize: 10, color: Colors.grey);

    return Container(
      width: width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(value, style: finalValueStyle, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(title, textAlign: TextAlign.center, style: finalTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}
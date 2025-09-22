import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;
  final double? width;
  final bool useFittedBox;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
    this.valueStyle,
    this.titleStyle,
    this.width,
    this.useFittedBox = false,
  });

  @override
  Widget build(BuildContext context) {
    final finalValueStyle = valueStyle ??
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (useFittedBox)
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: finalValueStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  value,
                  style: finalValueStyle,
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 4),
              if (useFittedBox)
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: finalTitleStyle,
                    ),
                  ),
                )
              else
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: finalTitleStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
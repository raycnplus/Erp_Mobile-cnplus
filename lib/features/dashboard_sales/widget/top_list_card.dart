import 'package:flutter/material.dart';

class TopListCard extends StatelessWidget {
  final String title;
  final List<List<String>> items; // List of [field1, field2, field3]

  const TopListCard({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Text('Customer', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Category', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Amount', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ...items.map((fields) => TableRow(
                  children: fields.map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(f),
                  )).toList(),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
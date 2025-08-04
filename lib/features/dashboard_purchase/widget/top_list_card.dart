import 'package:flutter/material.dart';
import '../models/purchase_models.dart';

class TopListCard extends StatelessWidget {
  final String title;
  final List<TopListData> items;

  const TopListCard({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Icon(Icons.inventory, color: Colors.grey.shade400),
                title: Text(item.title),
                trailing: Text(
                  item.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 1),
          ),
        ),
      ],
    );
  }
}
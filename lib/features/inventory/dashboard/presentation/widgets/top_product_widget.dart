import 'package:flutter/material.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/models/inventory_dashboard_model.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class TopProductList extends StatelessWidget {
  final List<InventoryTopProduct> topProducts;

  const TopProductList({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    if (topProducts.isEmpty) return const Text('No Products Available');

    final top5 = topProducts.take(5).toList();

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("QTY",     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
            const Divider(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: top5.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = top5[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.productName),
                      Text(
                        formatShortNumber(product.total),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
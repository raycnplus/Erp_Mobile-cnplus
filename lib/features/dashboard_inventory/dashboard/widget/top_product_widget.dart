import 'package:flutter/material.dart';
import '../models/dashboard_data_model.dart';
import '../utils/format_util.dart';

class TopProductList extends StatelessWidget {
  // Tipe data diubah menjadi List<TopProductData> untuk type-safety
  final List<TopProductData> topProducts;

  const TopProductList({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    if (topProducts.isEmpty) {
      return const Text('Tidak ada data produk');
    }

    // .take(5) tidak lagi diperlukan jika API sudah memberikannya
    // atau jika Anda ingin menampilkan semuanya.
    final top5Products = topProducts.take(5).toList();

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
                Text(
                  "Product",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "QTY",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: top5Products.length,
              itemBuilder: (context, index) {
                final product = top5Products[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mengakses properti model, bukan lagi key dari Map
                      Text(product.productName),
                      Text(
                        formatShortNumber(product.total),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          ],
        ),
      ),
    );
  }
}
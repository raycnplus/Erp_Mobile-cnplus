// lib/features/.../product_category/widget/product_category_skeleton.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCategorySkeleton extends StatelessWidget {
  const ProductCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Shimmer.fromColors untuk efek kilap
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 8, // Tampilkan 8 item skeleton
        physics: const NeverScrollableScrollPhysics(), // Non-aktifkan scroll
        itemBuilder: (context, index) {
          // Membangun satu card skeleton
          return _buildShimmerCard(context);
        },
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    // Container ini meniru bentuk card di list Anda
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Warna dasar card
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton untuk Teks Judul
          Container(
            width: MediaQuery.of(context).size.width * 0.7, // 70% lebar
            height: 16.0,
            decoration: BoxDecoration(
              color: Colors.grey, // Warna ini akan ditimpa shimmer
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(height: 8.0),
          // Skeleton untuk Teks Subjudul
          Container(
            width: MediaQuery.of(context).size.width * 0.4, // 40% lebar
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }
}
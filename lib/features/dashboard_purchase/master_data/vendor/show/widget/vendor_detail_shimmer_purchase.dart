// lib/ ... /purchase/widget/vendor_detail_shimmer_purchase.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// NAMA KELAS DIUBAH
class VendorDetailShimmerPurchase extends StatelessWidget {
  const VendorDetailShimmerPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer untuk Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBlock(height: 28, width: 250),
                  const SizedBox(height: 12),
                  _buildShimmerBlock(height: 16, width: 150),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Shimmer untuk TabBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShimmerBlock(height: 20, width: 80),
                  _buildShimmerBlock(height: 20, width: 80),
                  _buildShimmerBlock(height: 20, width: 80),
                ],
              ),
            ),
            // Shimmer untuk konten tab (Card dan ListTile)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerBlock(height: 22, width: 200, marginBottom: 16),
                  _buildShimmerListTile(),
                  _buildShimmerListTile(),
                  _buildShimmerListTile(),
                  const SizedBox(height: 24),
                  _buildShimmerBlock(height: 22, width: 180, marginBottom: 16),
                  _buildShimmerListTile(),
                  _buildShimmerListTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerListTile() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBlock(height: 40, width: 40, isCircle: true),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBlock(height: 12, width: 80),
              const SizedBox(height: 8),
              _buildShimmerBlock(height: 16, width: 180),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildShimmerBlock({
    required double height,
    required double width,
    bool isCircle = false,
    double marginBottom = 0,
  }) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isCircle ? height / 2 : 8),
      ),
    );
  }
}
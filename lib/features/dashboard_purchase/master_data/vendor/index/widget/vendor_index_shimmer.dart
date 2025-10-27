// Lokasi: purchase/vendor/widget/vendor_index_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VendorIndexShimmer extends StatelessWidget {
  const VendorIndexShimmer({super.key});

  // Helper untuk membuat kotak placeholder
  Widget _buildPlaceholder({
    required double height,
    double? width,
    bool isCircle = false,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isCircle ? null : BorderRadius.circular(4),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }

  // Helper untuk membuat satu item Card placeholder
  Widget _buildPlaceholderItem() {
    // Helper untuk membuat baris detail (Icon, Label, Value)
    Widget placeholderRow(double valueWidthFactor) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaceholder(height: 16, width: 16), // Icon
          const SizedBox(width: 8),
          SizedBox(width: 60, child: _buildPlaceholder(height: 14)), // Label
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: valueWidthFactor, // Mengontrol "panjang" teks
              child: _buildPlaceholder(height: 14),
            ),
          ),
        ],
      );
    }

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris 1: Judul dan Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildPlaceholder(
                        height: 18)), // Placeholder Judul Vendor
                const SizedBox(width: 8),
                _buildPlaceholder(
                    height: 10, width: 10, isCircle: true), // Status
              ],
            ),
            const Divider(height: 16, thickness: 0.5, color: Colors.transparent),

            // Baris 2: PIC
            placeholderRow(0.8), // Placeholder PIC (panjang 80%)
            const SizedBox(height: 8),

            // Baris 3: Email
            placeholderRow(1.0), // Placeholder Email (panjang 100%)
            const SizedBox(height: 8),

            // Baris 4: City
            placeholderRow(0.5), // Placeholder City (panjang 50%)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: IgnorePointer(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 7, // Tampilkan 7 placeholder item
          itemBuilder: (context, index) {
            return _buildPlaceholderItem();
          },
        ),
      ),
    );
  }
}
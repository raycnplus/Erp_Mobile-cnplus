import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LocationListShimmer extends StatelessWidget {
  final int itemCount;

  const LocationListShimmer({
    super.key,
    this.itemCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return _buildPlaceholderCard();
        },
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity, height: 20.0, color: Colors.white),
          const SizedBox(height: 12),
          Container(width: 180.0, height: 14.0, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: 150.0, height: 14.0, color: Colors.white),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ManufacturingDashboardShimmer extends StatelessWidget {
  const ManufacturingDashboardShimmer({super.key});

  Widget _box({double height = 20, double? width, double radius = 8}) =>
      Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: IgnorePointer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(height: 60),
              const SizedBox(height: 16),
              _box(height: 50, radius: 12),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _box(height: 90, radius: 12)),
                const SizedBox(width: 10),
                Expanded(child: _box(height: 90, radius: 12)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _box(height: 90, radius: 12)),
                const SizedBox(width: 10),
                Expanded(child: _box(height: 90, radius: 12)),
              ]),
              const SizedBox(height: 24),
              _box(height: 20, width: 150),
              const SizedBox(height: 8),
              _box(height: 240, radius: 12),
              const SizedBox(height: 24),
              _box(height: 20, width: 150),
              const SizedBox(height: 8),
              _box(height: 240, radius: 12),
              const SizedBox(height: 24),
              _box(height: 20, width: 150),
              const SizedBox(height: 8),
              _box(height: 200, radius: 12),
            ],
          ),
        ),
      ),
    );
  }
}
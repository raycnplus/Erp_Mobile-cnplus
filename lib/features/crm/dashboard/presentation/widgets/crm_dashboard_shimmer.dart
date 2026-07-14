import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CrmDashboardShimmer extends StatelessWidget {
  const CrmDashboardShimmer({super.key});

  Widget _box({double h = 20, double? w, double r = 8}) => Container(
        height: h,
        width: w ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(r),
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
              _box(h: 60, r: 12),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _box(h: 90, r: 12)),
                const SizedBox(width: 10),
                Expanded(child: _box(h: 90, r: 12)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _box(h: 90, r: 12)),
                const SizedBox(width: 10),
                Expanded(child: _box(h: 90, r: 12)),
              ]),
              const SizedBox(height: 10),
              _box(h: 90, r: 12),
              const SizedBox(height: 24),
              _box(h: 240, r: 12),
              const SizedBox(height: 16),
              _box(h: 240, r: 12),
            ],
          ),
        ),
      ),
    );
  }
}
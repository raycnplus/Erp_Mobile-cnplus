import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AccountingDashboardShimmer extends StatelessWidget {
  const AccountingDashboardShimmer({super.key});

  Widget _buildPlaceholder({
    required double height,
    double? width,
    double cornerRadius = 8.0,
    bool isCircle = false,
  }) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isCircle ? null : BorderRadius.circular(cornerRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: IgnorePointer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlaceholder(height: 60),
              const SizedBox(height: 16),
              
              _buildPlaceholder(height: 50, cornerRadius: 12),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _buildStatCardPlaceholder()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCardPlaceholder()),
                ],
              ),
              const SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(child: _buildStatCardPlaceholder()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCardPlaceholder()),
                ],
              ),
              const SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(child: _buildStatCardPlaceholder()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildStatCardPlaceholder()),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildChartPlaceholder(title: 'Revenue vs Expense'),
              const SizedBox(height: 24),
              
              _buildChartPlaceholder(title: 'Top 5 Revenue'),
              const SizedBox(height: 24),
              
              _buildChartPlaceholder(title: 'Top 5 Expense'),
              const SizedBox(height: 24),
              
              _buildAgingPlaceholder(title: 'Aging Piutang (Receivables)'),
              const SizedBox(height: 24),
              
              _buildAgingPlaceholder(title: 'Aging Utang (Payables)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCardPlaceholder() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            _buildPlaceholder(height: 20, width: 40),
            const SizedBox(height: 8),
            _buildPlaceholder(height: 14, width: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder({required String title}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlaceholder(height: 20, width: 150),
            const SizedBox(height: 16),
            _buildPlaceholder(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _buildAgingPlaceholder({required String title}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlaceholder(height: 20, width: 200),
            const SizedBox(height: 16),
            _buildPlaceholder(height: 150),
          ],
        ),
      ),
    );
  }
}
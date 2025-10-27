import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseDashboardShimmer extends StatelessWidget {
  const PurchaseDashboardShimmer({super.key});

  // Helper widget to create a standard placeholder box
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
        color: Colors.white, // This color is required by shimmer
        borderRadius: isCircle ? null : BorderRadius.circular(cornerRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }

  // Helper to build a placeholder for a list tile
  Widget _buildListTilePlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildPlaceholder(height: 40, width: 40, isCircle: true),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlaceholder(height: 16, width: double.infinity),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildPlaceholder(height: 16, width: 60),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The Shimmer.fromColors provides the animation effect
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: IgnorePointer(
        // Disable interaction while loading
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PersonalizedHeader Placeholder
              _buildPlaceholder(height: 60),
              const SizedBox(height: 16),

              // 2. GridView for StatCards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
                children: List.generate(
                  4,
                  (index) => Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPlaceholder(height: 22, width: 40),
                          const SizedBox(height: 8),
                          _buildPlaceholder(height: 14, width: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Chart Toggle Buttons Placeholder
              _buildPlaceholder(height: 45, cornerRadius: 12),
              const SizedBox(height: 16),

              // 4. Bar Chart Placeholder
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlaceholder(height: 20, width: 150), // Title
                      const SizedBox(height: 4),
                      _buildPlaceholder(height: 14, width: 100), // Legend
                      const SizedBox(height: 24),
                      _buildPlaceholder(height: 200), // Chart area
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Purchase Analysis Chart Placeholder
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlaceholder(height: 20, width: 180), // Title
                      const SizedBox(height: 4),
                      _buildPlaceholder(height: 14, width: 120), // Subtitle
                      const SizedBox(height: 24),
                      _buildPlaceholder(height: 200), // Chart area
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 6. TopListCard (Category) Placeholder
              _buildPlaceholder(height: 20, width: 200), // Title
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: List.generate(5, (index) {
                    return Column(
                      children: [
                        _buildListTilePlaceholder(),
                        if (index < 4)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // 7. TopListCard (Purchase Order) Placeholder
              _buildPlaceholder(height: 20, width: 200), // Title
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: List.generate(5, (index) {
                    return Column(
                      children: [
                        _buildListTilePlaceholder(),
                        if (index < 4)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
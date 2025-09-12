import 'package:flutter/material.dart';
import '../../brand/screen/brand_show_screen.dart';
import '../../brand/widget/brand_index_widget.dart';
import '../../brand/models/brand_index_models.dart';

class BrandIndexScreen extends StatelessWidget {
  const BrandIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brand")),
      body: BrandListWidget(
        onTap: (BrandIndexModel brand) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandShowScreen(brandId: brand.brandId),
            ),
          );
        },
      ),
    );
  }
}

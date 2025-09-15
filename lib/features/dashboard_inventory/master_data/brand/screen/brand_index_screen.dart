import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/brand/screen/brand_create_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/brand/widget/brand_create_form_widget.dart';
import 'package:flutter/material.dart';
import 'brand_show_screen.dart';
import '../widget/brand_index_widget.dart';
import '../models/brand_index_models.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BrandCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

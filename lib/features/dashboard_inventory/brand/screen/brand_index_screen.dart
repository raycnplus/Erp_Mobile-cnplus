import 'package:flutter/material.dart';
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
          // untuk sekarang cukup print dulu, nanti bisa diarahkan ke detail/create/edit
          debugPrint("Brand dipilih: ${brand.brandName} (ID: ${brand.id})");
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widget/update_widget_brand.dart';

class BrandUpdateScreen extends StatelessWidget {
  final int brandId;

  const BrandUpdateScreen({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Brand")),
      body: BrandUpdateWidget(brandId: brandId),
    );
  }
}

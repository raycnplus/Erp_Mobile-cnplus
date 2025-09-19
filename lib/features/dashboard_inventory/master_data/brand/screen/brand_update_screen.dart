import 'package:flutter/material.dart';
import '../widget/brand_update_widget.dart';

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

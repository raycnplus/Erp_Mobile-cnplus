import 'package:flutter/material.dart';
import '../widget/create_widget_brand.dart';

class BrandCreateScreen extends StatelessWidget {
  const BrandCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Brand")),
      body: const BrandCreateWidget(),
    );
  }
}

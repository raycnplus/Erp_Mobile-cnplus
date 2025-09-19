import 'package:flutter/material.dart';
import '../widget/brand_show_widget.dart';
import '../../brand/screen/brand_update_screen.dart';

class BrandShowScreen extends StatelessWidget {
  final int brandId;

  const BrandShowScreen({super.key, required this.brandId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Brand Detail")),
      body: BrandShowWidget(brandId: brandId),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandUpdateScreen(brandId: brandId),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

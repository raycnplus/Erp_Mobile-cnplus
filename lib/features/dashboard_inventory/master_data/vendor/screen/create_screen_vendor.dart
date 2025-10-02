import 'package:flutter/material.dart';
import '../widget/create_widget_vendor.dart';

class VendorCreateScreen extends StatelessWidget {
  const VendorCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Vendor")),
      body: const VendorCreateWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import '../widget/show_widget_vendor.dart';

class VendorShowScreen extends StatelessWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Show")),
      body: VendorDetailWidget(vendorId: vendorId),
    );
  }
}

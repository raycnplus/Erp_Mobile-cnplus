import 'package:flutter/material.dart';
import '../widget/update_widget_vendor.dart';

class VendorUpdateScreen extends StatelessWidget {
  final String vendorId;

  const VendorUpdateScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Vendor"),
      ),
      body: VendorUpdateWidget(vendorId: vendorId),
    );
  }
}

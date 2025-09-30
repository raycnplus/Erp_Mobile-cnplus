import 'package:flutter/material.dart';
import '../widget/index_widget_vendor.dart';

class VendorIndexScreen extends StatelessWidget {
  const VendorIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor"),
      ),
      body: const VendorIndexWidget(),
    );
  }
}

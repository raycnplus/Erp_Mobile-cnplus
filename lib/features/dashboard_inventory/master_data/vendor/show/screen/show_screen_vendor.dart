import 'package:flutter/material.dart';
import '../widget/show_widget_vendor.dart';

class VendorShowScreen extends StatelessWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    // Scaffold hanya membungkus widget detail
    return Scaffold(
      // AppBar dihapus, akan dihandle di VendorDetailWidget
      body: VendorDetailWidget(vendorId: vendorId),
    );
  }
}
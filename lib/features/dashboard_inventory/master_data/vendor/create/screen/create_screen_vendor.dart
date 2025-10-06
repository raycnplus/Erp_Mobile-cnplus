import 'package:flutter/material.dart';
import '../widget/create_widget_vendor.dart';

class VendorCreateScreen extends StatelessWidget {
  const VendorCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The Scaffold and AppBar are now part of the widget itself
    return const VendorCreateWidget();
  }
}
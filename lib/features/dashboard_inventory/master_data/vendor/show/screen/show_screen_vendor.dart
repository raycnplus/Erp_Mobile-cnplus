import 'package:flutter/material.dart';
import '../widget/show_widget_vendor.dart';
import '../../update/screen/update_screen_vendor.dart'; // pastikan path sesuai

class VendorShowScreen extends StatefulWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  State<VendorShowScreen> createState() => _VendorShowScreenState();
}

class _VendorShowScreenState extends State<VendorShowScreen> {
  bool refreshTrigger = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Show")),

      body: VendorDetailWidget(
        vendorId: widget.vendorId,
        key: ValueKey(refreshTrigger),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Edit Vendor",
        child: const Icon(Icons.edit),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorUpdateScreen(
                vendorId: widget.vendorId,
              ),
            ),
          );

          if (result == true) {
            setState(() => refreshTrigger = !refreshTrigger);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Vendor berhasil diperbarui")),
            );
          }
        },
      ),
    );
  }
}

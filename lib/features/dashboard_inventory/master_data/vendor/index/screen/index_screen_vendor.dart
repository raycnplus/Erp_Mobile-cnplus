import 'package:flutter/material.dart';
import '../widget/index_widget_vendor.dart';
import '../../create/screen/create_screen_vendor.dart';

class VendorIndexScreen extends StatelessWidget {
  const VendorIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vendor"),
      ),
      body: const VendorIndexWidget(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // warna FAB
        foregroundColor: Colors.white,
        onPressed: () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VendorCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

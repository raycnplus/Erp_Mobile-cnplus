import 'package:flutter/material.dart';
import '../widget/index_widget_vendor_purchase.dart';
import '../../create/screen/create_screen_vendor_purchase.dart';

class VendorIndexScreen extends StatelessWidget {
  const VendorIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor")),
      body: const VendorIndexWidget(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // warna FAB
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VendorCreateScreen()),
          );

          
          if (result == true) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorIndexScreen(),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

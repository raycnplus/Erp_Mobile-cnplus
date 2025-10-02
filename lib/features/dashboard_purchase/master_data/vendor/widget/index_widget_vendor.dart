import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/index_models_vendor.dart';
import '../screen/show_screen_vendor.dart';
import '../screen/create_screen_vendor.dart'; // Import VendorCreateScreen

class VendorIndexWidget extends StatefulWidget {
  const VendorIndexWidget({super.key});

  @override
  State<VendorIndexWidget> createState() => _VendorIndexWidgetState();
}

class _VendorIndexWidgetState extends State<VendorIndexWidget> {
  final storage = const FlutterSecureStorage();
  List<VendorIndexModel> vendors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  Future<void> fetchVendors() async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/purchase/vendor/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          vendors = data.map((e) => VendorIndexModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load vendors");
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteVendor(int idVendor) async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse("${ApiBase.baseUrl}/inventory/vendor/$idVendor"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          vendors.removeWhere((vendor) => vendor.idVendor == idVendor);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Vendor deleted successfully")),
        );
      } else {
        throw Exception("Failed to delete vendor");
      }
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Error deleting vendor")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (vendors.isEmpty)
          const Center(child: Text("No vendor data available"))
        else
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VendorShowScreen(vendorId: vendor.idVendor.toString()),
                      ),
                    );
                  },
                  title: Text(vendor.vendorName.isNotEmpty ? vendor.vendorName : "-"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${vendor.email.isNotEmpty ? vendor.email : "-"}"),
                      Text("PIC: ${vendor.contactPersonName.isNotEmpty ? vendor.contactPersonName : "-"}"),
                      Text("City: ${vendor.city.isNotEmpty ? vendor.city : "-"}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: Text("Are you sure you want to delete ${vendor.vendorName}?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                deleteVendor(vendor.idVendor);
                              },
                              child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

        // FAB di pojok kanan bawah
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VendorCreateScreen()),
              );

              if (result == true) {
                fetchVendors(); // refresh otomatis setelah create
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// show_screen_vendor.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Tambahkan import
import 'dart:convert'; // Tambahkan import
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Tambahkan import

import '../../../../../../../services/api_base.dart'; // Pastikan path sesuai
import '../widget/show_widget_vendor.dart';
import '../../update/screen/update_screen_vendor.dart';

class VendorShowScreen extends StatefulWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  State<VendorShowScreen> createState() => _VendorShowScreenState();
}

class _VendorShowScreenState extends State<VendorShowScreen> {
  // refreshTrigger digunakan untuk me-refresh widget detail setelah update
  bool refreshTrigger = false;
  // hasChanged digunakan untuk memberitahu halaman index agar refresh setelah delete/update
  bool hasChanged = false;

  static const Color accentColor = Color(0xFF2D6A4F);

  // --- LOGIKA BARU UNTUK DELETE ---

  Future<bool> _deleteVendor() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/inventory/vendor/${widget.vendorId}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<void> _confirmAndDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete this vendor? This action cannot be undone.', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final success = await _deleteVendor();
        if (mounted) Navigator.pop(context); // Tutup loading

        if (success) {
          setState(() { hasChanged = true; });
          if (mounted) Navigator.pop(context, true); // Kembali ke halaman index & trigger refresh
        } else {
          throw Exception("Failed to delete vendor.");
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengganti WillPopScope dengan PopScope yang lebih modern
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.pop(context, hasChanged);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context, hasChanged),
          ),
          title: const Text("Vendor Details"),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
          actions: [
            // --- TOMBOL DELETE DITAMBAHKAN DI SINI ---
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmAndDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: VendorDetailWidget(
          vendorId: widget.vendorId,
          key: ValueKey(refreshTrigger),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Edit Vendor",
          backgroundColor: accentColor,
          child: const Icon(Icons.edit, color: Colors.white),
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
              setState(() {
                refreshTrigger = !refreshTrigger;
                hasChanged = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Vendor updated successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
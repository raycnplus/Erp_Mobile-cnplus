import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../../services/api_base.dart';
import '../widget/show_widget_vendor.dart';
import '../../update/screen/update_screen_vendor.dart';

class VendorShowScreen extends StatefulWidget {
  final String vendorId;

  const VendorShowScreen({super.key, required this.vendorId});

  @override
  State<VendorShowScreen> createState() => _VendorShowScreenState();
}

class _VendorShowScreenState extends State<VendorShowScreen> {
  bool refreshTrigger = false;
  bool hasChanged = false;

  static const Color accentColor = Color(0xFF2D6A4F);
  static const Color lightGreyColor = Color(0xFFF7F9FC);

  Future<bool> _deleteVendor() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) return false;

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

    if (confirmed != true) return;

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    try {
      final success = await _deleteVendor();
      if (mounted) Navigator.pop(context); // Tutup loading

      if (success) {
        if (mounted) {
          // Kirim 'true' ke halaman index setelah delete
          Navigator.pop(context, true); 
        }
      } else {
        throw Exception("Failed to delete vendor.");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.pop(context, hasChanged);
      },
      child: Scaffold(
        backgroundColor: lightGreyColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context, hasChanged),
          ),
          title: const Text("Vendor Details"),
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: const IconThemeData(color: accentColor),
          titleTextStyle: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
          actions: [
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
          foregroundColor: Colors.white,
          child: const Icon(Icons.edit),
          onPressed: () async {
            final resultFromUpdate = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => VendorUpdateScreen(
                  vendorId: widget.vendorId,
                ),
              ),
            );

            // JIKA UPDATE SUKSES, LANGSUNG KEMBALI KE INDEX
            if (resultFromUpdate == true && mounted) {
              // 'true' akan ditangkap oleh halaman index untuk refresh & show bottom sheet
              Navigator.pop(context, true);
            } else {
              // Jika update tidak terjadi atau dibatalkan, muat ulang data detail
              // untuk memastikan data tetap fresh jika ada perubahan kecil.
              setState(() {
                refreshTrigger = !refreshTrigger;
              });
            }
          },
        ),
      ),
    );
  }
}
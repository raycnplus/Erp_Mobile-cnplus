import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../services/api_base.dart';
import '../models/index_models_vendor.dart';
import '../../show/screen/show_screen_vendor.dart';

class VendorIndexWidget extends StatefulWidget {
  // Callback untuk memberitahu parent bahwa update berhasil
  final VoidCallback? onUpdateSuccess;

  const VendorIndexWidget({super.key, this.onUpdateSuccess});

  @override
  // [PERBAIKAN]: Nama state diubah menjadi public
  State<VendorIndexWidget> createState() => VendorIndexWidgetState();
}

// [PERBAIKAN]: Nama class state diubah menjadi public (tanpa underscore)
class VendorIndexWidgetState extends State<VendorIndexWidget> {
  final storage = const FlutterSecureStorage();
  List<VendorIndexModel> vendors = [];
  bool isLoading = true;
  String? errorMessage;

  static const Color primaryAccent = Color(0xFF2D6A4F);

  @override
  void initState() {
    super.initState();
    fetchVendors();
  }

  // Fungsi ini sekarang bisa dipanggil dari parent via GlobalKey
  Future<void> reloadData() async {
    setState(() {
      isLoading = true;
    });
    await fetchVendors();
  }

  Future<void> fetchVendors() async {
    try {
      String? token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/vendor/"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            vendors = data.map((e) => VendorIndexModel.fromJson(e)).toList();
            isLoading = false;
            errorMessage = null;
          });
        }
      } else {
        throw Exception("Failed to load vendors: Status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  // Fungsi onTap sekarang async untuk menunggu hasil dari halaman show/update
  void _navigateToDetail(String vendorId) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => VendorShowScreen(
          vendorId: vendorId,
        ),
      ),
    );

    // Jika hasil dari show/update screen adalah true (sukses)
    if (result == true) {
      widget.onUpdateSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text("Error: $errorMessage"));
    }

    if (vendors.isEmpty) {
      return Center(
        child: Text(
          "No vendor data available",
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchVendors,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          final vendor = vendors[index];
          Color statusColor =
              vendor.email.isNotEmpty ? primaryAccent : Colors.orange.shade600;

          return Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                _navigateToDetail(vendor.idVendor.toString());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            vendor.vendorName.isNotEmpty
                                ? vendor.vendorName
                                : "No Name Provided",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: statusColor,
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 0.5),
                    _buildDetailRow(Icons.person_outline, "PIC",
                        vendor.contactPersonName,
                        color: Colors.grey.shade700),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.email_outlined, "Email", vendor.email,
                        color: primaryAccent),
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.location_city_outlined, "City",
                        vendor.city,
                        color: Colors.blueGrey.shade600),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    String safeValue = value.isNotEmpty && value != '-' ? value : "-";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey.shade500),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            "$label:",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            safeValue,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: color ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Tambahkan Google Fonts
import '../../../../../../../services/api_base.dart';
import '../models/show_models_vendor.dart';

class VendorDetailWidget extends StatefulWidget {
  final String vendorId;

  const VendorDetailWidget({super.key, required this.vendorId});

  @override
  State<VendorDetailWidget> createState() => _VendorDetailWidgetState();
}

class _VendorDetailWidgetState extends State<VendorDetailWidget> with SingleTickerProviderStateMixin {
  final storage = const FlutterSecureStorage();
  VendorShowModel? vendor;
  bool isLoading = true;
  String? errorMessage;
  
  late TabController _tabController;

  // Warna Aksen
  static const Color accentColor = Color(0xFF2D6A4F); // Hijau Tua

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 Tab
    fetchVendor();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- LOGIKA FETCH DATA ---
  Future<void> fetchVendor() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        if(mounted) setState(() { errorMessage = "Token tidak ditemukan"; isLoading = false; });
        return;
      }

      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/vendor/${widget.vendorId}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            vendor = VendorShowModel.fromJson(data);
            isLoading = false;
          });
        }
      } else {
        if(mounted) setState(() {
          errorMessage = "Gagal memuat data: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      if(mounted) setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }
  
  // Helper untuk menampilkan nilai yang aman
  String safe(dynamic value) {
    if (value == null || value.toString().isEmpty || value.toString() == "null") return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text("Error: $errorMessage"));
    }
    if (vendor == null) {
      return const Center(child: Text("Data tidak ditemukan"));
    }

    // Ambil vendor data setelah loading selesai
    final v = vendor!;

    return Column(
      children: [
        // 1. HEADER VENDOR (Nama & Kode)
        _buildVendorHeader(v),
        
        // 2. TAB BAR
        TabBar(
          controller: _tabController,
          indicatorColor: accentColor,
          labelColor: accentColor,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: "General"),
            Tab(text: "Contact & Addr"),
            Tab(text: "Financial"),
          ],
        ),
        
        // 3. TAB VIEW (Konten)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGeneralInfoTab(v),
              _buildContactAddressTab(v),
              _buildFinancialTab(v),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET BUILDERS ---
  
  Widget _buildVendorHeader(VendorShowModel vendor) {
    // Tentukan warna status
    Color statusColor = vendor.status?.toLowerCase() == 'active' ? accentColor : Colors.red.shade700;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama Vendor
          Text(
            safe(vendor.vendorName),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kode Vendor
              Row(
                children: [
                  Icon(Icons.badge, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    safe(vendor.vendorCode),
                    style: GoogleFonts.roboto(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Status Chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  safe(vendor.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildField("Category", safe(vendor.categoryVendor)),
        _buildField("Product Type", safe(vendor.productType)),
        _buildField("Status", safe(vendor.status)),
        
        const Divider(height: 30),
        _buildTitleSection("Audit Log"),
        _buildField("Created By", safe(vendor.createdBy)),
        _buildField("Created Date", safe(vendor.createdDate)),
        _buildField("Updated By", safe(vendor.updatedBy)),
        _buildField("Updated Date", safe(vendor.updatedDate)),
        _buildField("Deleted Status", safe(vendor.isDelete)),
      ],
    );
  }

  Widget _buildContactAddressTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTitleSection("Primary Contact"),
        _buildField("Phone", safe(vendor.phoneNo)),
        _buildField("Email", safe(vendor.email)),

        const Divider(height: 30),
        _buildTitleSection("Contact Person (PIC)"),
        _buildField("PIC Name", safe(vendor.contactPersonName)),
        _buildField("PIC Phone", safe(vendor.contactPersonPhone)),
        _buildField("PIC Email", safe(vendor.contactPersonEmail)),
        
        const Divider(height: 30),
        _buildTitleSection("Address"),
        _buildField("Address Line", safe(vendor.address)),
        _buildField("City", safe(vendor.city)),
        _buildField("Province", safe(vendor.province)),
        _buildField("Postal Code", safe(vendor.postalCode)),
        _buildField("Country", safe(vendor.country)),
      ],
    );
  }

  Widget _buildFinancialTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTitleSection("Tax & Currency"),
        _buildField("NPWP Number", safe(vendor.npwpNumber)),
        _buildField("Currency", safe(vendor.currency)),
        _buildField("Support Document", safe(vendor.supportDocument)),

        const Divider(height: 30),
        _buildTitleSection("Bank Account Details"),
        _buildField("Bank Name", safe(vendor.bankName)),
        _buildField("Account Name", safe(vendor.bankAccountName)),
        _buildField("Account Number", safe(vendor.bankAccountNumber)),
      ],
    );
  }

  // Widget untuk Title Section di dalam Tab
  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: accentColor,
        ),
      ),
    );
  }

  // Widget Field Detail yang konsisten
  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
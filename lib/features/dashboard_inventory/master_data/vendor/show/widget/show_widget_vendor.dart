import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
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
  late Future<VendorShowModel> _futureVendor;
  late TabController _tabController;

  // Warna Aksen
  static const Color accentColor = Color(0xFF2D6A4F); // Hijau Tua
  static const Color deleteColor = Color(0xFFE74C3C); // Merah

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _futureVendor = fetchVendor();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<VendorShowModel> fetchVendor() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/inventory/vendor/${widget.vendorId}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Asumsi data utama berada di bawah key 'data' atau langsung di root
      return VendorShowModel.fromJson(data['data'] ?? data);
    } else {
      throw Exception("Gagal memuat data: ${response.body}");
    }
  }

  // Helper untuk menampilkan nilai yang aman
  String safe(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VendorShowModel>(
      future: _futureVendor,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Data vendor tidak ditemukan"));
        }

        final vendor = snapshot.data!;

        // Dapatkan padding bottom dari sistem (safe area/gesture bar height)
        final double bottomPadding = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Vendor Details"),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),

          body: Stack(
            children: [
              // Konten Utama (Header, Tabs, TabView)
              Column(
                children: [
                  // 1. HEADER VENDOR (Nama & Kode)
                  _buildVendorHeader(vendor),

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
                        _buildGeneralInfoTab(vendor),
                        _buildContactAddressTab(vendor),
                        _buildFinancialTab(vendor),
                      ],
                    ),
                  ),

                  // Tambahkan ruang di bagian bawah agar tombol aksi tidak menutupi konten
                  SizedBox(height: 70 + bottomPadding),
                ],
              ),

              // 4. FLOATING ACTION BUTTONS (Diletakkan di bagian bawah Stack)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                // Menggunakan widget builder untuk memastikan tombol selalu di atas
                child: _buildActionButtons(context, vendor.idVendor, bottomPadding),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Widget Builders ---

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

  // Widget Field Detail yang konsisten (dari desain produk)
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

  // Tombol aksi dipindah dari bottomNavigationBar
  Widget _buildActionButtons(BuildContext context, int? vendorId, double systemPaddingBottom) {
    return Container(
      // Padding atas 12, Padding bawah menyesuaikan safe area + sedikit ruang
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + systemPaddingBottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tombol Delete
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementasi logika Delete
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Aksi Delete Vendor ID: ${vendorId ?? '-'}"))
                );
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: deleteColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Edit
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementasi logika Edit
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Aksi Edit Vendor ID: ${vendorId ?? '-'}"))
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
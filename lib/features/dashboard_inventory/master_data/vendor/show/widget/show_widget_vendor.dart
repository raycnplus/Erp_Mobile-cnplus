import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../services/api_base.dart';
import '../models/show_models_vendor.dart';
import 'vendor_detail_shimmer.dart';

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

  static const Color accentColor = Color(0xFF2D6A4F);
  static const Color lightGreyColor = Color(0xFFF7F9FC);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchVendor();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchVendor() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        if(mounted) setState(() { errorMessage = "Token not found. Please log in again."; isLoading = false; });
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
          final errorBody = jsonDecode(response.body);
          errorMessage = "Failed to load data: ${errorBody['message'] ?? response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      if(mounted) setState(() {
        errorMessage = "An error occurred: ${e.toString()}";
        isLoading = false;
      });
    }
  }
  
  String safe(dynamic value) {
    if (value == null || value.toString().isEmpty || value.toString() == "null") return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const VendorDetailShimmer();
    }
    
    if (errorMessage != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(errorMessage!, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.red.shade700)),
      ));
    }
    if (vendor == null) {
      return const Center(child: Text("Data not found"));
    }

    final v = vendor!;

    return Container(
      color: lightGreyColor,
      child: Column(
        children: [
          _buildVendorHeader(v),
          CustomTabBar(
            controller: _tabController,
            activeColor: accentColor,
            inactiveColor: Colors.grey.shade600,
            backgroundColor: Colors.white,
            tabs: const [
              Tab(text: "General"),
              Tab(text: "Contact"),
              Tab(text: "Financial"),
            ],
          ),
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
      ),
    );
  }
  
  Widget _buildVendorHeader(VendorShowModel vendor) {
    Color statusColor = vendor.status?.toLowerCase() == 'active' ? accentColor : Colors.red.shade700;
    
    return Material(
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              safe(vendor.vendorName),
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.qr_code_2, size: 16, color: accentColor.withOpacity(0.8)),
                    const SizedBox(width: 6),
                    Text(
                      safe(vendor.vendorCode),
                      style: GoogleFonts.robotoMono(color: accentColor, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    safe(vendor.status).toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfoTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: "General Information",
          children: [
            _buildInfoTile(Icons.category_outlined, "Category", safe(vendor.categoryVendor)),
            _buildInfoTile(Icons.inventory_2_outlined, "Product Type", safe(vendor.productType)),
            _buildInfoTile(Icons.toggle_on_outlined, "Status", safe(vendor.status)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: "Audit Log",
          children: [
            _buildInfoTile(Icons.person_outline, "Created By", safe(vendor.createdBy)),
            _buildInfoTile(Icons.calendar_today_outlined, "Created Date", safe(vendor.createdDate)),
            _buildInfoTile(Icons.edit_outlined, "Updated By", safe(vendor.updatedBy)),
            _buildInfoTile(Icons.history_outlined, "Updated Date", safe(vendor.updatedDate)),
          ],
        ),
      ],
    );
  }

  Widget _buildContactAddressTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: "Contact Person (PIC)",
          children: [
            _buildInfoTile(Icons.person_pin_outlined, "PIC Name", safe(vendor.contactPersonName)),
            _buildInfoTile(Icons.phone_outlined, "PIC Phone", safe(vendor.contactPersonPhone)),
            _buildInfoTile(Icons.email_outlined, "PIC Email", safe(vendor.contactPersonEmail)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: "Company Address",
          children: [
            _buildInfoTile(Icons.location_on_outlined, "Address Line", safe(vendor.address)),
            _buildInfoTile(Icons.location_city_outlined, "City", safe(vendor.city)),
            _buildInfoTile(Icons.map_outlined, "Province", safe(vendor.province)),
            _buildInfoTile(Icons.markunread_mailbox_outlined, "Postal Code", safe(vendor.postalCode)),
            _buildInfoTile(Icons.public_outlined, "Country", safe(vendor.country)),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialTab(VendorShowModel vendor) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoCard(
          title: "Tax & Currency",
          children: [
            _buildInfoTile(Icons.receipt_long_outlined, "NPWP Number", safe(vendor.npwpNumber)),
            _buildInfoTile(Icons.attach_money_outlined, "Currency", safe(vendor.currency)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          title: "Bank Account",
          children: [
            _buildInfoTile(Icons.account_balance_outlined, "Bank Name", safe(vendor.bankName)),
            _buildInfoTile(Icons.person_search_outlined, "Account Name", safe(vendor.bankAccountName)),
            _buildInfoTile(Icons.credit_card_outlined, "Account Number", safe(vendor.bankAccountNumber)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: accentColor,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: accentColor, size: 24),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Widget kustom untuk TabBar dengan desain "Pill" atau "Toggle Button"
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Tab> tabs;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.backgroundColor,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: activeColor,
          boxShadow: [
            BoxShadow(
              color: activeColor.withOpacity(0.4), 
              spreadRadius: 2,                     
              blurRadius: 8,                      
              offset: const Offset(0, 4),         
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: inactiveColor,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
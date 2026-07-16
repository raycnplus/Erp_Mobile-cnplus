import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/models/vendor_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class VendorDetailTabs extends StatefulWidget {
  final VendorDetailModel vendorDetail;

  const VendorDetailTabs({super.key, required this.vendorDetail});

  @override
  State<VendorDetailTabs> createState() => _VendorDetailTabsState();
}

class _VendorDetailTabsState extends State<VendorDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendorDetail.vendor;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
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
              _buildGeneralTab(vendor),
              _buildContactTab(vendor),
              _buildFinancialTab(vendor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralTab(VendorData vendor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard("General Information", Icons.info_outline, {
            "Vendor Name": _safe(vendor.vendorName),
            "Vendor Code": _safe(vendor.vendorCode),
            "NPWP": _safe(vendor.npwpNumber),
          }),
          const SizedBox(height: 16),
          _buildCard("Audit Trail", Icons.history, {
            "Created By": _safe(widget.vendorDetail.createdByName),
            "Created On": _formatDate(vendor.createdDate),
            "Updated By": _safe(widget.vendorDetail.updatedByName),
            "Updated On": _formatDate(vendor.updatedDate),
          }),
        ],
      ),
    );
  }

  Widget _buildContactTab(VendorData vendor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard("Company Contact", Icons.business, {
            "Phone": _safe(vendor.phoneNo),
            "Email": _safe(vendor.email),
          }),
          const SizedBox(height: 16),
          _buildCard("Contact Person (PIC)", Icons.person, {
            "Name": _safe(vendor.contactPersonName),
            "Phone": _safe(vendor.contactPersonPhone),
            "Email": _safe(vendor.contactPersonEmail),
          }),
          const SizedBox(height: 16),
          _buildCard("Address", Icons.location_on, {
            "Street": _safe(vendor.address),
            "City": _safe(vendor.city),
            "Province": _safe(vendor.province),
            "Postal Code": _safe(vendor.postalCode),
            "Country": _safe(vendor.countryName),
          }),
        ],
      ),
    );
  }

  Widget _buildFinancialTab(VendorData vendor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard("Tax & Currency", Icons.receipt_long, {
            "Currency": _safe(vendor.currencyName),
          }),
          const SizedBox(height: 16),
          _buildCard("Bank Account", Icons.account_balance, {
            "Bank Name": _safe(vendor.bankName),
            "Account Name": _safe(vendor.bankAccountName),
            "Account Number": _safe(vendor.bankAccountNumber),
          }),
        ],
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, Map<String, String> details) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextPrimary)),
            ]),
            const Divider(height: 24),
            ...details.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key,
                          style: GoogleFonts.poppins(
                              color: colorTextSubtle, fontSize: 14)),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(e.value,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: colorTextPrimary,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
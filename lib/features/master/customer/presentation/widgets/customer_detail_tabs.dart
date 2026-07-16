import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/models/customer_models.dart';

class CustomerDetailTabs extends StatefulWidget {
  final CustomerDetailModel customerDetail;
  const CustomerDetailTabs({super.key, required this.customerDetail});

  @override
  State<CustomerDetailTabs> createState() => _CustomerDetailTabsState();
}

class _CustomerDetailTabsState extends State<CustomerDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) { return d; }
  }

  String _safe(dynamic v) {
    if (v == null || v.toString().isEmpty) return '-';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.customerDetail.customer;
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: "General"), Tab(text: "Audit Trail")],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Customer Info", Icons.person_outline, {
                      "Name": _safe(c.customerName),
                      "Code": _safe(c.customerCode),
                      "Type": _safe(c.customerType),
                    }),
                    const SizedBox(height: 16),
                    _card("Contact", Icons.contact_phone_outlined, {
                      "Email": _safe(c.email),
                      "Phone": _safe(c.phoneNo),
                      "Website": _safe(c.website),
                    }),
                    const SizedBox(height: 16),
                    _card("Address", Icons.location_on_outlined, {
                      "Address": _safe(c.address),
                      "City": _safe(c.city),
                      "Province": _safe(c.province),
                      "Country": _safe(c.country),
                      "Postal Code": _safe(c.postalCode),
                    }),
                    const SizedBox(height: 16),
                    _card("Person in Charge", Icons.person_pin_outlined, {
                      "Name": _safe(c.picName),
                      "Phone": _safe(c.picPhone),
                      "Email": _safe(c.picEmail),
                    }),
                    if (c.npwp?.isNotEmpty == true || c.isVatRegistered) ...[
                      const SizedBox(height: 16),
                      _card("Tax Info", Icons.receipt_outlined, {
                        "NPWP": _safe(c.npwp),
                        "VAT Registered": c.isVatRegistered ? "Yes" : "No",
                      }),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Creation", Icons.add_circle_outline, {
                      "Created By":
                          _safe(widget.customerDetail.createdByName),
                      "Created On": _formatDate(c.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card("Last Update", Icons.update_outlined, {
                      "Updated By":
                          _safe(widget.customerDetail.updatedByName),
                      "Updated On": _formatDate(c.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> details) {
    final filtered = {
      for (final e in details.entries) if (e.value != '-') e.key: e.value
    };
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            ...filtered.entries.map((e) => Padding(
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';

class ProductTypeDetailTabs extends StatelessWidget {
  final ProductTypeDetailModel typeDetail;

  const ProductTypeDetailTabs({super.key, required this.typeDetail});

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return "-";
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) { return d; }
  }

  String _safe(dynamic v) {
    if (v == null || v.toString().isEmpty) return "-";
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("Audit Trail",
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorTextPrimary)),
          ),
          const SizedBox(height: 12),
          _buildDetailsCard("Creation", Icons.add_circle_outline, {
            "Created By": _safe(typeDetail.createdByName),
            "Created On": _formatDate(typeDetail.productType.createdDate),
          }),
          const SizedBox(height: 12),
          _buildDetailsCard("Last Update", Icons.update_outlined, {
            "Updated By": _safe(typeDetail.updatedByName),
            "Updated On": _formatDate(typeDetail.productType.updatedDate),
          }),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.category, color: colorPrimary, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                typeDetail.productType.productTypeName,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String title, IconData icon, Map<String, String> details) {
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
              Icon(icon, color: colorTextSubtle, size: 20),
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
                    children: [
                      Text(e.key,
                          style: GoogleFonts.poppins(
                              color: colorTextSubtle, fontSize: 14)),
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
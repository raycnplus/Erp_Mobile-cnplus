import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart'; // ← SATU file ini saja
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BrandDetailTabs extends StatelessWidget {
  final BrandDetailModel brandDetail;

  const BrandDetailTabs({super.key, required this.brandDetail});

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('d MMMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  String _safe(dynamic value) {
    if (value == null || value.toString().isEmpty) return "-";
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: brandDetail.brand.brandName,
            subtitle: brandDetail.brand.brandCode,
            icon: Icons.workspace_premium_outlined,
            iconColor: colorAccent,
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Audit Trail",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildDetailsCard(
            title: "Creation",
            icon: Icons.add_circle_outline,
            details: {
              "Created By": _safe(brandDetail.createdByName),
              "Created On": _formatDate(brandDetail.brand.createdDate),
            },
          ),
          const SizedBox(height: 12),

          _buildDetailsCard(
            title: "Last Update",
            icon: Icons.update_outlined,
            details: {
              "Updated By": _safe(brandDetail.updatedByName),
              "Updated On": _formatDate(brandDetail.brand.updatedDate),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: colorTextSubtle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard({
    required String title,
    required IconData icon,
    required Map<String, String> details,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorTextSubtle, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                          color: colorTextSubtle, fontSize: 14),
                    ),
                    Flexible(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class AccountingTopCustomerCard extends StatelessWidget {
  final String title;
  final List<SalesBreakdownData> items;

  const AccountingTopCustomerCard({super.key, required this.title, required this.items});

  static const Color mainColor = Color(0xFF029379);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: mainColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('No data available',
                    style: GoogleFonts.poppins(color: Colors.grey.shade500)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isLast = index == items.length - 1;

                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatCurrency(item.totalSales),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: mainColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (!isLast) const Divider(height: 1, indent: 64, endIndent: 16),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
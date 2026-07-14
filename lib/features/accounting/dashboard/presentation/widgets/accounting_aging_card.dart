import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/models/accounting_dashboard_models.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class AccountingAgingCard extends StatelessWidget {
  final String title;
  final List<AgingData> items;
  final bool isReceivable;
  
  static const Color mainColor = Color(0xFF029379);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color dangerColor = Color(0xFFE53935);

  const AccountingAgingCard({
    super.key,
    required this.title,
    required this.items,
    this.isReceivable = true,
  });

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
                child: Text(
                  'No aging data available',
                  style: GoogleFonts.poppins(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 16,
                headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => mainColor.withOpacity(0.05),
                ),
                columns: [
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Text(
                        isReceivable ? 'Customer' : 'Vendor',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        '1-6 bln',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        '6-12 bln',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: warningColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        '12-24 bln',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: dangerColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text(
                        '>24 bln',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: dangerColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Total',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: mainColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
                rows: items.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            item.customerName,
                            style: GoogleFonts.poppins(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            formatCurrency(item.bln1_6),
                            style: GoogleFonts.poppins(fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            formatCurrency(item.bln6_12),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: item.bln6_12 > 0 ? warningColor : null,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            formatCurrency(item.bln12_24),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: item.bln12_24 > 0 ? dangerColor : null,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 100,
                          child: Text(
                            formatCurrency(item.bln24Plus),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: item.bln24Plus > 0 ? dangerColor : null,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 120,
                          child: Text(
                            formatCurrency(item.total),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: mainColor,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
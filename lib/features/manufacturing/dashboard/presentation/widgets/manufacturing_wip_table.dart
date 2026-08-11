import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/models/manufacturing_dashboard_models.dart';

class ManufacturingWipTable extends StatelessWidget {
  final List<WorkInProgressItem> items;

  const ManufacturingWipTable({super.key, required this.items});

  static const Color _theme = Color(0xFF2D6A4F);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
      case 'completed':
        return Colors.green.shade700;
      case 'in_progress':
        return const Color(0xFF0277BD);
      case 'confirmed':
        return const Color(0xFF6A1B9A);
      case 'pending':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress': return 'In Progress';
      case 'confirmed': return 'Confirmed';
      case 'pending': return 'Pending';
      case 'done': return 'Done';
      case 'completed': return 'Completed';
      default: return status;
    }
  }

  String _fmtDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMM yyyy HH:mm').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _theme.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.precision_manufacturing_outlined,
                    color: _theme,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Work in Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No work in progress',
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
                  (_) => _theme.withOpacity(0.07),
                ),
                headingTextStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.black87,
                ),
                columns: const [
                  DataColumn(label: Text('Reference')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Scheduled')),
                  DataColumn(label: Text('Status')),
                ],
                rows: items.map((item) => DataRow(cells: [
                  DataCell(Text(
                    item.reference,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _theme,
                    ),
                  )),
                  DataCell(SizedBox(
                    width: 130,
                    child: Text(
                      item.productName,
                      style: GoogleFonts.poppins(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  DataCell(Text(
                    item.plannedQty % 1 == 0
                        ? item.plannedQty.toInt().toString()
                        : item.plannedQty.toStringAsFixed(2),
                    style: GoogleFonts.poppins(fontSize: 13),
                  )),
                  DataCell(Text(
                    _fmtDate(item.scheduledDate),
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade700),
                  )),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(item.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(item.status),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(item.status),
                      ),
                    ),
                  )),
                ])).toList(),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
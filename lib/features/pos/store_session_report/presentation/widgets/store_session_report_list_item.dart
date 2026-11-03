import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class StoreSessionReportListItem extends StatelessWidget {
  final StoreSessionItem item;
  final VoidCallback onTap;

  const StoreSessionReportListItem({super.key, required this.item, required this.onTap});

  Widget _metaRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          children: [
            Icon(icon, size: 14, color: colorTextSubtle),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorCard,
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.idSessionLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorTextPrimary,
                      ),
                    ),
                  ),
                  SessionStatusBadge(status: item.status),
                ],
              ),
              const SizedBox(height: 6),
              _metaRow(Icons.store_outlined, sessionDash(item.storeName)),
              _metaRow(Icons.person_outline, sessionDash(item.openedBy)),
              _metaRow(Icons.login, 'Open: ${sessionDash(item.openingTime)}'),
              _metaRow(Icons.logout, 'Close: ${sessionDash(item.closingTime)}'),
              const SizedBox(height: 10),
              const Divider(height: 1, color: colorGreyLight),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Opening Balance',
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        sessionMoney(item.openingBalance),
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total Sales',
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        sessionMoney(item.totalSales),
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class StoreSessionInfoTab extends StatelessWidget {
  const StoreSessionInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreSessionReportController>(
      builder: (context, ctrl, child) {
        if (ctrl.detailError != null && ctrl.detail == null) {
          return SessionErrorState(
            message: ctrl.detailError!,
            onRetry: () => ctrl.fetchSessionDetail(),
          );
        }

        final d = ctrl.detail;
        if (d == null) {
          return const Center(child: CircularProgressIndicator(color: colorPrimary));
        }

        return RefreshIndicator(
          onRefresh: ctrl.loadSession,
          color: colorPrimary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              SessionInfoCard(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          d.idSessionLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorTextPrimary,
                          ),
                        ),
                      ),
                      SessionStatusBadge(status: d.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SessionInfoRow(label: 'Store', value: sessionDash(d.storeName)),
                  SessionInfoRow(label: 'Cashier', value: sessionDash(d.cashierName)),
                  SessionInfoRow(label: 'Opened At', value: sessionDash(d.openingTime)),
                  SessionInfoRow(label: 'Closed At', value: sessionDash(d.closingTime)),
                ],
              ),
              SessionInfoCard(
                title: 'Balance',
                children: [
                  SessionInfoRow(label: 'Opening Balance', value: sessionMoney(d.openingBalance)),
                  SessionInfoRow(
                    label: 'Closing Balance',
                    value: d.closingBalance == null ? '-' : sessionMoney(d.closingBalance!),
                  ),
                  SessionInfoRow(
                    label: 'Total Sales',
                    value: sessionMoney(d.totalSales),
                    valueColor: colorPrimary,
                    bold: true,
                  ),
                ],
              ),
              SessionInfoCard(
                title: 'Sales Summary',
                children: [
                  SessionInfoRow(label: 'Total Orders', value: '${d.totalOrders}'),
                  SessionInfoRow(label: 'Cash Sales', value: sessionMoney(d.cashSalesAmount)),
                  SessionInfoRow(
                    label: 'Non-Cash Sales (QRIS/VA)',
                    value: sessionMoney(d.nonCashSalesAmount),
                  ),
                  SessionInfoRow(
                    label: 'Cash In',
                    value: sessionMoney(d.totalCashIn),
                    valueColor: Colors.green,
                  ),
                  SessionInfoRow(
                    label: 'Cash Out',
                    value: sessionMoney(d.totalCashOut),
                    valueColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
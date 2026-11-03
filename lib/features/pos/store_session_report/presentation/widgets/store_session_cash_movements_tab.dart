import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class StoreSessionCashMovementsTab extends StatefulWidget {
  const StoreSessionCashMovementsTab({super.key});

  @override
  State<StoreSessionCashMovementsTab> createState() => _StoreSessionCashMovementsTabState();
}

class _StoreSessionCashMovementsTabState extends State<StoreSessionCashMovementsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _summaryCol(String label, double value, Color color, {CrossAxisAlignment? align}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: align ?? CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
          const SizedBox(height: 2),
          Text(
            sessionMoney(value),
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(StoreSessionReportController ctrl) {
    if (ctrl.isLoadingCm) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (ctrl.cmError != null && ctrl.cashMovements.isEmpty) {
      return SessionErrorState(message: ctrl.cmError!, onRetry: () => ctrl.fetchCashMovements());
    }
    if (ctrl.cashMovements.isEmpty) {
      return const SessionEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        message: 'No cash movement found',
      );
    }

    final s = ctrl.cmSummary;

    return RefreshIndicator(
      onRefresh: () => ctrl.fetchCashMovements(page: ctrl.cmPage),
      color: colorPrimary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          if (s != null)
            SessionInfoCard(
              children: [
                Row(
                  children: [
                    _summaryCol('Total In', s.totalIn, Colors.green),
                    _summaryCol('Total Out', s.totalOut, Colors.red, align: CrossAxisAlignment.center),
                    _summaryCol('Net', s.totalAll, colorPrimary, align: CrossAxisAlignment.end),
                  ],
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${ctrl.cmTotal} movements',
              style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
            ),
          ),
          for (final m in ctrl.cashMovements) _MovementCard(item: m),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StoreSessionReportController>(
      builder: (context, ctrl, child) {
        return Column(
          children: [
            Expanded(child: _buildBody(ctrl)),
            if (!ctrl.isLoadingCm && ctrl.cmError == null && ctrl.cashMovements.isNotEmpty)
              PaginationBottomBar(
                currentPage: ctrl.cmPage,
                lastPage: ctrl.cmLastPage,
                hasPrev: ctrl.hasCmPrev,
                hasNext: ctrl.hasCmNext,
                onGoToPage: ctrl.goToCmPage,
                onPrev: ctrl.prevCmPage,
                onNext: ctrl.nextCmPage,
              ),
          ],
        );
      },
    );
  }
}

class _MovementCard extends StatelessWidget {
  final StoreSessionCashMovement item;
  const _MovementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isIn ? Colors.green : Colors.red;

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                item.isIn ? Icons.arrow_downward : Icons.arrow_upward,
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item.notes == null || item.notes!.trim().isEmpty) ? 'No notes' : item.notes!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sessionDash(item.createdAt),
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item.isIn ? '+' : '-'} ${sessionMoney(item.amount)}',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
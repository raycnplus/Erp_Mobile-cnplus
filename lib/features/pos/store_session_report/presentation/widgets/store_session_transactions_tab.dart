import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/models/store_session_report_models.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';

class StoreSessionTransactionsTab extends StatefulWidget {
  const StoreSessionTransactionsTab({super.key});

  @override
  State<StoreSessionTransactionsTab> createState() => _StoreSessionTransactionsTabState();
}

class _StoreSessionTransactionsTabState extends State<StoreSessionTransactionsTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _onSearchChanged(String v) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) context.read<StoreSessionReportController>().setTxSearch(v);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {});
    context.read<StoreSessionReportController>().setTxSearch('');
  }

  Future<void> _pickRange(StoreSessionReportController ctrl) async {
    final from = ctrl.txDateFrom;
    final to = ctrl.txDateTo;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: (from != null && to != null) ? DateTimeRange(start: from, end: to) : null,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: colorPrimary),
        ),
        child: child!,
      ),
    );

    if (picked != null) ctrl.setTxDateRange(picked.start, picked.end);
  }

  Widget _filterRow(StoreSessionReportController ctrl) {
    final hasRange = ctrl.txDateFrom != null && ctrl.txDateTo != null;

    Widget chip(String label, bool selected, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onTap(),
            selectedColor: colorPrimary.withOpacity(0.15),
            backgroundColor: colorCard,
            side: BorderSide(color: selected ? colorPrimary : colorGreyLight),
            labelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? colorPrimary : colorTextSubtle,
            ),
          ),
        );

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          chip('All', ctrl.txPayment == null, () => ctrl.setTxPayment(null)),
          for (final m in ctrl.paymentMethodOptions)
            chip(m, ctrl.txPayment == m, () => ctrl.setTxPayment(m)),
          InputChip(
            avatar: const Icon(Icons.date_range, size: 16, color: colorPrimary),
            label: Text(
              hasRange
                  ? '${_fmtDate(ctrl.txDateFrom!)} → ${_fmtDate(ctrl.txDateTo!)}'
                  : 'Date range',
            ),
            onPressed: () => _pickRange(ctrl),
            onDeleted: hasRange ? () => ctrl.setTxDateRange(null, null) : null,
            backgroundColor: colorCard,
            side: BorderSide(color: hasRange ? colorPrimary : colorGreyLight),
            labelStyle: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(StoreSessionReportController ctrl) {
    if (ctrl.isLoadingTx) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    if (ctrl.txError != null && ctrl.transactions.isEmpty) {
      return SessionErrorState(message: ctrl.txError!, onRetry: () => ctrl.fetchTransactions());
    }
    if (ctrl.transactions.isEmpty) {
      return const SessionEmptyState(
        icon: Icons.receipt_long_outlined,
        message: 'No transaction found',
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ctrl.txTotal} transactions',
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
              ),
              Text(
                'Total: ${sessionMoney(ctrl.txTotalAmountAll)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ctrl.fetchTransactions(page: ctrl.txPage),
            color: colorPrimary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              itemCount: ctrl.transactions.length,
              itemBuilder: (context, index) {
                final t = ctrl.transactions[index];
                return _TransactionCard(
                  item: t,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.posStoreSessionTransactionDetail,
                    arguments: t.encryption,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<StoreSessionReportController>(
      builder: (context, ctrl, child) {
        return Column(
          children: [
            Container(
              color: colorCard,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
                decoration: InputDecoration(
                  hintText: 'Search code, cashier, customer...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                  prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: colorGrey, size: 18),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorGreyLight, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                  ),
                ),
              ),
            ),
            Container(
              color: colorCard,
              padding: const EdgeInsets.only(bottom: 8),
              child: _filterRow(ctrl),
            ),
            Expanded(child: _buildBody(ctrl)),
            if (!ctrl.isLoadingTx && ctrl.txError == null && ctrl.transactions.isNotEmpty)
              PaginationBottomBar(
                currentPage: ctrl.txPage,
                lastPage: ctrl.txLastPage,
                hasPrev: ctrl.hasTxPrev,
                hasNext: ctrl.hasTxNext,
                onGoToPage: ctrl.goToTxPage,
                onPrev: ctrl.prevTxPage,
                onNext: ctrl.nextTxPage,
              ),
          ],
        );
      },
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final StoreSessionTransaction item;
  final VoidCallback onTap;

  const _TransactionCard({required this.item, required this.onTap});

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
                      item.transactionCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: colorTextPrimary,
                      ),
                    ),
                  ),
                  SessionStatusBadge(status: item.status),
                ],
              ),
              const SizedBox(height: 6),
              _metaRow(Icons.schedule, sessionDash(item.transactionDate)),
              _metaRow(Icons.person_outline, 'Cashier: ${sessionDash(item.cashier)}'),
              if (item.customer.isNotEmpty) _metaRow(Icons.badge_outlined, item.customer),
              const SizedBox(height: 10),
              const Divider(height: 1, color: colorGreyLight),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment',
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        sessionDash(item.paymentMethod),
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total',
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(height: 2),
                      Text(
                        sessionMoney(item.totalAmount),
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
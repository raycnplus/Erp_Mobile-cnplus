import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/widgets/store_session_widgets.dart';

class StoreSessionTransactionDetailScreen extends StatefulWidget {
  final String encryption;

  const StoreSessionTransactionDetailScreen({super.key, required this.encryption});

  @override
  State<StoreSessionTransactionDetailScreen> createState() =>
      _StoreSessionTransactionDetailScreenState();
}

class _StoreSessionTransactionDetailScreenState extends State<StoreSessionTransactionDetailScreen> {
  late final StoreSessionReportController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = context.read<StoreSessionReportController>();
    _ctrl.prepareTransactionDetail();
    _ctrl.addListener(_onCtrlChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchTransactionDetail(widget.encryption);
    });
  }

  void _onCtrlChanged() {
    if (!mounted) return;
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
    final msg = _ctrl.consumeStatusMessage();
    if (msg != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onCtrlChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Consumer<StoreSessionReportController>(
          builder: (context, ctrl, child) => Text(
            ctrl.transactionDetail?.transactionCode ?? 'Transaction Detail',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: colorTextPrimary,
              fontSize: 18,
            ),
          ),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<StoreSessionReportController>(
            builder: (context, ctrl, child) {
              if (ctrl.isExporting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                  ),
                );
              }
              return IconButton(
                tooltip: 'Export Excel',
                icon: const Icon(Icons.file_download_outlined),
                onPressed: ctrl.transactionDetail == null
                    ? null
                    : () => ctrl.exportTransactionDetail(widget.encryption),
              );
            },
          ),
        ],
      ),
      body: Consumer<StoreSessionReportController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoadingTransactionDetail) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.transactionDetailError != null) {
            return SessionErrorState(
              message: ctrl.transactionDetailError!,
              onRetry: () => ctrl.fetchTransactionDetail(widget.encryption),
            );
          }

          final d = ctrl.transactionDetail;
          if (d == null) {
            return const SessionEmptyState(
              icon: Icons.receipt_long_outlined,
              message: 'Transaction not found',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ctrl.fetchTransactionDetail(widget.encryption),
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
                            d.transactionCode,
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
                    SessionInfoRow(label: 'Date', value: sessionDash(d.transactionDate)),
                    SessionInfoRow(label: 'Session', value: d.sessionLabel),
                    SessionInfoRow(label: 'Store', value: sessionDash(d.storeName)),
                    SessionInfoRow(label: 'Cashier', value: sessionDash(d.cashierName)),
                    SessionInfoRow(label: 'Customer', value: sessionDash(d.customerName)),
                  ],
                ),
                SessionInfoCard(
                  title: 'Payment',
                  children: [
                    SessionInfoRow(label: 'Method', value: sessionDash(d.paymentMethod)),
                    SessionInfoRow(label: 'Paid', value: sessionMoney(d.paidAmount)),
                    SessionInfoRow(label: 'Change', value: sessionMoney(d.changeAmount)),
                    SessionInfoRow(
                      label: 'Total',
                      value: sessionMoney(d.totalAmount),
                      valueColor: colorPrimary,
                      bold: true,
                    ),
                  ],
                ),
                SessionInfoCard(
                  title: 'Items (${d.items.length})',
                  children: [
                    if (d.items.isEmpty)
                      Text(
                        'No items',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                      ),
                    for (int i = 0; i < d.items.length; i++) ...[
                      if (i > 0) const Divider(height: 20, color: colorGreyLight),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  d.items[i].productName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorTextPrimary,
                                  ),
                                ),
                                if (d.items[i].productCode.isNotEmpty)
                                  Text(
                                    d.items[i].productCode,
                                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                                  ),
                                const SizedBox(height: 2),
                                Text(
                                  '${formatPrice(d.items[i].qty)} × ${sessionMoney(d.items[i].price)}',
                                  style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            sessionMoney(d.items[i].subtotal),
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
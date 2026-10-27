import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/controllers/billing_tax_report_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/widgets/billing_tax_report_row.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/widgets/billing_tax_report_filter_sheet.dart';

class BillingTaxReportListScreen extends StatefulWidget {
  const BillingTaxReportListScreen({super.key});

  @override
  State<BillingTaxReportListScreen> createState() => _BillingTaxReportListScreenState();
}

class _BillingTaxReportListScreenState extends State<BillingTaxReportListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<BillingTaxReportController>();
      ctrl.fetchFormOptions();
      ctrl.fetchPage(1);
      ctrl.addListener(_onControllerChange);
    });
  }

  @override
  void dispose() {
    context.read<BillingTaxReportController>().removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    final ctrl = context.read<BillingTaxReportController>();
    final msg = ctrl.consumeStatusMessage();
    if (msg != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _handleRefresh() => context.read<BillingTaxReportController>().refresh();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<BillingTaxReportController>(),
        child: const BillingTaxReportFilterSheet(),
      ),
    );
  }

  void _handleExport() {
    context.read<BillingTaxReportController>().startExport();
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
        title: Text(
          'Billing Tax Report',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 18),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<BillingTaxReportController>(
            builder: (context, ctrl, child) {
              if (!ctrl.canExport) return const SizedBox.shrink();
              if (ctrl.isExporting) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorPrimary,
                        value: ctrl.downloadProgress > 0 ? ctrl.downloadProgress / 100 : null,
                      ),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Export to Excel',
                onPressed: _handleExport,
              );
            },
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _openFilterSheet),
        ],
      ),
      body: Consumer<BillingTaxReportController>(
        builder: (context, ctrl, child) {
          if (ctrl.isLoadingReport && !ctrl.hasFetchedOnce) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.reportError != null && ctrl.tableRows.isEmpty) {
            return _buildErrorState(ctrl.reportError!, _handleRefresh);
          }
          if (ctrl.hasFetchedOnce && !ctrl.isLoadingReport && ctrl.tableRows.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _summaryHeader(ctrl),
              Expanded(
                child: ctrl.isLoadingReport
                    ? const Center(child: CircularProgressIndicator(color: colorPrimary))
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: billingTaxTableWidth,
                              child: Column(
                                children: [
                                  BillingTaxReportHeaderWidget(width: billingTaxTableWidth),
                                  ...ctrl.tableRows.asMap().entries.map(
                                        (e) => BillingTaxReportRowWidget(row: e.value, index: e.key, width: billingTaxTableWidth),
                                      ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              _paginationBar(ctrl),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryHeader(BillingTaxReportController ctrl) {
    final summary = ctrl.summary;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: colorCard,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalBlock('Subtotal', summary.totalUntaxed),
            const SizedBox(width: 28),
            _totalBlock('PPN', summary.totalTaxes),
            const SizedBox(width: 28),
            _totalBlock('Grand Total', summary.totalGrand),
          ],
        ),
      ),
    );
  }

  Widget _totalBlock(String label, double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
        ),
        const SizedBox(height: 2),
        Text(
          'Rp ${formatCurrencyDisplay(value)}',
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: colorTextPrimary),
        ),
      ],
    );
  }

  Widget _paginationBar(BillingTaxReportController ctrl) {
    if (!ctrl.hasFetchedOnce || ctrl.tableRows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: colorCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${ctrl.totalRecords} records',
            style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: ctrl.hasPrevPage ? colorPrimary : colorGrey,
                onPressed: ctrl.hasPrevPage ? ctrl.prevPage : null,
              ),
              Text(
                'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: ctrl.hasNextPage ? colorPrimary : colorGrey,
                onPressed: ctrl.hasNextPage ? ctrl.nextPage : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(error, style: GoogleFonts.poppins(color: colorError), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'No billing/tax data found',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
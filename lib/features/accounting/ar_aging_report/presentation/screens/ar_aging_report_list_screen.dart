import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/controllers/ar_aging_report_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/widgets/ar_aging_report_row.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/widgets/ar_aging_report_filter_sheet.dart';

class ARAgingReportListScreen extends StatefulWidget {
  const ARAgingReportListScreen({super.key});

  @override
  State<ARAgingReportListScreen> createState() => _ARAgingReportListScreenState();
}

class _ARAgingReportListScreenState extends State<ARAgingReportListScreen> {
  ARAgingReportController? _ctrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctrl = context.read<ARAgingReportController>();
      _ctrl = ctrl;
      ctrl.fetchFormOptions();
      ctrl.applyFilter();
      ctrl.addListener(_onControllerChange);
    });
  }

  @override
  void dispose() {
    _ctrl?.removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    final ctrl = _ctrl;
    if (ctrl == null) return;
    final msg = ctrl.consumeStatusMessage();
    if (msg != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _handleRefresh() => context.read<ARAgingReportController>().refresh();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<ARAgingReportController>(),
        child: const ARAgingReportFilterSheet(),
      ),
    );
  }

  void _handleExport(String type) {
    context.read<ARAgingReportController>().startExport(type);
  }

  void _showExportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined, color: colorPrimary),
              title: Text('Export to PDF', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _handleExport('pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined, color: colorPrimary),
              title: Text('Export to Excel', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _handleExport('excel');
              },
            ),
          ],
        ),
      ),
    );
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
          'AR Aging Report',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 18),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<ARAgingReportController>(
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
                onPressed: () => _showExportMenu(context),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _openFilterSheet),
        ],
      ),
      body: Consumer<ARAgingReportController>(
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
              _summarySection(ctrl),
              Expanded(
                child: ctrl.isLoadingReport
                    ? const Center(child: CircularProgressIndicator(color: colorPrimary))
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final tableWidth = ARAColumnWidths.total > constraints.maxWidth
                                ? ARAColumnWidths.total
                                : constraints.maxWidth;

                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: tableWidth,
                                  child: Column(
                                    children: [
                                      _columnHeader(tableWidth),
                                      ...ctrl.tableRows.asMap().entries.map(
                                            (e) => ARAgingReportRowWidget(row: e.value, index: e.key, width: tableWidth),
                                          ),
                                      _footerRow(ctrl, tableWidth),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summarySection(ARAgingReportController ctrl) {
    final summary = ctrl.summary;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: colorCard,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _bucketCard('Current', summary.current, colorTextPrimary),
            _bucketCard('1-30 Days', summary.days30, colorWarning),
            _bucketCard('31-60 Days', summary.days60, colorWarning),
            _bucketCard('61-90 Days', summary.days90, colorError),
            _bucketCard('> 90 Days', summary.over90, colorError),
          ],
        ),
      ),
    );
  }

  Widget _bucketCard(String label, double value, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorGreyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: colorTextSubtle)),
          const SizedBox(height: 4),
          Text(
            'Rp ${formatCurrencyDisplay(value)}',
            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _columnHeader(double width) {
    const headStyle = TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colorWhite);

    Widget cell(double w, String text, {TextAlign align = TextAlign.left, bool isLast = false}) {
      return Container(
        width: w,
        padding: EdgeInsets.only(right: isLast ? 0 : ARAColumnWidths.columnGap),
        child: Text(text, textAlign: align, style: headStyle),
      );
    }

    return Container(
      width: width,
      color: colorTextPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          cell(ARAColumnWidths.no, 'No'),
          cell(ARAColumnWidths.reference, 'Reference'),
          cell(ARAColumnWidths.customer, 'Customer'),
          cell(ARAColumnWidths.type, 'Type'),
          cell(ARAColumnWidths.invoiceDate, 'Inv. Date'),
          cell(ARAColumnWidths.dueDate, 'Due Date'),
          cell(ARAColumnWidths.invoiceAmount, 'Invoice', align: TextAlign.right),
          cell(ARAColumnWidths.paid, 'Paid', align: TextAlign.right),
          cell(ARAColumnWidths.outstanding, 'Outstanding', align: TextAlign.right),
          cell(ARAColumnWidths.paymentNo, 'Payment No'),
          cell(ARAColumnWidths.paymentDate, 'Pay. Date'),
          cell(ARAColumnWidths.daysOverdue, 'Overdue', align: TextAlign.right),
          cell(ARAColumnWidths.aging, 'Aging'),
          cell(ARAColumnWidths.status, 'Status', isLast: true),
        ],
      ),
    );
  }

  Widget _footerRow(ARAgingReportController ctrl, double width) {
    final totals = ctrl.totals;
    if (totals == null) return const SizedBox.shrink();

    const boldStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite);

    return Container(
      width: width,
      color: colorTextPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: ARAColumnWidths.no + ARAColumnWidths.reference + ARAColumnWidths.customer +
                ARAColumnWidths.type + ARAColumnWidths.invoiceDate + ARAColumnWidths.dueDate,
            child: const Text('TOTAL', style: boldStyle),
          ),
          SizedBox(
            width: ARAColumnWidths.invoiceAmount,
            child: Text('Rp ${formatCurrencyDisplay(totals.invoiceAmount)}', textAlign: TextAlign.right, style: boldStyle),
          ),
          SizedBox(
            width: ARAColumnWidths.paid,
            child: Text('Rp ${formatCurrencyDisplay(totals.paidAmount)}', textAlign: TextAlign.right, style: boldStyle),
          ),
          SizedBox(
            width: ARAColumnWidths.outstanding,
            child: Text('Rp ${formatCurrencyDisplay(totals.outstanding)}', textAlign: TextAlign.right, style: boldStyle),
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
              'No receivables data found',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
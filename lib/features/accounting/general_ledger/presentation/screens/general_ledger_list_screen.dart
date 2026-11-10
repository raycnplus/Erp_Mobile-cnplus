import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_dialog.dart';
import 'package:erp_mobile_cnplus/shared/helpers/currency_formatter.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/controllers/general_ledger_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/widgets/general_ledger_list_item.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/widgets/general_ledger_filter_sheet.dart';

class GeneralLedgerListScreen extends StatefulWidget {
  const GeneralLedgerListScreen({super.key});

  @override
  State<GeneralLedgerListScreen> createState() => _GeneralLedgerListScreenState();
}

class _GeneralLedgerListScreenState extends State<GeneralLedgerListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<GeneralLedgerController>();
      ctrl.fetchFormOptions();
      ctrl.addListener(_onControllerChange);
    });
  }

  @override
  void dispose() {
    context.read<GeneralLedgerController>().removeListener(_onControllerChange);
    super.dispose();
  }

  void _onControllerChange() {
    final ctrl = context.read<GeneralLedgerController>(); // sesuaikan per screen
    final msg = ctrl.consumeStatusMessage();
    if (msg != null && mounted) {
      final isError = msg.toLowerCase().contains('failed') ||
          msg.toLowerCase().contains('only');
      CustomDialog.showInfo(
        context,
        message: msg,
        type: isError ? CustomDialogType.error : CustomDialogType.success,
      );
    }
  }

  Future<void> _handleRefresh() => context.read<GeneralLedgerController>().refresh();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<GeneralLedgerController>(),
        child: const GeneralLedgerFilterSheet(),
      ),
    );
  }

  void _handleExport(String type) {
    context.read<GeneralLedgerController>().startExport(type);
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
          'General Ledger',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 20),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<GeneralLedgerController>(
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
      body: Consumer<GeneralLedgerController>(
        builder: (context, ctrl, child) {
          if (!ctrl.hasFetchedOnce) return _buildInitialPromptState();
          if (ctrl.isLoadingReport) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.reportError != null && ctrl.tableRows.isEmpty) {
            return _buildErrorState(ctrl.reportError!, _handleRefresh);
          }
          if (ctrl.tableRows.isEmpty) return _buildEmptyState();

          return Column(
            children: [
              _summaryHeader(ctrl),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: colorPrimary,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final tableWidth = GLColumnWidths.total > constraints.maxWidth
                          ? GLColumnWidths.total
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
                                ...ctrl.tableRows.map(
                                  (r) => GeneralLedgerRowWidget(row: r, width: tableWidth),
                                ),
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

  Widget _summaryHeader(GeneralLedgerController ctrl) {
    return Container(
      width: double.infinity,
      color: colorCard,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _totalBlock('Total Debit', ctrl.grandTotalDebit),
          _totalBlock('Total Credit', ctrl.grandTotalCredit),
        ],
      ),
    );
  }

  Widget _totalBlock(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
        Text(
          'Rp ${formatCurrencyDisplay(value)}',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: colorTextPrimary),
        ),
      ],
    );
  }

  Widget _columnHeader(double width) {
    return Container(
      width: width,
      color: colorTextPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: GLColumnWidths.date,
            child: Text('Date', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite)),
          ),
          const SizedBox(
            width: GLColumnWidths.refDesc,
            child: Text('Ref / Description', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite)),
          ),
          const SizedBox(
            width: GLColumnWidths.debit,
            child: Text('Debit', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite)),
          ),
          const SizedBox(
            width: GLColumnWidths.credit,
            child: Text('Credit', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite)),
          ),
          const Expanded(
            child: Text('Balance', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite)),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPromptState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_list, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'Select a date range\nto display the report',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _openFilterSheet,
              icon: const Icon(
                Icons.filter_list,
                size: 18,
                color: colorPrimary,
              ),
              label: Text(
                'Open Filter',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: colorPrimary),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
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
              'No ledger data found',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
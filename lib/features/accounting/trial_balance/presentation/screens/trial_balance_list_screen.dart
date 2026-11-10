import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_dialog.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/controllers/trial_balance_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/widgets/trial_balance_row.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/widgets/trial_balance_filter_sheet.dart';

class TrialBalanceListScreen extends StatefulWidget {
  const TrialBalanceListScreen({super.key});

  @override
  State<TrialBalanceListScreen> createState() => _TrialBalanceListScreenState();
}

class _TrialBalanceListScreenState extends State<TrialBalanceListScreen> {
  TrialBalanceController? _ctrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctrl = context.read<TrialBalanceController>();
      _ctrl = ctrl;
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
      final lower = msg.toLowerCase();
      final isError = lower.contains('failed') || lower.contains('only');
      CustomDialog.showInfo(
        context,
        message: msg,
        type: isError ? CustomDialogType.error : CustomDialogType.success,
      );
    }
  }

  Future<void> _handleRefresh() => context.read<TrialBalanceController>().refresh();

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TrialBalanceController>(),
        child: const TrialBalanceFilterSheet(),
      ),
    );
  }

  void _handleExport(String type) {
    context.read<TrialBalanceController>().startExport(type);
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
          'Trial Balance',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 20),
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<TrialBalanceController>(
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
      body: Consumer<TrialBalanceController>(
        builder: (context, ctrl, child) {
          if (!ctrl.hasFetchedOnce) return _buildInitialPromptState();
          if (ctrl.isLoadingReport) {
            return const Center(child: CircularProgressIndicator(color: colorPrimary));
          }
          if (ctrl.reportError != null && ctrl.tableRows.isEmpty) {
            return _buildErrorState(ctrl.reportError!, _handleRefresh);
          }
          if (ctrl.tableRows.isEmpty) return _buildEmptyState();

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: colorPrimary,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = TBColumnWidths.total > constraints.maxWidth
                    ? TBColumnWidths.total
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
                            (r) => TrialBalanceRowWidget(row: r, width: tableWidth),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _columnHeader(double width) {
    const headStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: colorWhite);
    return Container(
      width: width,
      color: colorTextPrimary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const SizedBox(width: TBColumnWidths.coa),
                SizedBox(
                  width: TBColumnWidths.numeric * 2,
                  child: const Text('Saldo Awal', textAlign: TextAlign.center, style: headStyle),
                ),
                SizedBox(
                  width: TBColumnWidths.numeric * 2,
                  child: const Text('Mutasi', textAlign: TextAlign.center, style: headStyle),
                ),
                SizedBox(
                  width: TBColumnWidths.numeric * 2,
                  child: const Text('Saldo Akhir', textAlign: TextAlign.center, style: headStyle),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: colorGreyLight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const SizedBox(
                  width: TBColumnWidths.coa,
                  child: Text('COA', style: headStyle),
                ),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Debit', textAlign: TextAlign.right, style: headStyle)),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Kredit', textAlign: TextAlign.right, style: headStyle)),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Debit', textAlign: TextAlign.right, style: headStyle)),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Kredit', textAlign: TextAlign.right, style: headStyle)),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Debit', textAlign: TextAlign.right, style: headStyle)),
                SizedBox(width: TBColumnWidths.numeric, child: const Text('Kredit', textAlign: TextAlign.right, style: headStyle)),
              ],
            ),
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
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: colorTextSubtle),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _openFilterSheet,
              icon: const Icon(Icons.filter_list, size: 18, color: colorPrimary),
              label: Text('Open Filter', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorPrimary)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: colorPrimary),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              'No trial balance data found',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
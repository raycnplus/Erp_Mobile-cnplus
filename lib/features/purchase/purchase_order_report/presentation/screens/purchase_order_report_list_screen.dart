import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/controllers/purchase_order_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/widgets/purchase_order_report_list_item.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/widgets/purchase_order_report_filter_sheet.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_dialog.dart';

class PurchaseOrderReportListScreen extends StatefulWidget {
  const PurchaseOrderReportListScreen({super.key});

  @override
  State<PurchaseOrderReportListScreen> createState() =>
      _PurchaseOrderReportListScreenState();
}

class _PurchaseOrderReportListScreenState
    extends State<PurchaseOrderReportListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final PurchaseOrderReportController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = context.read<PurchaseOrderReportController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.fetchFormOptions();
      _ctrl.addListener(_onControllerChange);
    });
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerChange);
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    final msg = _ctrl.consumeStatusMessage();
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

  void _handleExport(String type) {
    context.read<PurchaseOrderReportController>().startExport(type);
  }

  void _showExportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.picture_as_pdf_outlined, color: colorPrimary),
              title: Text('Export to PDF', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                _handleExport('pdf');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.table_chart_outlined, color: colorPrimary),
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

  void _onSearchChanged(String value) {
    context.read<PurchaseOrderReportController>().searchList(value);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<PurchaseOrderReportController>().clearSearch();
  }

  Future<void> _handleRefresh() {
    return context.read<PurchaseOrderReportController>().fetchList();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<PurchaseOrderReportController>(),
        child: const PurchaseOrderReportFilterSheet(),
      ),
    );
  }

  String _formatRupiah(String rawValue) {
    final parts = rawValue.split('.');
    final wholePart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    for (int i = 0; i < wholePart.length; i++) {
      if (i > 0 && (wholePart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(wholePart[i]);
    }

    if (decimalPart.isEmpty) return 'Rp $buffer';
    return 'Rp $buffer,$decimalPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSummary(),
          Expanded(child: _buildListContent()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Purchase Order Report',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: colorTextPrimary,
          fontSize: 20,
        ),
      ),
      elevation: 0.5,
      backgroundColor: colorWhite,
      foregroundColor: colorTextPrimary,
      actions: [
          Consumer<PurchaseOrderReportController>(
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
                        value: ctrl.downloadProgress > 0
                            ? ctrl.downloadProgress / 100
                            : null,
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
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: colorCard,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
        decoration: InputDecoration(
          hintText: 'Search reference, vendor, warehouse...',
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    );
  }

  Widget _buildSummary() {
    return Consumer<PurchaseOrderReportController>(
      builder: (context, ctrl, child) {
        if (!ctrl.hasFetchedOnce) return const SizedBox.shrink();

        final summary = ctrl.summary;
        if (summary == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatRupiah(summary.totalAmountRaw),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colorTextPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Records',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: colorTextSubtle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${summary.totalRecords}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListContent() {
    return Consumer<PurchaseOrderReportController>(
      builder: (context, ctrl, child) {
        final bar = PaginationBottomBar(
          currentPage: ctrl.currentPage,
          lastPage: ctrl.lastPage,
          hasPrev: ctrl.hasPrevPage,
          hasNext: ctrl.hasNextPage,
          onGoToPage: ctrl.goToPage,
          onPrev: ctrl.prevPage,
          onNext: ctrl.nextPage,
        );

        if (!ctrl.hasFetchedOnce) return _buildInitialPromptState();

        if (ctrl.isLoadingList) {
          return const Center(
            child: CircularProgressIndicator(color: colorPrimary),
          );
        }

        if (ctrl.listError != null && ctrl.list.isEmpty) {
          return _buildErrorState(ctrl.listError!, _handleRefresh);
        }

        if (ctrl.list.isEmpty) {
          return Column(
            children: [
              Expanded(child: _buildEmptyState()),
              bar,
            ],
          );
        }

        return Column(
          children: [
            _buildRecordHeader(ctrl),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: colorPrimary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  itemCount: ctrl.list.length,
                  itemBuilder: (context, index) =>
                      PurchaseOrderReportListItem(item: ctrl.list[index]),
                ),
              ),
            ),
            bar,
          ],
        );
      },
    );
  }

  Widget _buildRecordHeader(PurchaseOrderReportController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${ctrl.total} records',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
          ),
          Text(
            'Page ${ctrl.currentPage} of ${ctrl.lastPage}',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
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
            const Icon(Icons.search, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'Search or select a filter\nto display data',
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
              icon: const Icon(Icons.filter_list, size: 18, color: colorPrimary),
              label: Text(
                'Open Filter',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: colorPrimary),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            Text(
              error,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
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
            const Icon(Icons.shopping_cart_outlined, size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              'No Purchase Order data found',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorTextSubtle,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
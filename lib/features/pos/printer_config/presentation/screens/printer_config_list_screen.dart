import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/controllers/printer_config_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/widgets/printer_config_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'printer_config_form_screen.dart';
import 'printer_config_detail_screen.dart';

class PrinterConfigListScreen extends StatefulWidget {
  const PrinterConfigListScreen({super.key});

  @override
  State<PrinterConfigListScreen> createState() => _State();
}

class _State extends State<PrinterConfigListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PrinterConfigController>().fetchList(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<bool?> _confirmDialog(
    String title,
    String content, {
    String confirmLabel = 'Confirm',
    Color? confirmColor,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(content, style: GoogleFonts.poppins()),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor ?? colorPrimary,
                foregroundColor: colorWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(confirmLabel, style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );

  void _goToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrinterConfigFormScreen()),
    ).then((_) => context.read<PrinterConfigController>().fetchList());
  }

  void _goToEdit(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PrinterConfigFormScreen(id: id)),
    ).then((_) => context.read<PrinterConfigController>().fetchList());
  }

  Future<void> _handleSetDefault(int id, bool isDefault) async {
    if (isDefault) {
      _snack('This printer is already the default');
      return;
    }
    final ctrl = context.read<PrinterConfigController>();
    final ok = await _confirmDialog('Set as Default', 'Set this printer as default?', confirmLabel: 'Yes');
    if (ok != true || !mounted) return;

    final success = await ctrl.setDefault(id);
    if (!mounted) return;
    _snack(success ? 'Default printer updated' : ctrl.formError ?? 'Failed', success: success);
  }

  Future<void> _handleDelete(int id, String name) async {
    final ctrl = context.read<PrinterConfigController>();
    final ok = await _confirmDialog(
      'Delete Printer',
      'Printer "$name" will be permanently deleted.',
      confirmLabel: 'Delete',
      confirmColor: colorError,
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.remove(id);
    if (!mounted) return;
    _snack(success ? 'Printer deleted' : ctrl.formError ?? 'Failed', success: success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Printer Configuration',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary, fontSize: 20),
            ),
            Text(
              'Manage receipt printers',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => context.read<PrinterConfigController>().search(v),
              decoration: InputDecoration(
                hintText: 'Search printer name or description...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<PrinterConfigController>().clearSearch();
                        },
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
                  borderSide: const BorderSide(color: colorGreyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PrinterConfigController>(
              builder: (_, ctrl, __) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrev,
                  hasNext: ctrl.hasNext,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                  onCreateTap: _goToForm,
                );

                if (ctrl.isLoadingList) {
                  return const Center(child: CircularProgressIndicator(color: colorPrimary));
                }

                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return _buildErrorState(ctrl);
                }

                if (ctrl.pageItems.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _buildEmptyState(_searchCtrl.text.isNotEmpty)),
                      bar,
                    ],
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
                            '${ctrl.total} printers',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                          Text(
                            'Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => ctrl.fetchList(),
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.pageItems.length,
                          itemBuilder: (_, i) {
                            final p = ctrl.pageItems[i];
                            return PrinterConfigListItem(
                              printer: p,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PrinterConfigDetailScreen(id: p.id)),
                              ).then((_) => ctrl.fetchList()),
                              onSetDefault: () => _handleSetDefault(p.id, p.isDefault),
                              onDelete: () => _handleDelete(p.id, p.printerName),
                            );
                          },
                        ),
                      ),
                    ),
                    bar,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PrinterConfigController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(
              ctrl.listError!,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ctrl.fetchList(),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.print_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Printer not found' : 'No printers yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                _searchCtrl.clear();
                context.read<PrinterConfigController>().clearSearch();
              },
              icon: const Icon(Icons.close, size: 16, color: colorPrimary),
              label: Text('Clear search', style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}
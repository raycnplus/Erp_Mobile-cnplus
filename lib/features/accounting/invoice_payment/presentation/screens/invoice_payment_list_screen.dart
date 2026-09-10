import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/controllers/invoice_payment_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/widgets/invoice_payment_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'invoice_payment_detail_screen.dart';
import 'invoice_payment_form_screen.dart';

class InvoicePaymentListScreen extends StatefulWidget {
  const InvoicePaymentListScreen({super.key});

  @override
  State<InvoicePaymentListScreen> createState() => _InvoicePaymentListScreenState();
}

class _InvoicePaymentListScreenState extends State<InvoicePaymentListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedStatus;
  String? _selectedInvoiceType;
  bool _selectionMode = false;

  static const _statuses = ['Draft', 'Confirmed', 'Posted', 'Cancelled'];
  static const _invoiceTypes = ['Product', 'Service'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<InvoicePaymentController>().fetchList());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoicePaymentFormScreen()))
        .then((_) => context.read<InvoicePaymentController>().fetchList(status: _selectedStatus, invoiceType: _selectedInvoiceType));
  }

  void _snack(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: success ? colorSuccess : colorError,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  void _toggleSelectionMode() {
    setState(() => _selectionMode = !_selectionMode);
    if (!_selectionMode) context.read<InvoicePaymentController>().clearSelection();
  }

  Future<void> _handleBulkConfirm() async {
    final ctrl = context.read<InvoicePaymentController>();
    if (ctrl.selectedIds.isEmpty) { _snack('Select at least one payment'); return; }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Bulk Confirm', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Confirm ${ctrl.selectedIds.length} selected payment(s)?', style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text('Confirm', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final success = await ctrl.bulkConfirmSelected();
    if (!mounted) return;
    _snack(ctrl.successMessage ?? (success ? 'Bulk confirm completed' : 'Failed'), success: success);
    setState(() => _selectionMode = false);
  }

  Future<void> _handleBulkPost() async {
    final ctrl = context.read<InvoicePaymentController>();
    if (ctrl.selectedIds.isEmpty) { _snack('Select at least one payment'); return; }

    final picked = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1), lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    final journalDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';

    final success = await ctrl.bulkPostSelected(journalTransactionDate: journalDate);
    if (!mounted) return;
    _snack(ctrl.successMessage ?? (success ? 'Bulk post completed' : 'Failed'), success: success);
    setState(() => _selectionMode = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(_selectionMode ? Icons.close : Icons.arrow_back_ios_new),
          onPressed: _selectionMode ? _toggleSelectionMode : () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectionMode ? 'Select Payments' : 'Invoice Payment', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: colorTextPrimary)),
            if (!_selectionMode)
              Text('Customer invoice payments', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          if (_selectionMode)
            Consumer<InvoicePaymentController>(
              builder: (_, ctrl, __) => PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (v) {
                  if (v == 'confirm') _handleBulkConfirm();
                  if (v == 'post') _handleBulkPost();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'confirm', child: Text('Bulk Confirm')),
                  const PopupMenuItem(value: 'post', child: Text('Bulk Post')),
                ],
              ),
            )
          else ...[
            IconButton(icon: const Icon(Icons.checklist_outlined), onPressed: _toggleSelectionMode, tooltip: 'Select'),
            Consumer<InvoicePaymentController>(
              builder: (_, ctrl, __) => PopupMenuButton<String>(
                icon: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.filter_list, size: 20),
                  if ((_selectedStatus != null && _selectedStatus!.isNotEmpty) || (_selectedInvoiceType != null && _selectedInvoiceType!.isNotEmpty))
                    Container(margin: const EdgeInsets.only(left: 2), width: 8, height: 8, decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle)),
                ]),
                onSelected: (s) {
                  if (_statuses.contains(s) || s.isEmpty) {
                    final status = s.isEmpty ? null : s;
                    setState(() => _selectedStatus = status);
                  } else if (_invoiceTypes.contains(s.replaceFirst('type:', ''))) {
                    final type = s.replaceFirst('type:', '');
                    setState(() => _selectedInvoiceType = type);
                  } else if (s == 'clear_type') {
                    setState(() => _selectedInvoiceType = null);
                  }
                  ctrl.fetchList(status: _selectedStatus, invoiceType: _selectedInvoiceType);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: '', child: Text('All Status')),
                  ..._statuses.map((s) => PopupMenuItem(value: s, child: Text(s))),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'clear_type', child: Text('All Invoice Type')),
                  ..._invoiceTypes.map((t) => PopupMenuItem(value: 'type:$t', child: Text(t))),
                ],
              ),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (!_selectionMode)
            Container(
              color: colorCard,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => context.read<InvoicePaymentController>().search(v),
                decoration: InputDecoration(
                  hintText: 'Look for payment, customer, or invoice number...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                  prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.close, color: colorGrey, size: 18), onPressed: () {
                          _searchCtrl.clear();
                          context.read<InvoicePaymentController>().clearSearch();
                        })
                      : null,
                  filled: true, fillColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: colorGreyLight)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: colorPrimary, width: 1.5)),
                ),
              ),
            ),
          Expanded(
            child: Consumer<InvoicePaymentController>(
              builder: (_, ctrl, __) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage, lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrev, hasNext: ctrl.hasNext,
                  onGoToPage: ctrl.goToPage, onPrev: ctrl.prevPage, onNext: ctrl.nextPage,
                  onCreateTap: _selectionMode ? null : _goToForm,
                );

                if (ctrl.isLoadingList) return const Center(child: CircularProgressIndicator(color: colorPrimary));
                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return Center(child: Text(ctrl.listError!, style: GoogleFonts.poppins(color: colorError)));
                }
                if (ctrl.pageItems.isEmpty) {
                  return Column(children: [
                    Expanded(child: Center(child: Text(
                      _searchCtrl.text.isNotEmpty ? 'Payment not found' : 'No invoice payments yet',
                      style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle),
                    ))),
                    bar,
                  ]);
                }

                return Column(children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.fetchList(status: _selectedStatus, invoiceType: _selectedInvoiceType),
                      color: colorPrimary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        itemCount: ctrl.pageItems.length,
                        itemBuilder: (_, i) {
                          final item = ctrl.pageItems[i];
                          return InvoicePaymentListItem(
                            ip: item,
                            selectionMode: _selectionMode,
                            isSelected: ctrl.selectedIds.contains(item.idPayment),
                            onSelectChanged: _selectionMode ? (_) => ctrl.toggleSelect(item.idPayment) : null,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => InvoicePaymentDetailScreen(encryption: item.encryption)),
                            ).then((_) => ctrl.fetchList(status: _selectedStatus, invoiceType: _selectedInvoiceType)),
                          );
                        },
                      ),
                    ),
                  ),
                  if (!_selectionMode) bar,
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
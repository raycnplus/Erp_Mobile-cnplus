import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/controllers/cash_bank_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/widgets/cash_bank_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'cash_bank_detail_screen.dart';
import 'cash_bank_form_screen.dart';

class CashBankListScreen extends StatefulWidget {
  const CashBankListScreen({super.key});

  @override
  State<CashBankListScreen> createState() => _CashBankListScreenState();
}

class _CashBankListScreenState extends State<CashBankListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedStatus;
  String? _selectedNoteType;
  bool _selectionMode = false;

  static const _statuses = ['Draft', 'Posted'];
  static const _noteTypes = ['BANK_DEBIT', 'BANK_CREDIT', 'CASH_DEBIT', 'CASH_CREDIT'];
  static const _noteTypeLabels = {
    'BANK_DEBIT': 'Bank Debit', 'BANK_CREDIT': 'Bank Credit',
    'CASH_DEBIT': 'Cash Debit', 'CASH_CREDIT': 'Cash Credit',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CashBankController>().fetchList(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CashBankFormScreen()))
        .then((_) => context.read<CashBankController>().fetchList(status: _selectedStatus, noteType: _selectedNoteType));
  }

  void _toggleSelectionMode() {
    setState(() => _selectionMode = !_selectionMode);
    if (!_selectionMode) context.read<CashBankController>().clearSelection();
  }

  Future<void> _handleBulkPost() async {
    final ctrl = context.read<CashBankController>();
    if (!ctrl.hasSelection) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Post Transactions', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Post ${ctrl.selectedEncryptions.length} selected transaction(s)?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: colorPrimary, foregroundColor: colorWhite),
            child: Text('Post', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    final result = await ctrl.bulkPostSelected();
    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ctrl.formError ?? 'Failed to post'),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }

    setState(() => _selectionMode = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${result.successful} posted, ${result.failed} failed'),
      backgroundColor: result.failed == 0 ? colorSuccess : Colors.orange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
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
        title: _selectionMode
            ? Consumer<CashBankController>(
                builder: (_, ctrl, __) => Text(
                  '${ctrl.selectedEncryptions.length} selected',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cash & Bank', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: colorTextPrimary)),
                  Text('Cash and bank transactions', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12)),
                ],
              ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          if (_selectionMode)
            Consumer<CashBankController>(
              builder: (_, ctrl, __) => TextButton.icon(
                onPressed: ctrl.hasSelection ? _handleBulkPost : null,
                icon: const Icon(Icons.send_outlined, size: 18),
                label: Text('Post', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.checklist_outlined),
              tooltip: 'Bulk post',
              onPressed: _toggleSelectionMode,
            ),
            Consumer<CashBankController>(
              builder: (_, ctrl, __) => PopupMenuButton<String>(
                icon: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.filter_list, size: 20),
                  if ((_selectedStatus?.isNotEmpty ?? false) || (_selectedNoteType?.isNotEmpty ?? false))
                    Container(margin: const EdgeInsets.only(left: 2), width: 8, height: 8,
                        decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle)),
                ]),
                onSelected: (v) {
                  setState(() {
                    if (v.startsWith('status:')) {
                      final s = v.substring(7);
                      _selectedStatus = s.isEmpty ? null : s;
                    } else if (v.startsWith('type:')) {
                      final t = v.substring(5);
                      _selectedNoteType = t.isEmpty ? null : t;
                    } else if (v == 'clear') {
                      _selectedStatus = null;
                      _selectedNoteType = null;
                    }
                  });
                  ctrl.fetchList(status: _selectedStatus, noteType: _selectedNoteType);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(enabled: false, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  const PopupMenuItem(value: 'status:', child: Text('All Status')),
                  ..._statuses.map((s) => PopupMenuItem(value: 'status:$s', child: Text(s))),
                  const PopupMenuDivider(),
                  const PopupMenuItem(enabled: false, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                  const PopupMenuItem(value: 'type:', child: Text('All Types')),
                  ..._noteTypes.map((t) => PopupMenuItem(value: 'type:$t', child: Text(_noteTypeLabels[t]!))),
                  const PopupMenuDivider(),
                  const PopupMenuItem(value: 'clear', child: Text('Clear Filters')),
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
                onChanged: (v) => context.read<CashBankController>().search(v),
                decoration: InputDecoration(
                  hintText: 'Look for reference or description...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                  prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.close, color: colorGrey, size: 18), onPressed: () {
                          _searchCtrl.clear();
                          context.read<CashBankController>().clearSearch();
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
            child: Consumer<CashBankController>(
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
                      _searchCtrl.text.isNotEmpty ? 'Cash & Bank transaction not found' : 'No cash & bank transactions yet',
                      style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle),
                    ))),
                    bar,
                  ]);
                }

                return Column(children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.fetchList(status: _selectedStatus, noteType: _selectedNoteType),
                      color: colorPrimary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        itemCount: ctrl.pageItems.length,
                        itemBuilder: (_, i) {
                          final cb = ctrl.pageItems[i];
                          return CashBankListItem(
                            cb: cb,
                            selectionMode: _selectionMode,
                            isSelected: ctrl.selectedEncryptions.contains(cb.encryption),
                            onSelectChanged: (_) => ctrl.toggleSelect(cb.encryption),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CashBankDetailScreen(encryption: cb.encryption)),
                            ).then((_) => ctrl.fetchList(status: _selectedStatus, noteType: _selectedNoteType)),
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
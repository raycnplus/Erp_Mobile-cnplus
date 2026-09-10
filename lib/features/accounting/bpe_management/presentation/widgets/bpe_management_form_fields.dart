import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/controllers/bpe_management_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/models/bpe_management_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class BpeManagementFormFields extends StatefulWidget {
  final BpeFormModel formData;
  final VoidCallback onSave;
  final bool isSaving;

  const BpeManagementFormFields({
    super.key,
    required this.formData,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<BpeManagementFormFields> createState() => _State();
}

class _State extends State<BpeManagementFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _bpeNumberCtrl = TextEditingController();
  final _yearCtrl      = TextEditingController();
  final _noteCtrl      = TextEditingController();

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _bpeNumberCtrl.text = widget.formData.bpeNumber;
    _yearCtrl.text      = widget.formData.periodYear?.toString() ?? '';
    _noteCtrl.text      = widget.formData.note ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _bpeNumberCtrl.dispose();
    _yearCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.bpeNumber = _bpeNumberCtrl.text.trim();
    widget.formData.note      = _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim();
    final yearVal = int.tryParse(_yearCtrl.text.trim());
    widget.formData.periodYear = yearVal;

    if (widget.formData.bpeNumber.isEmpty) { _snack('Please enter BPE number'); return false; }
    if (widget.formData.periodMonth == null) { _snack('Please select period month'); return false; }
    if (yearVal == null || _yearCtrl.text.trim().length != 4) { _snack('Please enter a valid 4-digit year'); return false; }
    if (widget.formData.transactions.isEmpty) { _snack('Please add at least one transaction'); return false; }
    return true;
  }

  Future<void> _addTransaction() async {
    final ctrl = context.read<BpeManagementController>();
    final invoices = await ctrl.fetchAvailableInvoices(exceptBpeId: widget.formData.idBpe);
    if (!mounted) return;

    final existingKeys = widget.formData.transactions
        .map((t) => '${t.transactionType}:${t.idInvoice}')
        .toSet();
    final selectable = invoices
        .where((inv) => !existingKeys.contains('${inv.transactionType}:${inv.idInvoice}'))
        .toList();

    if (selectable.isEmpty) {
      _snack('No available invoices to add');
      return;
    }

    final searchCtrl = TextEditingController();
    List<BpeAvailableInvoice> filtered = List.of(selectable);

    final result = await showDialog<BpeAvailableInvoice>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text('Add Invoice', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            height: 420,
            child: Column(
              children: [
                TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search reference...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (q) => setSt(() {
                    final ql = q.toLowerCase();
                    filtered = selectable
                        .where((inv) => (inv.invoiceNumber ?? '').toLowerCase().contains(ql))
                        .toList();
                  }),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text('No matches', style: GoogleFonts.poppins(color: colorGrey)))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final inv = filtered[i];
                            return ListTile(
                              dense: true,
                              title: Text(inv.invoiceNumber ?? '-', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                '${inv.isServiceInvoice ? "Service Invoice" : "Invoice"} • ${inv.customerName ?? "-"}',
                                style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                              ),
                              trailing: Text(
                                NumberFormat('#,##0', 'id_ID').format(inv.grandTotal),
                                style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary, fontWeight: FontWeight.w600),
                              ),
                              onTap: () => Navigator.pop(ctx, inv),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorGreyDark)),
            ),
          ],
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => widget.formData.transactions.add(result.toTransaction()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Header'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(child: Text('Transactions', overflow: TextOverflow.ellipsis)),
                  if (widget.formData.transactions.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.formData.transactions.length}',
                        style: GoogleFonts.poppins(fontSize: 10, color: colorWhite, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildHeaderTab(),
              _buildTransactionsTab(),
            ],
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildHeaderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(
            controller: _bpeNumberCtrl,
            label: 'BPE Number',
            hintText: 'Enter BPE number',
            required: true,
          ),
          const SizedBox(height: 14),

          _sectionLabel('BPE Date'),
          _datePicker(
            value: widget.formData.bpeDate,
            hint: 'Select BPE date (optional)',
            onPicked: (d) => setState(() => widget.formData.bpeDate = d),
          ),
          const SizedBox(height: 14),

          _sectionLabel('Period Month *'),
          const SizedBox(height: 6),
          _monthPicker(),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _yearCtrl,
            label: 'Period Year',
            hintText: 'e.g. ${DateTime.now().year}',
            required: true,
            keyboardType: TextInputType.number,
            onChanged: (v) => widget.formData.periodYear = int.tryParse(v),
          ),
          const SizedBox(height: 14),

          CustomFormInput(
            controller: _noteCtrl,
            label: 'Note',
            hintText: 'Write note for this BPE (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _monthPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorGreyLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: widget.formData.periodMonth,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          icon: const Icon(Icons.keyboard_arrow_down, color: colorGrey),
          style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary),
          items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(_months[i]))),
          onChanged: (v) => setState(() => widget.formData.periodMonth = v),
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    final ctrl = context.read<BpeManagementController>();
    return Column(
      children: [
        Expanded(
          child: widget.formData.transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long_outlined, size: 64, color: colorGrey),
                      const SizedBox(height: 12),
                      Text('No transactions added', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
                      const SizedBox(height: 4),
                      Text(
                        'Add invoices or service invoices to this BPE',
                        style: GoogleFonts.poppins(fontSize: 12, color: colorGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addTransaction,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text('Add Invoice', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          foregroundColor: colorWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                  itemCount: widget.formData.transactions.length,
                  itemBuilder: (_, i) => _buildTransactionCard(i),
                ),
        ),
        if (widget.formData.transactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: ctrl.isSearchingInvoices ? null : _addTransaction,
                icon: ctrl.isSearchingInvoices
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                      )
                    : const Icon(Icons.add, size: 18),
                label: Text('Add Invoice', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        if (widget.formData.transactions.isNotEmpty) _buildTotalsFooter(),
      ],
    );
  }

  Widget _buildTransactionCard(int i) {
    final t = widget.formData.transactions[i];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                t.isServiceInvoice ? Icons.build_outlined : Icons.receipt_outlined,
                color: colorPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.invoiceNumber ?? 'Invoice #${t.idInvoice}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary),
                  ),
                  Text(
                    t.customerName ?? '-',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(t.grandTotal)}',
                    style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
              onPressed: () => setState(() => widget.formData.transactions.removeAt(i)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsFooter() {
    final total = widget.formData.transactions.fold<double>(0, (s, t) => s + t.grandTotal);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      color: colorCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Amount', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
          Text(
            'Rp ${NumberFormat('#,##0.00', 'id_ID').format(total)}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorPrimary),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
  );

  Widget _datePicker({
    required DateTime? value,
    required String hint,
    required ValueChanged<DateTime> onPicked,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime(DateTime.now().year + 3),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: value != null ? colorPrimary : colorGreyLight, width: value != null ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: value != null ? colorPrimary : colorGrey),
            const SizedBox(width: 8),
            Text(
              value != null ? DateFormat('d MMM yyyy').format(value) : hint,
              style: GoogleFonts.poppins(fontSize: 13, color: value != null ? colorTextPrimary : colorGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(
      color: colorCard,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
        icon: widget.isSaving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
            : const Icon(Icons.save_outlined, size: 18),
        label: Text(
          widget.formData.isEditMode ? 'Update BPE' : 'Save BPE',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: colorPrimary,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    ),
  );
}
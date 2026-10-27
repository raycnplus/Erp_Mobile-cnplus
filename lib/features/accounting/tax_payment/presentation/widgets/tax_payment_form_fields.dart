import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/models/tax_payment_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class TaxPaymentFormFields extends StatefulWidget {
  final TaxPaymentFormModel formData;
  final Future<List<TaxTransactionOption>> Function(String term) onSearchTransactions;
  final VoidCallback onSave;
  final bool isSaving;

  const TaxPaymentFormFields({
    super.key,
    required this.formData,
    required this.onSearchTransactions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<TaxPaymentFormFields> createState() => _State();
}

class _State extends State<TaxPaymentFormFields> {
  final _refCtrl    = TextEditingController();
  final _signerCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();

  @override
  void initState() {
    super.initState();
    final f = widget.formData;
    _refCtrl.text    = f.taxReferenceNumber ?? '';
    _signerCtrl.text = f.signerName ?? '';
    _amountCtrl.text = f.amount > 0 ? f.amount.toStringAsFixed(2) : '';
    _noteCtrl.text   = f.note ?? '';
  }

  @override
  void dispose() {
    _refCtrl.dispose();
    _signerCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  bool _validateAndSync() {
    final f = widget.formData;
    f.taxReferenceNumber = _trimOrNull(_refCtrl);
    f.signerName         = _trimOrNull(_signerCtrl);
    f.note               = _trimOrNull(_noteCtrl);
    f.amount             = double.tryParse(_amountCtrl.text.trim()) ?? 0;

    if (f.idTransaction == null || f.transactionType == null) {
      _snack('Please select a transaction');
      return false;
    }
    if (f.amount < 0) {
      _snack('Amount cannot be negative');
      return false;
    }
    return true;
  }

  Future<void> _pickTransaction() async {
    final picked = await showModalBottomSheet<TaxTransactionOption>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _TransactionSearchSheet(onSearch: widget.onSearchTransactions),
    );
    if (picked == null || !mounted) return;

    setState(() {
      final f = widget.formData;
      f.transactionType   = picked.transactionType;
      f.idTransaction     = picked.idTransaction;
      f.transactionNumber = picked.transactionNumber;
      f.idCustomer        = picked.idCustomer;
      f.customerName      = picked.customerName;
      f.paymentStatus     = picked.paymentStatus;
      f.amount            = picked.amount;
      _amountCtrl.text    = picked.amount > 0 ? picked.amount.toStringAsFixed(2) : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.formData;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _sectionLabel('Transaction'),
                _transactionField(),
                const SizedBox(height: 14),
                CustomFormInput(
                  controller: _refCtrl,
                  label: 'e-Billing Number',
                  hintText: 'Required before posting',
                ),
                const SizedBox(height: 14),
                _sectionLabel('Payment Date'),
                _datePicker(
                  value: f.paymentDate,
                  hint: 'Select payment date',
                  onPicked: (d) => setState(() => f.paymentDate = d),
                  onClear: () => setState(() => f.paymentDate = null),
                ),
                const SizedBox(height: 14),
                CustomFormInput(
                  controller: _signerCtrl,
                  label: 'Signer Name',
                  hintText: 'Optional',
                ),
                const SizedBox(height: 14),
                CustomFormInput(
                  controller: _amountCtrl,
                  label: 'Amount',
                  hintText: '0',
                  enabled: false,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 14),
                CustomFormInput(
                  controller: _noteCtrl,
                  label: 'Note',
                  hintText: 'Optional',
                  maxLines: 3,
                ),
                const SizedBox(height: 6),
                Text(
                  'Posting is done from the detail screen. e-Billing Number and Payment Date must be filled first.',
                  style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _transactionField() {
    final f = widget.formData;
    final hasValue = f.idTransaction != null;
    return GestureDetector(
      onTap: _pickTransaction,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasValue ? colorPrimary : colorGreyLight,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.receipt_long_outlined, size: 18, color: hasValue ? colorPrimary : colorGrey),
            const SizedBox(width: 10),
            Expanded(
              child: hasValue
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.transactionNumber ?? '-',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorTextPrimary,
                          ),
                        ),
                        Text(
                          '${taxTransactionTypeLabel(f.transactionType)} • ${f.customerName ?? '-'}',
                          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (f.paymentStatus?.isNotEmpty == true)
                          Text(
                            f.paymentStatus!,
                            style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary),
                          ),
                      ],
                    )
                  : Text(
                      'Select Invoice / Service Invoice',
                      style: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                    ),
            ),
            const Icon(Icons.search, size: 18, color: colorGrey),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorCard,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2)),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSave(); },
            icon: widget.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
                  )
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode ? 'Update Draft' : 'Save as Draft',
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

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorTextPrimary,
          ),
        ),
      );

  Widget _datePicker({
    required DateTime? value,
    required String hint,
    required ValueChanged<DateTime> onPicked,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(DateTime.now().year + 1, 12, 31),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: colorPrimary),
            ),
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
          border: Border.all(
            color: value != null ? colorPrimary : colorGreyLight,
            width: value != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: value != null ? colorPrimary : colorGrey,
            ),
            const SizedBox(width: 8),
            Text(
              value != null ? DateFormat('d MMM yyyy').format(value) : hint,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: value != null ? colorTextPrimary : colorGrey,
              ),
            ),
            const Spacer(),
            if (value != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 16, color: colorGrey),
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionSearchSheet extends StatefulWidget {
  final Future<List<TaxTransactionOption>> Function(String term) onSearch;

  const _TransactionSearchSheet({required this.onSearch});

  @override
  State<_TransactionSearchSheet> createState() => _TransactionSearchSheetState();
}

class _TransactionSearchSheetState extends State<_TransactionSearchSheet> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<TaxTransactionOption> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(v.trim()));
  }

  Future<void> _search(String term) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await widget.onSearch(term);
      if (!mounted) return;
      setState(() => _items = r);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _error = e.toString().replaceFirst('Exception:', '').trim();
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: colorGreyLight, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'Search invoice reference...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                  prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                  filled: true,
                  fillColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: colorPrimary))
                  : _error != null
                      ? Center(child: Text(_error!, style: GoogleFonts.poppins(color: colorError)))
                      : _items.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Text(
                                  'No eligible transactions found.\nThe invoice payment must be Posted with PPN applied.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(fontSize: 13, color: colorTextSubtle),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: colorGreyLight),
                              itemBuilder: (_, i) {
                                final t = _items[i];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                  title: Text(
                                    t.transactionNumber,
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${t.typeLabel} • ${t.customerName ?? '-'}\n${t.paymentStatus ?? ''}',
                                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                                  ),
                                  isThreeLine: true,
                                  trailing: Text(
                                    'Rp ${_fmtNum(t.amount)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: colorPrimary,
                                    ),
                                  ),
                                  onTap: () => Navigator.pop(context, t),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
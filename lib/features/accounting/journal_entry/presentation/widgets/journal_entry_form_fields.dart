import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/models/journal_entry_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class JournalEntryFormFields extends StatefulWidget {
  final JournalEntryFormModel formData;
  final JournalEntryFormOptions? formOptions;
  final void Function(String action) onSubmit;
  final bool isSaving;

  const JournalEntryFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSubmit,
    this.isSaving = false,
  });

  @override
  State<JournalEntryFormFields> createState() => _State();
}

class _State extends State<JournalEntryFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _descCtrl = TextEditingController();
  final _pphBillingCtrl = TextEditingController();
  final _pphSignerCtrl = TextEditingController();
  final Map<int, TextEditingController> _debitCtrls = {};
  final Map<int, TextEditingController> _creditCtrls = {};
  bool _showPph = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _descCtrl.text = widget.formData.description ?? '';
    _pphBillingCtrl.text = widget.formData.pph25BillingNumber ?? '';
    _pphSignerCtrl.text = widget.formData.pph25SignerName ?? '';
    _showPph = widget.formData.pph25BillingNumber?.isNotEmpty == true ||
        widget.formData.pph25PaymentDate != null ||
        widget.formData.pph25SignerName?.isNotEmpty == true;
  }

  @override
  void dispose() {
    _tab.dispose();
    _descCtrl.dispose();
    _pphBillingCtrl.dispose();
    _pphSignerCtrl.dispose();
    for (final c in _debitCtrls.values) c.dispose();
    for (final c in _creditCtrls.values) c.dispose();
    super.dispose();
  }

  JournalEntryFormOptions? get _opts => widget.formOptions;

  double get _totalDebit => widget.formData.totalDebit;
  double get _totalCredit => widget.formData.totalCredit;
  bool get _isBalanced => widget.formData.isBalanced;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.description = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    widget.formData.pph25BillingNumber = _pphBillingCtrl.text.trim().isEmpty ? null : _pphBillingCtrl.text.trim();
    widget.formData.pph25SignerName = _pphSignerCtrl.text.trim().isEmpty ? null : _pphSignerCtrl.text.trim();

    if (widget.formData.journalDate == null) { _snack('Please select journal date'); return false; }
    if (widget.formData.details.isEmpty) { _snack('Please add at least one entry'); return false; }

    for (int i = 0; i < widget.formData.details.length; i++) {
      final d = widget.formData.details[i];
      if (d.idCoa == null) { _snack('Row ${i + 1}: Please select COA'); return false; }
      if (d.debit <= 0 && d.credit <= 0) { _snack('Row ${i + 1}: Fill either Debit or Credit'); return false; }
    }
    return true;
  }

  void _addDetailRow() {
    setState(() {
      widget.formData.details.add(JournalEntryFormDetail());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: [
            const Tab(text: 'Header'),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Flexible(child: Text('Entries', overflow: TextOverflow.ellipsis)),
              if (widget.formData.details.isNotEmpty) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(10)),
                  child: Text('${widget.formData.details.length}', style: GoogleFonts.poppins(fontSize: 10, color: colorWhite, fontWeight: FontWeight.w600)),
                ),
              ],
            ])),
          ],
        ),
        Expanded(child: TabBarView(controller: _tab, children: [_buildHeaderTab(), _buildDetailsTab()])),
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
          _sectionLabel('Journal Date'),
          _datePicker(
            value: widget.formData.journalDate,
            hint: 'Select journal date',
            onPicked: (d) => setState(() => widget.formData.journalDate = d),
          ),
          const SizedBox(height: 14),

          CustomFormInput(controller: _descCtrl, label: 'Description', hintText: 'Short description (optional)', maxLines: 3),
          const SizedBox(height: 14),

          InkWell(
            onTap: () => setState(() => _showPph = !_showPph),
            child: Row(
              children: [
                Icon(_showPph ? Icons.expand_less : Icons.expand_more, color: colorPrimary, size: 20),
                const SizedBox(width: 4),
                Text('PPh 25 Information (optional)', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colorPrimary)),
              ],
            ),
          ),
          if (_showPph) ...[
            const SizedBox(height: 12),
            CustomFormInput(controller: _pphBillingCtrl, label: 'PPh 25 Billing Number', hintText: 'e.g. NTPN number'),
            const SizedBox(height: 14),
            _sectionLabel('PPh 25 Payment Date'),
            _datePicker(
              value: widget.formData.pph25PaymentDate,
              hint: 'Select payment date (optional)',
              onPicked: (d) => setState(() => widget.formData.pph25PaymentDate = d),
            ),
            const SizedBox(height: 14),
            CustomFormInput(controller: _pphSignerCtrl, label: 'PPh 25 Signer Name', hintText: 'e.g. Finance manager name'),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Column(
      children: [
        Container(
          color: colorCard,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Debit: ${_fmtNum(_totalDebit)}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(width: 10),
                      Text('Credit: ${_fmtNum(_totalCredit)}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      _isBalanced ? 'Balanced' : 'Not balanced (difference: ${_fmtNum((_totalDebit - _totalCredit).abs())})',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _isBalanced ? Colors.green : Colors.orange),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addDetailRow,
                icon: const Icon(Icons.add, size: 16),
                label: Text('Add', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  foregroundColor: colorPrimary,
                  side: const BorderSide(color: colorPrimary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.formData.details.isEmpty
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.menu_book_outlined, size: 64, color: colorGrey),
                    const SizedBox(height: 12),
                    Text('No entries', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
                    const SizedBox(height: 4),
                    Text('Add debit/credit entries for this journal', style: GoogleFonts.poppins(fontSize: 12, color: colorGrey), textAlign: TextAlign.center),
                  ]),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  itemCount: widget.formData.details.length,
                  itemBuilder: (_, i) => _buildDetailCard(i),
                ),
        ),
      ],
    );
  }

  void _removeRow(int i) {
    setState(() {
      _debitCtrls[i]?.dispose();
      _debitCtrls.remove(i);
      _creditCtrls[i]?.dispose();
      _creditCtrls.remove(i);
      widget.formData.details.removeAt(i);

      final shiftedDebit = <int, TextEditingController>{};
      _debitCtrls.forEach((k, v) => shiftedDebit[k > i ? k - 1 : k] = v);
      _debitCtrls..clear()..addAll(shiftedDebit);

      final shiftedCredit = <int, TextEditingController>{};
      _creditCtrls.forEach((k, v) => shiftedCredit[k > i ? k - 1 : k] = v);
      _creditCtrls..clear()..addAll(shiftedCredit);
    });
  }

  Widget _buildDetailCard(int i) {
    final d = widget.formData.details[i];
    final debitCtrl = _debitCtrls.putIfAbsent(i, () => TextEditingController(text: d.debit > 0 ? d.debit.toStringAsFixed(2) : ''));
    final creditCtrl = _creditCtrls.putIfAbsent(i, () => TextEditingController(text: d.credit > 0 ? d.credit.toStringAsFixed(2) : ''));

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text('Entry ${i + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: colorTextPrimary))),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: colorError, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _removeRow(i),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomSearchableDropdown<JECoaOption>(
              key: ValueKey('detail_coa_${i}_${d.idCoa}'),
              value: _opts?.coaList.where((c) => c.idCoa == d.idCoa).firstOrNull,
              items: _opts?.coaList ?? [],
              itemLabel: (c) => c.display,
              onChanged: (v) => setState(() {
                d.idCoa = v?.idCoa;
                d.coaName = v?.coaName;
              }),
              label: 'COA',
              isRequired: true,
              clearable: false,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomFormInput(
                    controller: debitCtrl,
                    label: 'Debit',
                    hintText: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => setState(() => d.debit = double.tryParse(v) ?? 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomFormInput(
                    controller: creditCtrl,
                    label: 'Credit',
                    hintText: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => setState(() => d.credit = double.tryParse(v) ?? 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(color: colorCard, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSubmit('save'); },
            icon: widget.isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                : const Icon(Icons.save_outlined, size: 18),
            label: Text(
              widget.formData.isEditMode ? 'Update' : 'Save',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: colorPrimary, foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0,
            ),
          ),
        ),
      );

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: colorTextPrimary)),
      );

  Widget _datePicker({required DateTime? value, required String hint, required ValueChanged<DateTime> onPicked}) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context, initialDate: value ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 1), lastDate: DateTime(DateTime.now().year + 3),
          builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)), child: child!),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorBackground, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: value != null ? colorPrimary : colorGreyLight, width: value != null ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: value != null ? colorPrimary : colorGrey),
          const SizedBox(width: 8),
          Text(value != null ? DateFormat('d MMM yyyy').format(value) : hint, style: GoogleFonts.poppins(fontSize: 13, color: value != null ? colorTextPrimary : colorGrey)),
        ]),
      ),
    );
  }

  String _fmtNum(double v) => NumberFormat('#,##0.00', 'id_ID').format(v);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
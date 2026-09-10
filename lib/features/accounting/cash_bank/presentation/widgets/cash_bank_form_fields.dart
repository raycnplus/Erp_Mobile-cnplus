import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/models/cash_bank_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class CashBankFormFields extends StatefulWidget {
  final CashBankFormModel formData;
  final CashBankFormOptions? formOptions;
  final void Function(String action) onSubmit;
  final bool isSaving;

  const CashBankFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSubmit,
    this.isSaving = false,
  });

  @override
  State<CashBankFormFields> createState() => _State();
}

class _State extends State<CashBankFormFields> with TickerProviderStateMixin {
  late TabController _tab;
  final _descCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final Map<int, TextEditingController> _amountCtrls = {};
  final Map<int, TextEditingController> _entryDescCtrls = {};

  static const _noteTypeLabels = {
    'BANK_DEBIT': 'Bank Debit', 'BANK_CREDIT': 'Bank Credit',
    'CASH_DEBIT': 'Cash Debit', 'CASH_CREDIT': 'Cash Credit',
  };

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _descCtrl.text = widget.formData.description ?? '';
    _notesCtrl.text = widget.formData.notes ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _descCtrl.dispose();
    _notesCtrl.dispose();
    for (final c in _amountCtrls.values) c.dispose();
    for (final c in _entryDescCtrls.values) c.dispose();  
    super.dispose();
  }

  CashBankFormOptions? get _opts => widget.formOptions;

  double get _detailDebit => widget.formData.details.where((d) => d.type == 'DEBIT').fold(0.0, (s, d) => s + d.amount);
  double get _detailCredit => widget.formData.details.where((d) => d.type == 'CREDIT').fold(0.0, (s, d) => s + d.amount);

  bool get _isBalanced {
    final noteType = widget.formData.noteType;
    if (noteType.endsWith('_DEBIT')) return _detailCredit - _detailDebit > 0;
    if (noteType.endsWith('_CREDIT')) return _detailDebit - _detailCredit > 0;
    return false;
  }

  String get _balanceHint {
    final noteType = widget.formData.noteType;
    if (noteType.endsWith('_DEBIT')) return 'Net Credit must exceed net Debit for Debit note type';
    return 'Net Debit must exceed net Credit for Credit note type';
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    widget.formData.description = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    widget.formData.notes = _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim();

    if (widget.formData.transactionDate == null) { _snack('Please select transaction date'); return false; }
    if (widget.formData.cashbankCoaId == null) { _snack('Please select Cash/Bank account'); return false; }
    if (widget.formData.details.isEmpty) { _snack('Please add at least one entry'); return false; }

    for (int i = 0; i < widget.formData.details.length; i++) {
      final d = widget.formData.details[i];
      if (d.idCoa == null) { _snack('Row ${i + 1}: Please select COA'); return false; }
      if (d.amount <= 0) { _snack('Row ${i + 1}: Amount must be > 0'); return false; }
    }

    if (!_isBalanced) { _snack(_balanceHint); return false; }
    return true;
  }

  void _addDetailRow() {
    setState(() {
      widget.formData.details.add(CashBankFormDetail(type: 'DEBIT'));
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
          DropdownButtonFormField<String>(
            value: widget.formData.noteType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Note Type',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: colorBackground,
            ),
            items: (_opts?.noteTypes ?? ['BANK_DEBIT', 'BANK_CREDIT', 'CASH_DEBIT', 'CASH_CREDIT'])
                .map((t) => DropdownMenuItem(
                      value: t,
                      child: Text(_noteTypeLabels[t] ?? t, style: GoogleFonts.poppins(fontSize: 13)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => widget.formData.noteType = v ?? widget.formData.noteType),
          ),
          const SizedBox(height: 16),

          CustomSearchableDropdown<CoaOption>(
            key: ValueKey('coa_${widget.formData.cashbankCoaId}_${_opts?.coaList.length}'),
            value: _opts?.coaList.where((c) => c.idCoa == widget.formData.cashbankCoaId).firstOrNull,
            items: _opts?.coaList ?? [],
            itemLabel: (c) => c.display,
            onChanged: (v) => setState(() => widget.formData.cashbankCoaId = v?.idCoa),
            label: 'Cash/Bank Account',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),

          _sectionLabel('Transaction Date'),
          _datePicker(
            value: widget.formData.transactionDate,
            hint: 'Select transaction date',
            onPicked: (d) => setState(() => widget.formData.transactionDate = d),
          ),
          const SizedBox(height: 14),

          CustomSearchableDropdown<CBProjectOption>(
            key: ValueKey('proj_${widget.formData.projectId}_${_opts?.projects.length}'),
            value: _opts?.projects.where((p) => p.idProject == widget.formData.projectId).firstOrNull,
            items: _opts?.projects ?? [],
            itemLabel: (p) => p.projectName,
            onChanged: (v) => setState(() => widget.formData.projectId = v?.idProject),
            label: 'Project',
          ),
          const SizedBox(height: 14),

          CustomFormInput(controller: _descCtrl, label: 'Description', hintText: 'Short description (optional)'),
          const SizedBox(height: 14),

          CustomFormInput(controller: _notesCtrl, label: 'Notes', hintText: 'Additional notes (optional)', maxLines: 3),
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
                      Text('Debit: ${_fmtNum(_detailDebit)}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                      const SizedBox(width: 10),
                      Text('Credit: ${_fmtNum(_detailCredit)}', style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                    ]),
                    const SizedBox(height: 2),
                    Text(
                      _isBalanced ? 'Balanced' : _balanceHint,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _isBalanced ? Colors.green : Colors.green),
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
                    const Icon(Icons.receipt_long_outlined, size: 64, color: colorGrey),
                    const SizedBox(height: 12),
                    Text('No entries', style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle)),
                    const SizedBox(height: 4),
                    Text('Add debit/credit entries for this transaction', style: GoogleFonts.poppins(fontSize: 12, color: colorGrey), textAlign: TextAlign.center),
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

  Widget _buildDetailCard(int i) {
    final d = widget.formData.details[i];
    final amountCtrl = _amountCtrls.putIfAbsent(i, () => TextEditingController(text: d.amount > 0 ? d.amount.toStringAsFixed(2) : ''));
    final descCtrl = _entryDescCtrls.putIfAbsent(i, () => TextEditingController(text: d.description ?? ''));

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
                  onPressed: () => setState(() {
                    _amountCtrls[i]?.dispose();
                    _amountCtrls.remove(i);
                    _entryDescCtrls[i]?.dispose();
                    _entryDescCtrls.remove(i);
                    widget.formData.details.removeAt(i);

                    final shiftedAmount = <int, TextEditingController>{};
                    _amountCtrls.forEach((k, v) => shiftedAmount[k > i ? k - 1 : k] = v);
                    _amountCtrls..clear()..addAll(shiftedAmount);

                    final shiftedDesc = <int, TextEditingController>{};
                    _entryDescCtrls.forEach((k, v) => shiftedDesc[k > i ? k - 1 : k] = v);
                    _entryDescCtrls..clear()..addAll(shiftedDesc);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomSearchableDropdown<CoaOption>(
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
            Row(children: [
              Expanded(child: _typeChip(d, 'DEBIT')),
              const SizedBox(width: 8),
              Expanded(child: _typeChip(d, 'CREDIT')),
            ]),
            const SizedBox(height: 8),
            CustomFormInput(
              controller: amountCtrl,
              label: 'Amount *',
              hintText: '0',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) => setState(() => d.amount = double.tryParse(v) ?? 0),
            ),
            const SizedBox(height: 8),
            CustomFormInput(
              controller: descCtrl,
              label: 'Description',
              hintText: 'Entry description (optional)',
              onChanged: (v) => d.description = v.trim().isEmpty ? null : v.trim(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(CashBankFormDetail d, String type) {
    final isSelected = d.type == type;
    final color = type == 'DEBIT' ? colorPrimary : Colors.green.shade700;
    return GestureDetector(
      onTap: () => setState(() => d.type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : colorBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? color : colorGreyLight),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? colorWhite : colorTextPrimary),
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/models/asset_disposal_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class AssetDisposalFormFields extends StatefulWidget {
  final AssetDisposalFormModel formData;
  final AssetDisposalFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const AssetDisposalFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<AssetDisposalFormFields> createState() => _State();
}

class _State extends State<AssetDisposalFormFields> {
  final _valueCtrl  = TextEditingController();
  final _reasonCtrl = TextEditingController();

  static const _defaultMethods = ['sold', 'scrap', 'lost'];

  @override
  void initState() {
    super.initState();
    final f = widget.formData;
    _valueCtrl.text  = f.disposalValue > 0 ? f.disposalValue.toStringAsFixed(2) : '';
    _reasonCtrl.text = f.reason ?? '';
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  AssetDisposalFormOptions? get _opts => widget.formOptions;

  DspAssetOption? get _selectedAsset =>
      _opts?.assets.where((a) => a.idFixedAsset == widget.formData.idFixedAsset).firstOrNull;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: colorError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    final f = widget.formData;
    f.reason        = _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim();
    f.disposalValue = double.tryParse(_valueCtrl.text.trim()) ?? 0;

    if (f.idFixedAsset == null)  { _snack('Please select asset');           return false; }
    if (f.disposalDate == null)  { _snack('Please select disposal date');   return false; }
    if (f.disposalMethod == null) { _snack('Please select disposal method'); return false; }
    if (f.isSold) {
      if (f.disposalValue < 0)   { _snack('Disposal value cannot be negative'); return false; }
      if (f.idBankAccount == null) { _snack('Please select bank account');   return false; }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.formData;
    final asset = _selectedAsset;
    final methods = (_opts?.disposalMethods.isNotEmpty == true) ? _opts!.disposalMethods : _defaultMethods;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSearchableDropdown<DspAssetOption>(
                  key: ValueKey('asset_${f.idFixedAsset}_${_opts?.assets.length}'),
                  value: asset,
                  items: _opts?.assets ?? [],
                  itemLabel: (a) => a.display,
                  onChanged: (v) => setState(() => f.idFixedAsset = v?.idFixedAsset),
                  isRequired: true,
                  label: 'Asset',
                  clearable: false,
                ),
                if (asset != null) ...[
                  const SizedBox(height: 10),
                  _assetInfo(asset),
                ],
                const SizedBox(height: 14),

                _sectionLabel('Disposal Date'),
                _datePicker(
                  value: f.disposalDate,
                  hint: 'Select disposal date',
                  onPicked: (d) => setState(() => f.disposalDate = d),
                ),
                const SizedBox(height: 14),

                CustomSearchableDropdown<String>(
                  key: ValueKey('method_${f.disposalMethod}'),
                  value: f.disposalMethod,
                  items: methods,
                  itemLabel: disposalMethodLabel,
                  onChanged: (v) => setState(() {
                    f.disposalMethod = v;
                    if (v != 'sold') {
                      f.idBankAccount = null;
                      f.disposalValue = 0;
                      _valueCtrl.clear();
                    }
                  }),
                  isRequired: true,
                  label: 'Disposal Method',
                  clearable: false,
                ),
                const SizedBox(height: 14),

                if (f.isSold) ...[
                  CustomFormInput(
                    controller: _valueCtrl,
                    label: 'Disposal Value',
                    hintText: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => setState(() => f.disposalValue = double.tryParse(v) ?? 0),
                  ),
                  const SizedBox(height: 14),
                  CustomSearchableDropdown<DspBankOption>(
                    key: ValueKey('bank_${f.idBankAccount}_${_opts?.bankAccounts.length}'),
                    value: _opts?.bankAccounts.where((b) => b.id == f.idBankAccount).firstOrNull,
                    items: _opts?.bankAccounts ?? [],
                    itemLabel: (b) => b.display,
                    onChanged: (v) => setState(() => f.idBankAccount = v?.id),
                    isRequired: true,
                    label: 'Bank Account',
                    clearable: false,
                  ),
                  const SizedBox(height: 14),
                ],

                if (asset != null) ...[
                  _estimateBox(asset),
                  const SizedBox(height: 14),
                ],

                CustomFormInput(
                  controller: _reasonCtrl,
                  label: 'Reason',
                  hintText: 'Optional',
                  maxLines: 3,
                ),
                const SizedBox(height: 6),
                Text(
                  'Confirm and Post are done from the detail screen after saving.',
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

  Widget _assetInfo(DspAssetOption a) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: colorPrimary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: colorPrimary.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Asset Value', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorPrimary)),
        const SizedBox(height: 4),
        Text('Acquisition Cost: Rp ${_fmtNum(a.acquisitionCost)}', style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
        Text('Accumulated Dep.: Rp ${_fmtNum(a.accumulatedDepreciation)}', style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
        Text('Book Value: Rp ${_fmtNum(a.bookValue)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: colorTextPrimary)),
      ],
    ),
  );

  Widget _estimateBox(DspAssetOption a) {
    final f = widget.formData;
    final proceeds = f.isSold ? f.disposalValue : 0.0;
    final est = proceeds - a.bookValue;
    final color = est > 0 ? const Color(0xFF2E7D32) : est < 0 ? const Color(0xFFC62828) : colorTextSubtle;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Estimated Gain / (Loss)', style: GoogleFonts.poppins(fontSize: 12, color: color)),
          Text('Rp ${_fmtNum(est)}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
        ],
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
          ],
        ),
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
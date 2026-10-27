import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/models/asset_movement_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class AssetMovementFormFields extends StatefulWidget {
  final AssetMovementFormModel formData;
  final AssetMovementFormOptions? formOptions;
  final VoidCallback onSubmit;
  final bool isSaving;

  const AssetMovementFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSubmit,
    this.isSaving = false,
  });

  @override
  State<AssetMovementFormFields> createState() => _State();
}

class _State extends State<AssetMovementFormFields> {
  final _locationCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();

  @override
  void dispose() {
    _locationCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  AssetMovementFormOptions? get _opts => widget.formOptions;

  AMAssetOption? get _selectedAsset {
    final id = widget.formData.idFixedAsset;
    if (id == null) return null;
    for (final a in _opts?.assets ?? <AMAssetOption>[]) {
      if (a.idFixedAsset == id) return a;
    }
    return null;
  }

  AMEmployeeOption? _findEmployee(int? id) {
    if (id == null) return null;
    for (final e in _opts?.employees ?? <AMEmployeeOption>[]) {
      if (e.idEmployee == id) return e;
    }
    return null;
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    final f = widget.formData;
    f.toLocation = _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim();
    f.reason = _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim();

    final asset = _selectedAsset;
    if (asset == null) { _snack('Please select an asset'); return false; }
    if (f.movementDate == null) { _snack('Please select movement date'); return false; }
    if (f.toPicEmployee == null && f.toLocation == null) {
      _snack('Please specify a new PIC or a new location');
      return false;
    }

    final picChanged = f.toPicEmployee != null && f.toPicEmployee != asset.picEmployee;
    final locChanged = f.toLocation != null && f.toLocation != (asset.location ?? '');
    if (!picChanged && !locChanged) {
      _snack('The new PIC / location is the same as the current one');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.formData;
    final asset = _selectedAsset;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSearchableDropdown<AMAssetOption>(
                  key: ValueKey('asset_${f.idFixedAsset}'),
                  value: asset,
                  items: _opts?.assets ?? [],
                  itemLabel: (a) => a.display,
                  onChanged: (v) => setState(() => f.idFixedAsset = v?.idFixedAsset),
                  label: 'Asset',
                  isRequired: true,
                  clearable: false,
                ),
                if (asset != null) ...[
                  const SizedBox(height: 10),
                  _currentInfo(asset),
                ],
                const SizedBox(height: 14),
                _sectionLabel('Movement Date'),
                _datePicker(
                  value: f.movementDate,
                  hint: 'Select movement date',
                  onPicked: (d) => setState(() => f.movementDate = d),
                ),
                const SizedBox(height: 14),
                CustomSearchableDropdown<AMEmployeeOption>(
                  key: ValueKey('to_pic_${f.toPicEmployee}'),
                  value: _findEmployee(f.toPicEmployee),
                  items: _opts?.employees ?? [],
                  itemLabel: (e) => e.employeeName,
                  onChanged: (v) => setState(() => f.toPicEmployee = v?.idEmployee),
                  label: 'New PIC',
                  isRequired: false,
                  clearable: true,
                ),
                const SizedBox(height: 14),
                CustomFormInput(controller: _locationCtrl, label: 'New Location', hintText: 'e.g. Branch Office, 2nd floor'),
                const SizedBox(height: 6),
                Text('Fill at least one of New PIC or New Location. Empty fields keep the current value.',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
                const SizedBox(height: 14),
                CustomFormInput(controller: _reasonCtrl, label: 'Reason', hintText: 'Optional', maxLines: 3),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _currentInfo(AMAssetOption a) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: colorPrimary.withOpacity(0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: colorPrimary.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: colorPrimary)),
        const SizedBox(height: 4),
        Text('PIC: ${a.currentPicName?.isNotEmpty == true ? a.currentPicName! : '-'}',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
        Text('Location: ${a.location?.isNotEmpty == true ? a.location! : '-'}',
            style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
      ],
    ),
  );

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(color: colorCard, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSubmit(); },
        icon: widget.isSaving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
            : const Icon(Icons.swap_horiz_rounded, size: 18),
        label: Text('Move Asset', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
          firstDate: DateTime(2000), lastDate: DateTime(DateTime.now().year + 1, 12, 31),
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
}
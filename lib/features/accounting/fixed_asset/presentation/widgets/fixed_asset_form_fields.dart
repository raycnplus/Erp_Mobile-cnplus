import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/models/fixed_asset_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class FixedAssetFormFields extends StatefulWidget {
  final FixedAssetFormModel formData;
  final FixedAssetFormOptions? formOptions;
  final VoidCallback onSubmit;
  final bool isSaving;

  const FixedAssetFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSubmit,
    this.isSaving = false,
  });

  @override
  State<FixedAssetFormFields> createState() => _State();
}

class _State extends State<FixedAssetFormFields> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _salvageCtrl = TextEditingController();
  final _lifeCtrl = TextEditingController();

  static const _defaultMethods = ['straight_line', 'declining_balance'];
  static const _defaultStatuses = ['active', 'inactive', 'disposed'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    final f = widget.formData;
    _codeCtrl.text = f.assetCode ?? '';
    _nameCtrl.text = f.assetName ?? '';
    _serialCtrl.text = f.serialNumber ?? '';
    _locationCtrl.text = f.location ?? '';
    _notesCtrl.text = f.notes ?? '';
    _costCtrl.text = (f.acquisitionCost != null && f.acquisitionCost! > 0) ? f.acquisitionCost!.toStringAsFixed(2) : '';
    _salvageCtrl.text = f.salvageValue > 0 ? f.salvageValue.toStringAsFixed(2) : '';
    _lifeCtrl.text = f.usefulLifeMonths?.toString() ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    for (final c in [_codeCtrl, _nameCtrl, _serialCtrl, _locationCtrl, _notesCtrl, _costCtrl, _salvageCtrl, _lifeCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  FixedAssetFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  bool _validateAndSync() {
    final f = widget.formData;
    f.assetCode = _trimOrNull(_codeCtrl);
    f.assetName = _trimOrNull(_nameCtrl);
    f.serialNumber = _trimOrNull(_serialCtrl);
    f.location = _trimOrNull(_locationCtrl);
    f.notes = _trimOrNull(_notesCtrl);
    f.acquisitionCost = double.tryParse(_costCtrl.text.trim());
    f.salvageValue = double.tryParse(_salvageCtrl.text.trim()) ?? 0;
    f.usefulLifeMonths = int.tryParse(_lifeCtrl.text.trim());

    if (f.assetCode == null) { _tab.animateTo(0); _snack('Please enter asset code'); return false; }
    if (f.assetName == null) { _tab.animateTo(0); _snack('Please enter asset name'); return false; }
    if (f.assetCategory == null) { _tab.animateTo(0); _snack('Please select asset category'); return false; }
    if (f.acquisitionDate == null) { _tab.animateTo(1); _snack('Please select acquisition date'); return false; }
    if (f.acquisitionCost == null || f.acquisitionCost! < 0) { _tab.animateTo(1); _snack('Please enter a valid acquisition cost'); return false; }
    if (f.depreciationMethod == null) { _tab.animateTo(1); _snack('Please select depreciation method'); return false; }
    if (f.usefulLifeMonths == null || f.usefulLifeMonths! < 1) { _tab.animateTo(1); _snack('Useful life must be at least 1 month'); return false; }
    if (f.salvageValue < 0) { _tab.animateTo(1); _snack('Salvage value cannot be negative'); return false; }
    return true;
  }

  void _onCategoryChanged(FACategoryOption? c) {
    setState(() {
      final f = widget.formData;
      f.assetCategory = c?.idAssetCategory;
      if (c != null && !f.isEditMode) {
        f.usefulLifeMonths = c.defaultUsefulLifeMonths > 0 ? c.defaultUsefulLifeMonths : null;
        f.depreciationMethod = c.depreciationMethod;
        _lifeCtrl.text = f.usefulLifeMonths?.toString() ?? '';
      }
    });
  }

  FACategoryOption? _findCategory(int? id) {
    if (id == null) return null;
    for (final c in _opts?.categories ?? <FACategoryOption>[]) {
      if (c.idAssetCategory == id) return c;
    }
    return null;
  }

  FAEmployeeOption? _findEmployee(int? id) {
    if (id == null) return null;
    for (final e in _opts?.employees ?? <FAEmployeeOption>[]) {
      if (e.idEmployee == id) return e;
    }
    return null;
  }

  FADepartmentOption? _findDepartment(int? id) {
    if (id == null) return null;
    for (final d in _opts?.departments ?? <FADepartmentOption>[]) {
      if (d.idDepartment == id) return d;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'General'), Tab(text: 'Depreciation')],
        ),
        Expanded(child: TabBarView(controller: _tab, children: [_buildGeneralTab(), _buildDepreciationTab()])),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildGeneralTab() {
    final f = widget.formData;
    final statuses = (_opts?.assetStatuses.isNotEmpty == true) ? _opts!.assetStatuses : _defaultStatuses;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(controller: _codeCtrl, label: 'Asset Code', hintText: 'e.g. FA-0001'),
          const SizedBox(height: 14),
          CustomFormInput(controller: _nameCtrl, label: 'Asset Name', hintText: 'e.g. Laptop Dell Latitude'),
          const SizedBox(height: 14),
          CustomSearchableDropdown<FACategoryOption>(
            key: ValueKey('category_${f.assetCategory}'),
            value: _findCategory(f.assetCategory),
            items: _opts?.categories ?? [],
            itemLabel: (c) => c.display,
            onChanged: _onCategoryChanged,
            label: 'Asset Category',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomFormInput(controller: _serialCtrl, label: 'Serial Number', hintText: 'Optional'),
          const SizedBox(height: 14),
          CustomSearchableDropdown<FAEmployeeOption>(
            key: ValueKey('pic_${f.picEmployee}'),
            value: _findEmployee(f.picEmployee),
            items: _opts?.employees ?? [],
            itemLabel: (e) => e.employeeName,
            onChanged: (v) => setState(() => f.picEmployee = v?.idEmployee),
            label: 'PIC',
            isRequired: false,
            clearable: true,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<FADepartmentOption>(
            key: ValueKey('dept_${f.idDepartment}'),
            value: _findDepartment(f.idDepartment),
            items: _opts?.departments ?? [],
            itemLabel: (d) => d.departmentName,
            onChanged: (v) => setState(() => f.idDepartment = v?.idDepartment),
            label: 'Department',
            isRequired: false,
            clearable: true,
          ),
          const SizedBox(height: 14),
          CustomFormInput(controller: _locationCtrl, label: 'Location', hintText: 'e.g. Head Office, 3rd floor'),
          const SizedBox(height: 14),
          CustomSearchableDropdown<String>(
            key: ValueKey('status_${f.assetStatus}'),
            value: f.assetStatus,
            items: statuses,
            itemLabel: fixedAssetStatusLabel,
            onChanged: (v) => setState(() => f.assetStatus = v ?? 'active'),
            label: 'Status',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomFormInput(controller: _notesCtrl, label: 'Notes', hintText: 'Optional', maxLines: 3),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDepreciationTab() {
    final f = widget.formData;
    final methods = (_opts?.depreciationMethods.isNotEmpty == true) ? _opts!.depreciationMethods : _defaultMethods;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('Acquisition Date'),
          _datePicker(
            value: f.acquisitionDate,
            hint: 'Select acquisition date',
            onPicked: (d) => setState(() => f.acquisitionDate = d),
          ),
          const SizedBox(height: 14),
          CustomFormInput(
            controller: _costCtrl,
            label: 'Acquisition Cost',
            hintText: '0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<String>(
            key: ValueKey('method_${f.depreciationMethod}'),
            value: f.depreciationMethod,
            items: methods,
            itemLabel: fixedAssetMethodLabel,
            onChanged: (v) => setState(() => f.depreciationMethod = v),
            label: 'Depreciation Method',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 14),
          CustomFormInput(
            controller: _lifeCtrl,
            label: 'Useful Life (Months)',
            hintText: 'e.g. 48',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          CustomFormInput(
            controller: _salvageCtrl,
            label: 'Salvage Value',
            hintText: '0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: BoxDecoration(color: colorCard, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, -2))]),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isSaving ? null : () { if (_validateAndSync()) widget.onSubmit(); },
        icon: widget.isSaving
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
            : const Icon(Icons.save_outlined, size: 18),
        label: Text(widget.formData.isEditMode ? 'Update' : 'Save', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
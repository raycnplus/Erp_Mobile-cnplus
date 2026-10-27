import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/models/asset_category_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';

class AssetCategoryFormFields extends StatefulWidget {
  final AssetCategoryFormModel formData;
  final AssetCategoryFormOptions? formOptions;
  final VoidCallback onSubmit;
  final bool isSaving;

  const AssetCategoryFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSubmit,
    this.isSaving = false,
  });

  @override
  State<AssetCategoryFormFields> createState() => _State();
}

class _State extends State<AssetCategoryFormFields> with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _lifeCtrl = TextEditingController();

  static const _defaultMethods = ['straight_line', 'declining_balance'];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _nameCtrl.text = widget.formData.categoryName ?? '';
    _codeCtrl.text = widget.formData.categoryCode ?? '';
    _lifeCtrl.text = widget.formData.defaultUsefulLifeMonths?.toString() ?? '';
  }

  @override
  void dispose() {
    _tab.dispose();
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _lifeCtrl.dispose();
    super.dispose();
  }

  AssetCategoryFormOptions? get _opts => widget.formOptions;

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg), backgroundColor: colorError, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));

  bool _validateAndSync() {
    final f = widget.formData;
    f.categoryName = _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim();
    f.categoryCode = _codeCtrl.text.trim().isEmpty ? null : _codeCtrl.text.trim();
    f.defaultUsefulLifeMonths = int.tryParse(_lifeCtrl.text.trim());

    if (f.categoryName == null) { _snack('Please enter category name'); return false; }
    if (f.categoryCode == null) { _snack('Please enter category code'); return false; }
    if (f.defaultUsefulLifeMonths == null || f.defaultUsefulLifeMonths! < 1) {
      _snack('Useful life must be at least 1 month');
      return false;
    }
    if (f.depreciationMethod == null) { _snack('Please select depreciation method'); return false; }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary, unselectedLabelColor: colorTextSubtle, indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'General'), Tab(text: 'COA Mapping')],
        ),
        Expanded(child: TabBarView(controller: _tab, children: [_buildGeneralTab(), _buildCoaTab()])),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildGeneralTab() {
    final methods = (_opts?.depreciationMethods.isNotEmpty == true) ? _opts!.depreciationMethods : _defaultMethods;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomFormInput(controller: _nameCtrl, label: 'Category Name', hintText: 'e.g. Office Equipment'),
          const SizedBox(height: 14),
          CustomFormInput(controller: _codeCtrl, label: 'Category Code', hintText: 'e.g. OE'),
          const SizedBox(height: 14),
          CustomFormInput(
            controller: _lifeCtrl,
            label: 'Useful Life (Months)',
            hintText: 'e.g. 48',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          CustomSearchableDropdown<String>(
            key: ValueKey('method_${widget.formData.depreciationMethod}'),
            value: widget.formData.depreciationMethod,
            items: methods,
            itemLabel: assetCategoryMethodLabel,
            onChanged: (v) => setState(() => widget.formData.depreciationMethod = v),
            label: 'Depreciation Method',
            isRequired: true,
            clearable: false,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  AssetCoaOption? _findCoa(int? id) {
    if (id == null) return null;
    for (final c in _opts?.coaList ?? <AssetCoaOption>[]) {
      if (c.idCoa == id) return c;
    }
    return null;
  }

  Widget _coaDropdown(String label, int? current, ValueChanged<int?> onChanged) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: CustomSearchableDropdown<AssetCoaOption>(
      key: ValueKey('${label}_$current'),
      value: _findCoa(current),
      items: _opts?.coaList ?? [],
      itemLabel: (c) => c.display,
      onChanged: (v) => setState(() => onChanged(v?.idCoa)),
      label: label,
      isRequired: false,
      clearable: true,
    ),
  );

  Widget _buildCoaTab() {
    final f = widget.formData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('All COA mappings are optional here, but they are required when running depreciation or disposal.',
              style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle)),
          const SizedBox(height: 14),
          _coaDropdown('Asset COA (Debit)', f.coaAsset, (v) => f.coaAsset = v),
          _coaDropdown('Accumulated Depreciation COA (Credit)', f.coaAccumulatedDepreciation, (v) => f.coaAccumulatedDepreciation = v),
          _coaDropdown('Depreciation Expense COA (Debit)', f.coaDepreciationExpense, (v) => f.coaDepreciationExpense = v),
          _coaDropdown('Gain on Disposal COA (Credit)', f.coaDisposalGain, (v) => f.coaDisposalGain = v),
          _coaDropdown('Loss on Disposal COA (Debit)', f.coaDisposalLoss, (v) => f.coaDisposalLoss = v),
          const SizedBox(height: 10),
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
}
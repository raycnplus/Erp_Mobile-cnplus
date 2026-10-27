import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/models/asset_depreciation_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';

class AssetDepreciationFormFields extends StatefulWidget {
  final AssetDepreciationFormModel formData;
  final AssetDepreciationFormOptions? formOptions;
  final VoidCallback onSave;
  final bool isSaving;

  const AssetDepreciationFormFields({
    super.key,
    required this.formData,
    required this.formOptions,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  State<AssetDepreciationFormFields> createState() => _State();
}

class _State extends State<AssetDepreciationFormFields> {
  static final List<int> _months = List.generate(12, (i) => i + 1);

  List<int> get _years {
    final now = DateTime.now().year;
    return List.generate(7, (i) => now - 5 + i);
  }

  String _monthName(int m) => DateFormat('MMMM').format(DateTime(2000, m));

  int get _activeCount => widget.formOptions?.activeAssetCount ?? 0;

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
                CustomSearchableDropdown<int>(
                  key: ValueKey('month_${f.month}'),
                  value: f.month,
                  items: _months,
                  itemLabel: _monthName,
                  onChanged: (v) => setState(() => f.month = v ?? f.month),
                  label: 'Period (Month)',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 14),
                CustomSearchableDropdown<int>(
                  key: ValueKey('year_${f.year}'),
                  value: f.year,
                  items: _years,
                  itemLabel: (y) => y.toString(),
                  onChanged: (v) => setState(() => f.year = v ?? f.year),
                  label: 'Period (Year)',
                  isRequired: true,
                  clearable: false,
                ),
                const SizedBox(height: 16),
                _infoBox(
                  icon: Icons.inventory_2_outlined,
                  color: _activeCount > 0 ? colorPrimary : Colors.orange.shade700,
                  text: _activeCount > 0
                      ? '$_activeCount active asset(s) will be checked for depreciation.'
                      : 'No active assets found to depreciate.',
                ),
                const SizedBox(height: 10),
                _infoBox(
                  icon: Icons.info_outline,
                  color: colorTextSubtle,
                  text: 'Depreciation can only be run once per period. The journal is posted automatically on the last day of the month.',
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

  Widget _infoBox({required IconData icon, required Color color, required String text}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: color))),
      ],
    ),
  );

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
        onPressed: widget.isSaving || _activeCount == 0 ? null : widget.onSave,
        icon: widget.isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite),
              )
            : const Icon(Icons.play_arrow_rounded, size: 20),
        label: Text('Run Depreciation', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
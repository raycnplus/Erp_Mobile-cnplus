import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/models/location_models.dart';

class LocationFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final LocationFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final LocationDropdownData? dropdownData;
  final bool isLoadingDropdown;

  const LocationFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.dropdownData,
    required this.isLoadingDropdown,
  });

  @override
  State<LocationFormFields> createState() => _LocationFormFieldsState();
}

class _LocationFormFieldsState extends State<LocationFormFields> {
  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController lengthCtrl;
  late TextEditingController widthCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController volumeCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.locationName);
    codeCtrl = TextEditingController(text: widget.formData.locationCode);
    lengthCtrl = TextEditingController(
        text: (widget.formData.length == null || widget.formData.length == 0)
            ? ''
            : widget.formData.length.toString());
    widthCtrl = TextEditingController(
        text: (widget.formData.width == null || widget.formData.width == 0)
            ? ''
            : widget.formData.width.toString());
    heightCtrl = TextEditingController(
        text: (widget.formData.height == null || widget.formData.height == 0)
            ? ''
            : widget.formData.height.toString());
    volumeCtrl = TextEditingController(
        text: (widget.formData.volume == null || widget.formData.volume == 0)
            ? ''
            : widget.formData.volume.toString());
    descriptionCtrl = TextEditingController(text: widget.formData.description);

    lengthCtrl.addListener(_calculateVolume);
    widthCtrl.addListener(_calculateVolume);
    heightCtrl.addListener(_calculateVolume);
  }

  void _calculateVolume() {
    final l = num.tryParse(lengthCtrl.text) ?? 0;
    final w = num.tryParse(widthCtrl.text) ?? 0;
    final h = num.tryParse(heightCtrl.text) ?? 0;
    final v = l * w * h;
    volumeCtrl.text = v > 0 ? v.toStringAsFixed(2) : '';
  }

  void _saveAllFields() {
    widget.formData.locationName = nameCtrl.text;
    widget.formData.locationCode = codeCtrl.text;
    widget.formData.length = num.tryParse(lengthCtrl.text);
    widget.formData.width = num.tryParse(widthCtrl.text);
    widget.formData.height = num.tryParse(heightCtrl.text);
    widget.formData.volume = num.tryParse(volumeCtrl.text);
    widget.formData.description = descriptionCtrl.text;
  }

  @override
  void dispose() {
    nameCtrl.dispose(); codeCtrl.dispose(); lengthCtrl.dispose();
    widthCtrl.dispose(); heightCtrl.dispose(); volumeCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomFormInput(
                    controller: nameCtrl,
                    label: "Location Name",
                    required: true,
                    hintText: "Enter location name",
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? "Location name is required"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: codeCtrl,
                    label: "Location Code",
                    required: true,
                    hintText: "Enter location code",
                    validator: (_) => codeCtrl.text.trim().isEmpty
                        ? "Location code is required"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown<DropdownWarehouse>(
                    label: "Warehouse",
                    isRequired: true,
                    items: widget.dropdownData?.warehouses ?? [],
                    selectedId: widget.formData.warehouse,
                    itemLabel: (w) => w.name,
                    itemId: (w) => w.id,
                    onChanged: (val) =>
                        setState(() => widget.formData.warehouse = val?.id),
                    validator: (_) => widget.formData.validateWarehouse(),
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown<DropdownLocation>(
                    label: "Parent Location (Optional)",
                    items: widget.dropdownData?.parentLocations ?? [],
                    selectedId: widget.formData.parentLocation,
                    itemLabel: (l) => l.toString(),
                    itemId: (l) => l.id,
                    onChanged: (val) =>
                        setState(() => widget.formData.parentLocation = val?.id),
                  ),
                  const SizedBox(height: 24),

                  Text("Dimensions",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorBlack)),
                  const SizedBox(height: 12),
                  CustomFormInput(
                    controller: lengthCtrl,
                    label: "Length",
                    hintText: "Enter length",
                    suffixIcon: const Padding(padding: EdgeInsets.all(12),
                        child: Text('m', style: TextStyle(fontSize: 14, color: colorGrey))),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: widthCtrl,
                    label: "Width",
                    hintText: "Enter width",
                    suffixIcon: const Padding(padding: EdgeInsets.all(12),
                        child: Text('m', style: TextStyle(fontSize: 14, color: colorGrey))),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: heightCtrl,
                    label: "Height",
                    hintText: "Enter height",
                    suffixIcon: const Padding(padding: EdgeInsets.all(12),
                        child: Text('m', style: TextStyle(fontSize: 14, color: colorGrey))),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: volumeCtrl,
                    label: "Volume",
                    hintText: "Auto-calculated from L × W × H",
                    suffixIcon: const Padding(padding: EdgeInsets.all(12),
                        child: Text('m³', style: TextStyle(fontSize: 14, color: colorGrey))),
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: descriptionCtrl,
                    label: "Description",
                    hintText: "Enter description (optional)",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                  if (widget.isEditMode && widget.formData.createdDate != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorInfoLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorInfoBorder),
                      ),
                      child: Row(children: [
                        const Icon(Icons.info_outline, color: colorInfo, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('View audit trail in detail screen',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorInfo)),
                        ),
                      ]),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorCard,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveAllFields();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? "Update Location" : "Create Location",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    bool isRequired = false,
    required List<T> items,
    required int? selectedId,
    required String Function(T) itemLabel,
    required int Function(T) itemId,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    if (widget.isLoadingDropdown && items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary)),
          const SizedBox(height: 8),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: colorGreyLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorGreyLight),
            ),
            child: const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: colorPrimary),
              ),
            ),
          ),
        ],
      );
    }

    final selected = selectedId != null
        ? items.where((i) => itemId(i) == selectedId).firstOrNull
        : null;

    return KeyedSubtree(
      key: ValueKey('${label}_${items.length}'),
      child: CustomSearchableDropdown<T>(
        value: selected,
        items: items,
        itemLabel: itemLabel,
        onChanged: onChanged,
        label: label,
        isRequired: isRequired,
        validator: validator,
      ),
    );
  }
}
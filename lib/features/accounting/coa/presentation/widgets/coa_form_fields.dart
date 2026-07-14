import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_searchable_dropdown.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/models/coa_models.dart';

class CoaFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CoaFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;
  final CoaFormOptions? formOptions;
  final bool isLoadingFormOptions;
  final int? autonumber;
  final bool isLoadingAutonumber;
  final Function(int? parentId, String isHeader) onParentOrHeaderChanged;

  const CoaFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
    required this.formOptions,
    required this.isLoadingFormOptions,
    this.autonumber,
    required this.isLoadingAutonumber,
    required this.onParentOrHeaderChanged,
  });

  @override
  State<CoaFormFields> createState() => _CoaFormFieldsState();
}

class _CoaFormFieldsState extends State<CoaFormFields> {
  late TextEditingController numberCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    super.initState();
    numberCtrl = TextEditingController(text: widget.formData.coaNumber);
    nameCtrl = TextEditingController(text: widget.formData.coaName);
    descCtrl = TextEditingController(text: widget.formData.description ?? '');
  }

  @override
  void didUpdateWidget(CoaFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isEditMode &&
        widget.autonumber != null &&
        numberCtrl.text.isEmpty) {
      numberCtrl.text = '${widget.autonumber}';
      widget.formData.coaNumber = '${widget.autonumber}';
    }
  }

  @override
  void dispose() {
    numberCtrl.dispose();
    nameCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.formData.coaNumber = numberCtrl.text;
    widget.formData.coaName = nameCtrl.text;
    widget.formData.description =
        descCtrl.text.isEmpty ? null : descCtrl.text;
  }

  CoaParentOption? _findParent(int? id) {
    if (id == null || widget.formOptions == null) return null;
    final matches =
        widget.formOptions!.parentCoaList.where((p) => p.idCoa == id);
    return matches.isEmpty ? null : matches.first;
  }

  Widget _chipSelector(
    String label,
    List<String> options,
    String? selected,
    bool required,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorTextPrimary,
                ),
              ),
              if (required)
                const TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemCount = options.length;
            final totalSpacing = (itemCount - 1) * 8.0;
            final itemWidth = (constraints.maxWidth - totalSpacing) / itemCount;

            return Row(
              children: options.asMap().entries.map((entry) {
                final index = entry.key;
                final opt = entry.value;
                final isSelected = selected == opt;

                return Padding(
                  padding: EdgeInsets.only(right: index < itemCount - 1 ? 8 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => onChanged(opt)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: itemWidth,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? colorPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isSelected ? colorPrimary : colorGreyLight,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSelected) ...[
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Flexible(
                            child: Text(
                              opt,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : colorTextPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingFormOptions) {
      return const Center(child: CircularProgressIndicator(color: colorPrimary));
    }
    final opts = widget.formOptions;
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
                  CustomSearchableDropdown<CoaParentOption>(
                    key: ValueKey(
                      'parent_${widget.formData.parentId}_${opts?.parentCoaList.length ?? 0}',
                    ),
                    value: _findParent(widget.formData.parentId),
                    items: opts?.parentCoaList ?? [],
                    itemLabel: (p) => '${p.coaNumber} - ${p.coaName}',
                    onChanged: (v) {
                      setState(() => widget.formData.parentId = v?.idCoa);
                      widget.onParentOrHeaderChanged(
                        v?.idCoa,
                        widget.formData.isHeader,
                      );
                    },
                    label: 'Parent Account',
                    clearable: true,
                  ),
                  const SizedBox(height: 16),
                  _chipSelector(
                    'Is Header Account',
                    opts?.isHeaderOpts ?? ['Y', 'N'],
                    widget.formData.isHeader,
                    true,
                    (v) {
                      widget.formData.isHeader = v ?? 'N';
                      widget.onParentOrHeaderChanged(
                        widget.formData.parentId,
                        widget.formData.isHeader,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CustomFormInput(
                        controller: numberCtrl,
                        label: 'COA Number',
                        required: true,
                        hintText: 'e.g. 10000',
                        keyboardType: TextInputType.number,
                        validator: (_) => numberCtrl.text.trim().isEmpty
                            ? 'COA Number is required'
                            : null,
                      ),
                      if (widget.isLoadingAutonumber)
                        const Positioned(
                          right: 12,
                          top: 36,
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      if (!widget.isEditMode &&
                          widget.autonumber != null &&
                          !widget.isLoadingAutonumber)
                        Positioned(
                          right: 12,
                          top: 38,
                          child: GestureDetector(
                            onTap: () {
                              numberCtrl.text = '${widget.autonumber}';
                              widget.formData.coaNumber =
                                  '${widget.autonumber}';
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Auto: ${widget.autonumber}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: colorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: nameCtrl,
                    label: 'COA Name',
                    required: true,
                    hintText: 'e.g. Kas',
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? 'COA Name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _chipSelector(
                    'Type',
                    opts?.types ?? ['DEBIT', 'CREDIT'],
                    widget.formData.type,
                    true,
                    (v) => widget.formData.type = v,
                  ),
                  const SizedBox(height: 16),
                  _chipSelector(
                    'Report Type',
                    opts?.reportTypes ?? ['NERACA', 'LABA RUGI'],
                    widget.formData.reportType,
                    true,
                    (v) => widget.formData.reportType = v,
                  ),
                  const SizedBox(height: 16),
                  _chipSelector(
                    'Tax Adjustment',
                    opts?.taxAdjustments ?? ['N', 'PA', 'NA'],
                    widget.formData.taxAdjustment,
                    true,
                    (v) => widget.formData.taxAdjustment = v,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: descCtrl,
                    label: 'Description',
                    hintText: 'Optional description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
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
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _save();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? 'Update COA' : 'Create COA',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
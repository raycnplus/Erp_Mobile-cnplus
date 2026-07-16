import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/models/customer_category_models.dart';

class CustomerCategoryFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final CustomerCategoryFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const CustomerCategoryFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<CustomerCategoryFormFields> createState() =>
      _CustomerCategoryFormFieldsState();
}

class _CustomerCategoryFormFieldsState
    extends State<CustomerCategoryFormFields> {
  late TextEditingController nameCtrl;
  late TextEditingController codeCtrl;
  late TextEditingController descriptionCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(
        text: widget.formData.customerCategoryName);
    codeCtrl = TextEditingController(
        text: widget.formData.customerCategoryCode);
    descriptionCtrl =
        TextEditingController(text: widget.formData.description);
  }

  void _saveAllFields() {
    widget.formData.customerCategoryName = nameCtrl.text;
    widget.formData.customerCategoryCode = codeCtrl.text;
    widget.formData.description = descriptionCtrl.text;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
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
                    label: "Category Name",
                    required: true,
                    hintText: "Enter category name",
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? "Category name is required"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomFormInput(
                    controller: codeCtrl,
                    label: "Category Code",
                    required: true,
                    hintText: "Enter category code",
                    validator: (_) => codeCtrl.text.trim().isEmpty
                        ? "Category code is required"
                        : null,
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
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: colorInfo, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'View audit trail in detail screen',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorInfo),
                            ),
                          ),
                        ],
                      ),
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
                  widget.isEditMode ? "Update Category" : "Create Category",
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
}
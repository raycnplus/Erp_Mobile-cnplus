import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/custom_form_input.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/models/product_type_models.dart';

class ProductTypeFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ProductTypeFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const ProductTypeFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<ProductTypeFormFields> createState() => _ProductTypeFormFieldsState();
}

class _ProductTypeFormFieldsState extends State<ProductTypeFormFields> {
  late TextEditingController nameCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.formData.productTypeName);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  void saveAllFields() {
    widget.formData.productTypeName = nameCtrl.text.trim();
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
                    label: "Product Type Name",
                    required: true,
                    hintText: "Enter product type name",
                    validator: (_) => nameCtrl.text.trim().isEmpty
                        ? "Product type name is required"
                        : null,
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
                          const Icon(Icons.info_outline, color: colorInfo, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('View audit trail in detail screen',
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: colorInfo)),
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
              color: colorWhite,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08),
                    blurRadius: 8, offset: const Offset(0, -2)),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  saveAllFields();
                  widget.onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode ? "Update Type" : "Create Type",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600, color: colorWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
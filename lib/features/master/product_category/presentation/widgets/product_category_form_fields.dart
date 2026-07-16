import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/models/product_category_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class ProductCategoryFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ProductCategoryFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const ProductCategoryFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<ProductCategoryFormFields> createState() =>
      _ProductCategoryFormFieldsState();
}

class _ProductCategoryFormFieldsState
    extends State<ProductCategoryFormFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.formData.productCategoryName);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                  Text("Category Name",
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorTextPrimary)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    onChanged: (v) =>
                        widget.formData.productCategoryName = v,
                    decoration: InputDecoration(
                      hintText: "Enter category name",
                      hintStyle:
                          GoogleFonts.poppins(color: colorGrey, fontSize: 14),
                      filled: true,
                      fillColor: colorPrimary.withOpacity(0.05),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: colorGreyLight, width: 1)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: colorPrimary, width: 2)),
                      errorBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: colorError, width: 1)),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide(color: colorError, width: 2)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                    validator: (_) =>
                        widget.formData.validateCategoryName(),
                  ),
                  const SizedBox(height: 24),
                  if (widget.isEditMode &&
                      widget.formData.createdDate != null)
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
              color: colorWhite,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  widget.isEditMode
                      ? "Update Category"
                      : "Create Category",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorWhite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
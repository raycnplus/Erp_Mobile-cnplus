import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/models/brand_models.dart'; // ← SATU file ini saja
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class BrandFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final BrandFormModel formData;
  final VoidCallback onSubmit;
  final bool isEditMode;

  const BrandFormFields({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onSubmit,
    required this.isEditMode,
  });

  @override
  State<BrandFormFields> createState() => _BrandFormFieldsState();
}

class _BrandFormFieldsState extends State<BrandFormFields> {
  late TextEditingController _nameController;
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.formData.brandName);
    _codeController = TextEditingController(text: widget.formData.brandCode);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _saveAllFields() {
    widget.formData.brandName = _nameController.text;
    widget.formData.brandCode = _codeController.text;
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
                  // Brand Name
                  Text(
                    "Brand Name",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter brand name",
                      hintStyle: GoogleFonts.poppins(color: colorGrey, fontSize: 14),
                      filled: true,
                      fillColor: colorPrimary.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: colorGreyLight, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorPrimary, width: 2),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorError, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorError, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                    validator: (value) => widget.formData.validateBrandName(),
                  ),
                  const SizedBox(height: 24),

                  // Brand Code
                  Text(
                    "Brand Code",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: "Enter brand code (optional)",
                      hintStyle: GoogleFonts.poppins(color: colorGrey, fontSize: 14),
                      filled: true,
                      fillColor: colorPrimary.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorGreyLight, width: 1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorPrimary, width: 2),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorError, width: 1),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: colorError, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                    validator: (value) => widget.formData.validateBrandCode(),
                  ),
                  const SizedBox(height: 24),

                  // Info Card (edit mode)
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

          // Submit Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorWhite,
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
                  _saveAllFields();
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
                  widget.isEditMode ? "Update Brand" : "Create Brand",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorWhite,
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
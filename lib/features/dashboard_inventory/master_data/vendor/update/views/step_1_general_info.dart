// views/step_1_general_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController npwpController;
  final InputDecoration Function(String) inputDecoration;
  final Widget Function(String) titleSection;

  const GeneralInfoStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.codeController,
    required this.npwpController,
    required this.inputDecoration,
    required this.titleSection,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          titleSection("General & Business Info"),
          TextFormField(
            controller: nameController,
            decoration: inputDecoration("Vendor Name"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: codeController,
            decoration: inputDecoration("Vendor Code"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: npwpController,
            decoration: inputDecoration("NPWP Number"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
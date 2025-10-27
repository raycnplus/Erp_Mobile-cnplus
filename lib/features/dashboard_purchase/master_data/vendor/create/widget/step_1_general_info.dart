import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_form_styles.dart'; // Import style helper

class Step1GeneralInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController vendorNameCtrl;
  final TextEditingController vendorCodeCtrl;
  final TextEditingController npwpCtrl;

  const Step1GeneralInfo({
    super.key,
    required this.formKey,
    required this.vendorNameCtrl,
    required this.vendorCodeCtrl,
    required this.npwpCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          buildTitleSection('General & Business Info'),
          TextFormField(
            controller: vendorNameCtrl,
            decoration: getInputDecoration("Vendor Name"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: vendorCodeCtrl,
            decoration: getInputDecoration("Vendor Code"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: npwpCtrl,
            decoration: getInputDecoration("NPWP Number"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_form_styles.dart'; // Import style helper
import '../models/create_models_vendor_purchase.dart'; // Import model

class Step2ContactLocation extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController picNameCtrl;
  final TextEditingController picPhoneCtrl;
  final TextEditingController picEmailCtrl;
  final TextEditingController provinceCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController postalCtrl;
  final TextEditingController addressCtrl;
  final List<CountryModel> countries;
  final int? selectedCountry;
  final ValueChanged<int?> onCountryChanged;

  const Step2ContactLocation({
    super.key,
    required this.formKey,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.picNameCtrl,
    required this.picPhoneCtrl,
    required this.picEmailCtrl,
    required this.provinceCtrl,
    required this.cityCtrl,
    required this.postalCtrl,
    required this.addressCtrl,
    required this.countries,
    this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          buildTitleSection("Primary Contact"),
          TextFormField(
            controller: phoneCtrl,
            decoration: getInputDecoration("Phone No"),
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailCtrl,
            decoration: getInputDecoration("Email"),
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(),
          ),
          buildTitleSection("Contact Person (PIC)"),
          TextFormField(
            controller: picNameCtrl,
            decoration: getInputDecoration("PIC Name"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: picPhoneCtrl,
            decoration: getInputDecoration("PIC Phone"),
            keyboardType: TextInputType.phone,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: picEmailCtrl,
            decoration: getInputDecoration("PIC Email"),
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(),
          ),
          buildTitleSection("Address"),
          DropdownButtonFormField<int>(
            value: selectedCountry,
            items: countries
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name, style: GoogleFonts.poppins()),
                    ))
                .toList(),
            onChanged: onCountryChanged,
            decoration: getInputDecoration("Country"),
            validator: (v) => v == null ? "Required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: provinceCtrl,
            decoration: getInputDecoration("Province"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: cityCtrl,
            decoration: getInputDecoration("City"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: postalCtrl,
            decoration: getInputDecoration("Postal Code"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: addressCtrl,
            decoration: getInputDecoration("Address"),
            maxLines: 3,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
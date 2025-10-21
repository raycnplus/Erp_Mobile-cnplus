// views/step_2_location_info.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/update_models_vendor.dart';

class LocationInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController provinceCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController postalCtrl;
  final TextEditingController addressCtrl;
  final int? selectedCountry;
  final List<CountryModel> countries;
  final void Function(int?) onCountryChanged;
  final InputDecoration Function(String) inputDecoration;
  final Widget Function(String) titleSection;

  const LocationInfoStep({
    super.key,
    required this.formKey,
    required this.provinceCtrl,
    required this.cityCtrl,
    required this.postalCtrl,
    required this.addressCtrl,
    required this.selectedCountry,
    required this.countries,
    required this.onCountryChanged,
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
          titleSection("Location Info"),
          DropdownButtonFormField<int>(
            value: selectedCountry,
            isExpanded: true, // Tambahkan properti ini
            items: countries
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      // HAPUS WIDGET EXPANDED DARI SINI
                      child: Text(
                        c.name, 
                        style: GoogleFonts.poppins(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: onCountryChanged,
            decoration: inputDecoration("Country"),
            validator: (v) => v == null ? "Country is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: provinceCtrl,
            decoration: inputDecoration("Province"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: cityCtrl,
            decoration: inputDecoration("City"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: postalCtrl,
            decoration: inputDecoration("Postal Code"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: addressCtrl,
            decoration: inputDecoration("Address"),
            maxLines: 3,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
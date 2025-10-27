import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_form_styles.dart'; // Import style helper
import '../models/create_models_vendor_purchase.dart'; // Import model

class Step3FinancialDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController bankNameCtrl;
  final TextEditingController bankAccountNameCtrl;
  final TextEditingController bankNumberCtrl;
  final List<CurrencyModel> currencies;
  final int? selectedCurrency;
  final ValueChanged<int?> onCurrencyChanged;

  const Step3FinancialDetails({
    super.key,
    required this.formKey,
    required this.bankNameCtrl,
    required this.bankAccountNameCtrl,
    required this.bankNumberCtrl,
    required this.currencies,
    this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          buildTitleSection('Financial Details'),
          DropdownButtonFormField<int>(
            value: selectedCurrency,
            items: currencies
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name, style: GoogleFonts.poppins()),
                    ))
                .toList(),
            onChanged: onCurrencyChanged,
            decoration: getInputDecoration("Currency"),
            validator: (v) => v == null ? "Required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankNameCtrl,
            decoration: getInputDecoration("Bank Name"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankAccountNameCtrl,
            decoration: getInputDecoration("Bank Account Name"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankNumberCtrl,
            decoration: getInputDecoration("Bank Account Number"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
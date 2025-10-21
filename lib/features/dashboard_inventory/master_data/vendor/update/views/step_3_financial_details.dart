// views/step_3_financial_details.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/update_models_vendor.dart';

class FinancialStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController bankNameCtrl;
  final TextEditingController bankAccountNameCtrl;
  final TextEditingController bankNumberCtrl;
  final int? selectedCurrency;
  final List<CurrencyModel> currencies;
  final void Function(int?) onCurrencyChanged;
  final InputDecoration Function(String) inputDecoration;
  final Widget Function(String) titleSection;

  const FinancialStep({
    super.key,
    required this.formKey,
    required this.bankNameCtrl,
    required this.bankAccountNameCtrl,
    required this.bankNumberCtrl,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencyChanged,
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
          titleSection("Financial Details"),
          DropdownButtonFormField<int>(
            value: selectedCurrency,
            isExpanded: true, // Properti ini sudah cukup untuk mengatasi overflow
            items: currencies
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      // HAPUS WIDGET EXPANDED DARI SINI
                      child: Text(
                        c.name,
                        style: GoogleFonts.poppins(),
                        overflow: TextOverflow.ellipsis, // Cukup gunakan ini untuk teks panjang
                      ),
                    ))
                .toList(),
            onChanged: onCurrencyChanged,
            decoration: inputDecoration("Currency"),
            validator: (v) => v == null ? "Currency is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankNameCtrl,
            decoration: inputDecoration("Bank Name"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankAccountNameCtrl,
            decoration: inputDecoration("Bank Account Name"),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bankNumberCtrl,
            decoration: inputDecoration("Bank Account Number"),
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }
}
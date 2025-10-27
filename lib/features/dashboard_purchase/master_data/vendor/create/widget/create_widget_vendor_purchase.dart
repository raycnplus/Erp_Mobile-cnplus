import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart'; 

// [BARU] Import file-file UI yang sudah dipecah
import 'step_1_general_info.dart';
import 'step_2_contact_location.dart';
import 'step_3_financial_details.dart';
import 'vendor_form_styles.dart'; // Helper untuk style

import '../../../../../../../../services/api_base.dart';
import '../models/create_models_vendor_purchase.dart';

class VendorCreateWidget extends StatefulWidget {
  const VendorCreateWidget({super.key});

  @override
  State<VendorCreateWidget> createState() => _VendorCreateWidgetState();
}

class _VendorCreateWidgetState extends State<VendorCreateWidget> {
  // --- State Management untuk Stepper Kustom ---
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final storage = const FlutterSecureStorage();

  // --- Controllers ---
  // (Semua controller tetap di sini sebagai state)
  final TextEditingController vendorNameCtrl = TextEditingController();
  final TextEditingController vendorCodeCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController npwpCtrl = TextEditingController();
  final TextEditingController provinceCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController postalCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController picNameCtrl = TextEditingController();
  final TextEditingController picPhoneCtrl = TextEditingController();
  final TextEditingController picEmailCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAccountNameCtrl = TextEditingController();
  final TextEditingController bankNumberCtrl = TextEditingController();

  // --- Dropdowns & State Lainnya ---
  int? selectedCountry;
  int? selectedCurrency;
  List<CountryModel> countries = [];
  List<CurrencyModel> currencies = [];
  bool isLoadingCountry = true;
  bool isLoadingCurrency = true;
  bool isSubmitting = false;

  // --- Detail Langkah ---
  final stepDetails = [
    {'title': 'General & Business Info', 'guide': 'Informasi dasar vendor dan NPWP.'},
    {'title': 'Contact & Location', 'guide': 'Detail alamat dan kontak person (PIC).'},
    {'title': 'Financial Details', 'guide': 'Informasi bank dan mata uang.'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _fetchCurrencies();
  }

  @override
  void dispose() {
    // (Semua dispose controller tetap di sini)
    _pageController.dispose();
    vendorNameCtrl.dispose();
    vendorCodeCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    npwpCtrl.dispose();
    provinceCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    addressCtrl.dispose();
    picNameCtrl.dispose();
    picPhoneCtrl.dispose();
    picEmailCtrl.dispose();
    bankNameCtrl.dispose();
    bankAccountNameCtrl.dispose();
    bankNumberCtrl.dispose();
    super.dispose();
  }

  // --- Logika Fetch Data (Tidak berubah) ---
  Future<void> _fetchCountries() async {
    final token = await storage.read(key: "token");
    try {
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/countries/"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["status"] == true && body["data"] != null) {
          final List data = body["data"];
          if (mounted) {
            setState(() => countries = data.map((e) => CountryModel.fromJson(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint("Exception fetching countries: $e");
    } finally {
      if (mounted) setState(() => isLoadingCountry = false);
    }
  }

  Future<void> _fetchCurrencies() async {
    final token = await storage.read(key: "token");
    try {
      final response = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/currency/"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["status"] == true && body["data"] != null) {
          final List data = body["data"];
          if (mounted) {
            setState(() => currencies = data.map((e) => CurrencyModel.fromJson(e)).toList());
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching currencies: $e");
    } finally {
      if (mounted) setState(() => isLoadingCurrency = false);
    }
  }

  // --- Logika Navigasi & Submit (Tidak berubah) ---
  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _submitVendor();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> _submitVendor() async {
    for (var formKey in _formKeys) {
      if (!formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please complete all required fields in every step."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => isSubmitting = true);
    final token = await storage.read(key: "token");
    final requestBody = {
      "vendor_name": vendorNameCtrl.text,
      "vendor_code": vendorCodeCtrl.text,
      "phone_no": phoneCtrl.text,
      "email": emailCtrl.text,
      "npwp_number": npwpCtrl.text,
      "province": provinceCtrl.text,
      "city": cityCtrl.text,
      "postal_code": postalCtrl.text,
      "address": addressCtrl.text,
      "contact_person_name": picNameCtrl.text,
      "contact_person_phone": picPhoneCtrl.text,
      "contact_person_email": picEmailCtrl.text,
      "bank_name": bankNameCtrl.text,
      "bank_account_name": bankAccountNameCtrl.text,
      "bank_account_number": bankNumberCtrl.text,
      "id_country": selectedCountry,
      "id_currency": selectedCurrency,
    };

    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/purchase/vendor"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      if (!mounted) return;
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = body['message'] ?? "Vendor created successfully!";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        final errMsg = body['message'] ?? "Failed to create vendor.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // --- Helper Widgets untuk UI (dipindahkan ke vendor_form_styles.dart) ---
  // [DIHAPUS] _getInputDecoration()
  // [DIHAPUS] _buildTitleSection()

  // --- Widget untuk Setiap Langkah (dipindahkan ke file terpisah) ---
  // [DIHAPUS] _buildStep1()
  // [DIHAPUS] _buildStep2()
  // [DIHAPUS] _buildStep3()

  // --- Widget Navigasi & Header (Tetap di sini) ---
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                child: Text(
                  "Kembali",
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: softGreen.withOpacity(0.4),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: softGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  elevation: 0,
                ),
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text(
                        _currentStep == _totalSteps - 1 ? "Simpan Vendor" : "Lanjut",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
          backgroundColor: Colors.grey.shade200,
          color: softGreen,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'STEP ${_currentStep + 1}: ',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: softGreen,
              ),
            ),
            Expanded(
              child: Text(
                stepDetails[_currentStep]['title']!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          stepDetails[_currentStep]['guide']!,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingCountry || isLoadingCurrency) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final themeWithCustomCursor = Theme.of(context).copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: softGreen,
        selectionColor: softGreen.withOpacity(0.4),
        selectionHandleColor: softGreen,
      ),
    );

    return Theme(
      data: themeWithCustomCursor,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildStepperHeader(),
            ),
            Expanded(
              // [DIUBAH] PageView sekarang memanggil widget-widget baru
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1GeneralInfo(
                    formKey: _formKeys[0],
                    vendorNameCtrl: vendorNameCtrl,
                    vendorCodeCtrl: vendorCodeCtrl,
                    npwpCtrl: npwpCtrl,
                  ),
                  Step2ContactLocation(
                    formKey: _formKeys[1],
                    phoneCtrl: phoneCtrl,
                    emailCtrl: emailCtrl,
                    picNameCtrl: picNameCtrl,
                    picPhoneCtrl: picPhoneCtrl,
                    picEmailCtrl: picEmailCtrl,
                    provinceCtrl: provinceCtrl,
                    cityCtrl: cityCtrl,
                    postalCtrl: postalCtrl,
                    addressCtrl: addressCtrl,
                    countries: countries,
                    selectedCountry: selectedCountry,
                    onCountryChanged: (val) {
                      setState(() => selectedCountry = val);
                    },
                  ),
                  Step3FinancialDetails(
                    formKey: _formKeys[2],
                    bankNameCtrl: bankNameCtrl,
                    bankAccountNameCtrl: bankAccountNameCtrl,
                    bankNumberCtrl: bankNumberCtrl,
                    currencies: currencies,
                    selectedCurrency: selectedCurrency,
                    onCurrencyChanged: (val) {
                      setState(() => selectedCurrency = val);
                    },
                  ),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }
}
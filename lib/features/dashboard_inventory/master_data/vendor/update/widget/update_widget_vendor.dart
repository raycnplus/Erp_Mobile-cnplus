// widget/update_widget_vendor.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/update_models_vendor.dart';
import '../services/vendor_api_service.dart';
import '../views/step_1_general_info.dart';
import '../views/step_2_contact_location.dart'; // Nama file disesuaikan
import '../views/step_3_financial_details.dart';

class VendorUpdateWidget extends StatefulWidget {
  final String vendorId;
  const VendorUpdateWidget({super.key, required this.vendorId});

  @override
  State<VendorUpdateWidget> createState() => _VendorUpdateWidgetState();
}

class _VendorUpdateWidgetState extends State<VendorUpdateWidget> {
  // --- State Management ---
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  final VendorApiService _apiService = VendorApiService();
  bool _isLoading = true;
  bool _isSubmitting = false;

  // --- Controllers & Dropdown State ---
  late TextEditingController vendorNameCtrl, vendorCodeCtrl, npwpCtrl, provinceCtrl, cityCtrl, postalCtrl, addressCtrl, bankNameCtrl, bankAccountNameCtrl, bankNumberCtrl;
  int? selectedCountry, selectedCurrency;
  List<CountryModel> countries = [];
  List<CurrencyModel> currencies = [];
  
  // Controller yang tidak ada di step 2 (Location Info)
  // Anda bisa menghapusnya jika tidak ada di step lain
  late TextEditingController phoneCtrl, emailCtrl, picNameCtrl, picPhoneCtrl, picEmailCtrl;


  // --- UI Styles ---
  final softGreen = const Color(0xFF679436);
  final lightGreen = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'General & Business Info', 'guide': 'Informasi dasar vendor dan NPWP.'},
    {'title': 'Location Info', 'guide': 'Detail alamat dan lokasi vendor.'}, // Disesuaikan
    {'title': 'Financial Details', 'guide': 'Informasi bank dan mata uang.'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialData();
  }

  void _initializeControllers() {
    vendorNameCtrl = TextEditingController(); vendorCodeCtrl = TextEditingController(); npwpCtrl = TextEditingController(); provinceCtrl = TextEditingController(); cityCtrl = TextEditingController(); postalCtrl = TextEditingController(); addressCtrl = TextEditingController(); bankNameCtrl = TextEditingController(); bankAccountNameCtrl = TextEditingController(); bankNumberCtrl = TextEditingController();
    // Inisialisasi controller tambahan
    phoneCtrl = TextEditingController(); emailCtrl = TextEditingController(); picNameCtrl = TextEditingController(); picPhoneCtrl = TextEditingController(); picEmailCtrl = TextEditingController();
  }

  Future<void> _loadInitialData() async {
    try {
      final results = await Future.wait([
        _apiService.fetchVendorDetail(widget.vendorId),
        _apiService.fetchCountries(),
        _apiService.fetchCurrencies(),
      ]);

      final vendorData = results[0] as Map<String, dynamic>;
      final fetchedCountries = results[1] as List<CountryModel>;
      final fetchedCurrencies = results[2] as List<CurrencyModel>;

      if (mounted) {
        setState(() {
          _populateControllers(vendorData);
          countries = fetchedCountries;
          currencies = fetchedCurrencies;
          selectedCountry = int.tryParse(vendorData['country']?.toString() ?? '');
          selectedCurrency = int.tryParse(vendorData['currency']?.toString() ?? '');
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error memuat data: $e")));
        setState(() => _isLoading = false);
      }
    }
  }

  void _populateControllers(Map<String, dynamic> payload) {
    String safe(dynamic v) => (v ?? '').toString();
    vendorNameCtrl.text = safe(payload['vendor_name']); vendorCodeCtrl.text = safe(payload['vendor_code']); npwpCtrl.text = safe(payload['npwp_number']); provinceCtrl.text = safe(payload['province']); cityCtrl.text = safe(payload['city']); postalCtrl.text = safe(payload['postal_code']); addressCtrl.text = safe(payload['address']); bankNameCtrl.text = safe(payload['bank_name']); bankAccountNameCtrl.text = safe(payload['bank_account_name']); bankNumberCtrl.text = safe(payload['bank_account_number']);
    // Populate controller tambahan
    phoneCtrl.text = safe(payload['phone_no']); emailCtrl.text = safe(payload['email']); picNameCtrl.text = safe(payload['contact_person_name']); picPhoneCtrl.text = safe(payload['contact_person_phone']); picEmailCtrl.text = safe(payload['contact_person_email']);
  }

  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _updateVendor();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future<void> _updateVendor() async {
    setState(() => _isSubmitting = true);
    final requestBody = {
      "vendor_name": vendorNameCtrl.text, "vendor_code": vendorCodeCtrl.text, "npwp_number": npwpCtrl.text, "province": provinceCtrl.text, "city": cityCtrl.text, "postal_code": postalCtrl.text, "address": addressCtrl.text, "bank_name": bankNameCtrl.text, "bank_account_name": bankAccountNameCtrl.text, "bank_account_number": bankNumberCtrl.text, "country": selectedCountry, "currency": selectedCurrency,
      // Tambahkan data yang controllernya dihapus dari step 2
      "phone_no": phoneCtrl.text, "email": emailCtrl.text, "contact_person_name": picNameCtrl.text, "contact_person_phone": picPhoneCtrl.text, "contact_person_email": picEmailCtrl.text,
    };

    try {
      final success = await _apiService.updateVendor(vendorId: widget.vendorId, data: requestBody);
      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vendor berhasil diupdate")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update vendor.")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration( labelText: label, labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600), filled: true, fillColor: lightGreen.withOpacity(0.3), border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0)), focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen, width: 2.0)),);
  }

  Widget _buildTitleSection(String title) {
    return Padding(padding: const EdgeInsets.only(top: 24, bottom: 12), child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: softGreen)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(16.0), child: _buildStepperHeader()),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              GeneralInfoStep(formKey: _formKeys[0], nameController: vendorNameCtrl, codeController: vendorCodeCtrl, npwpController: npwpCtrl, inputDecoration: _getInputDecoration, titleSection: _buildTitleSection),
              LocationInfoStep(formKey: _formKeys[1], provinceCtrl: provinceCtrl, cityCtrl: cityCtrl, postalCtrl: postalCtrl, addressCtrl: addressCtrl, selectedCountry: selectedCountry, countries: countries, onCountryChanged: (val) => setState(() => selectedCountry = val), inputDecoration: _getInputDecoration, titleSection: _buildTitleSection),
              FinancialStep(formKey: _formKeys[2], bankNameCtrl: bankNameCtrl, bankAccountNameCtrl: bankAccountNameCtrl, bankNumberCtrl: bankNumberCtrl, selectedCurrency: selectedCurrency, currencies: currencies, onCurrencyChanged: (val) => setState(() => selectedCurrency = val), inputDecoration: _getInputDecoration, titleSection: _buildTitleSection)
            ],
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildStepperHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: (_currentStep + 1) / _totalSteps, backgroundColor: Colors.grey.shade200, color: softGreen, minHeight: 8, borderRadius: BorderRadius.circular(4)),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('STEP ${_currentStep + 1}: ', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: softGreen)),
            Expanded(child: Text(stepDetails[_currentStep]['title']!, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87), overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 4),
        Text(stepDetails[_currentStep]['guide']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: _previousStep, style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: borderRadius)), child: Text("Kembali", style: GoogleFonts.poppins(color: Colors.grey.shade700, fontWeight: FontWeight.w600)))),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isSubmitting ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: softGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text(_currentStep == _totalSteps - 1 ? "Simpan Perubahan" : "Lanjut", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
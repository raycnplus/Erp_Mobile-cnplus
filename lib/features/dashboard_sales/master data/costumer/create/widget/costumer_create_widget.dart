// costumer_create_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/costumer_create_models.dart';

class CustomerCreateWidget extends StatefulWidget {
  const CustomerCreateWidget({super.key});

  @override
  State<CustomerCreateWidget> createState() => _CustomerCreateWidgetState();
}

class _CustomerCreateWidgetState extends State<CustomerCreateWidget> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _picNameController = TextEditingController();
  final _picPhoneController = TextEditingController();
  final _picEmailController = TextEditingController();

  bool _isDropdownLoading = true;
  bool _isSubmitting = false;
  List<CustomerCategoryDropdownModel> _categories = [];
  List<CountryModel> _countries = [];
  CustomerCategoryDropdownModel? _selectedCategory;
  CustomerTypeDropdownModel? _selectedType;
  int? _selectedCountryId;
  String? _dropdownError;

  final primaryColor = const Color(0xFF679436);
  final accentColor = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'Main Information', 'guide': 'Fill in the customer\'s name, code, and type.'},
    {'title': 'Contact & Category', 'guide': 'Provide contact details and assign a category.'},
    {'title': 'Address Details', 'guide': 'Enter the full address information.'},
    {'title': 'Person In Charge', 'guide': 'Add details for the main contact person.'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _websiteController.dispose();
    _picNameController.dispose();
    _picPhoneController.dispose();
    _picEmailController.dispose();
    super.dispose();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final results = await Future.wait([_fetchCategories(), _fetchCountries()]);
      if (mounted) {
        setState(() {
          _categories = results[0] as List<CustomerCategoryDropdownModel>;
          _countries = results[1] as List<CountryModel>;
          _isDropdownLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _dropdownError = e.toString(); _isDropdownLoading = false; });
    }
  }

  Future<List<CountryModel>> _fetchCountries() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/countries/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body)['data'];
      return parsed.map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }

  Future<List<CustomerCategoryDropdownModel>> _fetchCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/customer-category/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body)['data'];
      return parsed.map((e) => CustomerCategoryDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories');
  }

  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _createCustomer();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future<void> _createCustomer() async {
    setState(() => _isSubmitting = true);
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final body = {
        "customer_name": _nameController.text, "customer_code": _codeController.text,
        "customer_type": _selectedType?.value, "customer_category": _selectedCategory?.idCategory,
        "phone_no": _phoneController.text, "email": _emailController.text,
        "address": _addressController.text, "country": _selectedCountryId,
        "province": _provinceController.text, "city": _cityController.text,
        "postal_code": _postalCodeController.text, "website": _websiteController.text,
        "pic_name": _picNameController.text, "pic_phone": _picPhoneController.text,
        "pic_email": _picEmailController.text,
      };
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/sales/customer/store'),
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode(body),
      );
      if (!mounted) return;
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primaryColor.withOpacity(0.8), size: 20) : null,
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: accentColor.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: primaryColor, width: 2.0)),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: primaryColor)),
    );
  }

  Widget _buildDropdownField<T>({ 
    required String label, required IconData icon, T? value, required List<T> items,
    void Function(T?)? onChanged, String? Function(T?)? validator,
    required String Function(T) itemToString 
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(itemToString(item), style: GoogleFonts.poppins()),
      )).toList(),
      onChanged: onChanged,
      decoration: _getInputDecoration(label, prefixIcon: icon),
      validator: validator,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Customer", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16.0), child: _buildStepperHeader()),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildStep1(), _buildStep2(), _buildStep3(), _buildStep4()],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[0]['title']!),
          TextFormField(controller: _nameController, decoration: _getInputDecoration("Customer Name", prefixIcon: Icons.person_outline), validator: (v) => v!.isEmpty ? "Required" : null),
          const SizedBox(height: 16),
          TextFormField(controller: _codeController, decoration: _getInputDecoration("Customer Code", prefixIcon: Icons.qr_code_2_outlined), validator: (v) => v!.isEmpty ? "Required" : null),
          const SizedBox(height: 16),
          _buildDropdownField<CustomerTypeDropdownModel>(
            label: "Customer Type", icon: Icons.business_center_outlined,
            value: _selectedType, items: CustomerTypeDropdownModel.types,
            onChanged: (v) => setState(() => _selectedType = v),
            itemToString: (t) => t.displayName, 
            validator: (v) => v == null ? "Required" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    if (_isDropdownLoading) return const Center(child: CircularProgressIndicator());
    if (_dropdownError != null) return Center(child: Text("Error: $_dropdownError"));
    return Form(
      key: _formKeys[1],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[1]['title']!),
          // --- PERBAIKAN DI SINI ---
          // Menggunakan helper _buildDropdownField agar konsisten dan berfungsi.
          _buildDropdownField<CustomerCategoryDropdownModel>(
            label: "Customer Category",
            icon: Icons.category_outlined,
            value: _selectedCategory,
            items: _categories,
            onChanged: (v) => setState(() => _selectedCategory = v),
            itemToString: (c) => c.categoryName,
            validator: (v) => v == null ? "Required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _phoneController, decoration: _getInputDecoration("Phone No", prefixIcon: Icons.phone_outlined), keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          TextFormField(controller: _emailController, decoration: _getInputDecoration("Email", prefixIcon: Icons.email_outlined), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          TextFormField(controller: _websiteController, decoration: _getInputDecoration("Website", prefixIcon: Icons.public_outlined), keyboardType: TextInputType.url),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    if (_isDropdownLoading) return const Center(child: CircularProgressIndicator());
    return Form(
      key: _formKeys[2],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[2]['title']!),
          TextFormField(controller: _addressController, decoration: _getInputDecoration("Address", prefixIcon: Icons.location_on_outlined), maxLines: 3),
          const SizedBox(height: 16),
          _buildDropdownField<int>(
            label: "Country",
            icon: Icons.flag_outlined,
            value: _selectedCountryId,
            items: _countries.map((c) => c.id).toList(),
            onChanged: (v) => setState(() => _selectedCountryId = v),
            itemToString: (id) => _countries.firstWhere((c) => c.id == id, orElse: () => CountryModel(id: 0, name: 'Unknown')).name,
            validator: (v) => v == null ? "Required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _provinceController, decoration: _getInputDecoration("Province", prefixIcon: Icons.map_outlined)),
          const SizedBox(height: 16),
          TextFormField(controller: _cityController, decoration: _getInputDecoration("City", prefixIcon: Icons.location_city_outlined)),
          const SizedBox(height: 16),
          TextFormField(controller: _postalCodeController, decoration: _getInputDecoration("Postal Code", prefixIcon: Icons.markunread_mailbox_outlined), keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Form(
      key: _formKeys[3],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[3]['title']!),
          TextFormField(controller: _picNameController, decoration: _getInputDecoration("PIC Name", prefixIcon: Icons.person_pin_circle_outlined)),
          const SizedBox(height: 16),
          TextFormField(controller: _picPhoneController, decoration: _getInputDecoration("PIC Phone", prefixIcon: Icons.phone_iphone_outlined), keyboardType: TextInputType.phone),
          const SizedBox(height: 16),
          TextFormField(controller: _picEmailController, decoration: _getInputDecoration("PIC Email", prefixIcon: Icons.alternate_email_outlined), keyboardType: TextInputType.emailAddress),
        ],
      ),
    );
  }

  Widget _buildStepperHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: (_currentStep + 1) / _totalSteps, backgroundColor: Colors.grey.shade200, color: primaryColor, minHeight: 8, borderRadius: BorderRadius.circular(4)),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('STEP ${_currentStep + 1}: ', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor)),
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
          if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: _previousStep, style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: borderRadius)), child: Text("Back", style: GoogleFonts.poppins(color: Colors.grey.shade700, fontWeight: FontWeight.w600)))),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isSubmitting ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text(_currentStep == _totalSteps - 1 ? "Save Customer" : "Next", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
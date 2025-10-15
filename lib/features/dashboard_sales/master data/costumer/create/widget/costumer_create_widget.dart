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
    print('\n[INIT] CustomerCreateWidget initialized');
    _fetchDropdownData();
  }

  @override
  void dispose() {
    print('[DISPOSE] Cleaning up controllers and page controller');
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

  // ====================== FETCH DROPDOWN DATA ======================
  Future<void> _fetchDropdownData() async {
    print('\n[FETCH] Fetching dropdown data (categories & countries)...');
    try {
      final results = await Future.wait([
        _fetchCategories(),
        _fetchCountries(),
      ]);
      if (mounted) {
        setState(() {
          _categories = results[0] as List<CustomerCategoryDropdownModel>;
          _countries = results[1] as List<CountryModel>;
          _isDropdownLoading = false;
        });
        print('[FETCH SUCCESS] Categories: ${_categories.length}, Countries: ${_countries.length}');
      }
    } catch (e) {
      if (mounted) {
        print('[FETCH ERROR] $e');
        setState(() {
          _dropdownError = e.toString();
          _isDropdownLoading = false;
        });
      }
    }
  }

  Future<List<CountryModel>> _fetchCountries() async {
    print('[FETCH] Requesting countries...');
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    print('[TOKEN] $token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/countries/'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    print('[FETCH] Country response code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'] as List<dynamic>;
      print('[FETCH] Countries fetched: ${parsed.length}');
      return parsed.map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries: ${response.statusCode}');
  }

  Future<List<CustomerCategoryDropdownModel>> _fetchCategories() async {
    print('[FETCH] Requesting categories...');
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer-category/'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    print('[FETCH] Category response code: ${response.statusCode}');
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body)['data'] as List<dynamic>;
      print('[FETCH] Raw category data: $parsed');
      return parsed.map((e) => CustomerCategoryDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load categories: ${response.statusCode}');
  }

  // ====================== NAVIGATION LOGIC ======================
  void _nextStep() {
    print('\n[NEXT] Button pressed on step $_currentStep');
    final formState = _formKeys[_currentStep].currentState;
    if (formState == null) {
      print('[ERROR] Form state is null for step $_currentStep');
      return;
    }

    final isValid = formState.validate();
    print('[VALIDATION] Step $_currentStep result: $isValid');

    if (!isValid) {
      print('[STOP] Validation failed on step $_currentStep');
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      print('[MOVE] Proceeding to step ${_currentStep + 1}');
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      print('[FINAL STEP] Submitting form...');
      _createCustomer();
    }
  }

  void _previousStep() {
    print('\n[BACK] Button pressed');
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  // ====================== CREATE CUSTOMER ======================
  Future<void> _createCustomer() async {
    print('\n[CREATE] Preparing request body...');
    setState(() => _isSubmitting = true);

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      print('[CREATE] Token: $token');

      final body = {
        "customer_name": _nameController.text,
        "customer_code": _codeController.text,
        "customer_type": _selectedType?.value,
        "customer_category": _selectedCategory?.idCategory,
        "phone_no": _phoneController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "country": _selectedCountryId,
        "province": _provinceController.text,
        "city": _cityController.text,
        "postal_code": _postalCodeController.text,
        "website": _websiteController.text,
        "pic_name": _picNameController.text,
        "pic_phone": _picPhoneController.text,
        "pic_email": _picEmailController.text,
      };

      print('[CREATE] Request body:\n${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/sales/customer/store'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print('[CREATE] Response status: ${response.statusCode}');
      print('[CREATE] Response body: ${response.body}');

      if (!mounted) return;
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[CREATE SUCCESS] Customer created successfully');
        Navigator.pop(context, true);
      } else {
        print('[CREATE FAILED] Server responded with error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.body}")),
        );
      }
    } catch (e) {
      print('[CREATE ERROR] Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ====================== INPUT + UI ======================
  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: primaryColor.withOpacity(0.8), size: 20)
          : null,
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: accentColor.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: borderRadius, borderSide: BorderSide.none),
    );
  }

  Widget _buildStep1() {
    print('[BUILD] Step 1');
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[0]['title']!),
          TextFormField(
            controller: _nameController,
            decoration:
                _getInputDecoration("Customer Name", prefixIcon: Icons.person),
            validator: (v) => v!.isEmpty ? "Required" : null,
            onChanged: (val) => print('[INPUT] Name: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration:
                _getInputDecoration("Customer Code", prefixIcon: Icons.qr_code),
            validator: (v) => v!.isEmpty ? "Required" : null,
            onChanged: (val) => print('[INPUT] Code: $val'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<CustomerTypeDropdownModel>(
            value: _selectedType,
            items: [
              DropdownMenuItem(
                value: CustomerTypeDropdownModel(
                    value: "person", displayName: "Person"),
                child: const Text("Person"),
              ),
              DropdownMenuItem(
                value: CustomerTypeDropdownModel(
                    value: "company", displayName: "Company"),
                child: const Text("Company"),
              ),
            ],
            onChanged: (v) {
              print('[DROPDOWN] Selected type: ${v?.value}');
              setState(() => _selectedType = v);
            },
            validator: (v) => v == null ? "Required" : null,
            decoration: _getInputDecoration("Customer Type",
                prefixIcon: Icons.business_center),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    print('[BUILD] Step 2');
    if (_isDropdownLoading) {
      print('[STEP2] Loading...');
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKeys[1],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[1]['title']!),
          DropdownButtonFormField<CustomerCategoryDropdownModel>(
            value: _selectedCategory,
            items: _categories
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.categoryName),
                    ))
                .toList(),
            onChanged: (v) {
              print('[DROPDOWN] Selected category: ${v?.categoryName}');
              setState(() => _selectedCategory = v);
            },
            validator: (v) => v == null ? "Required" : null,
            decoration: _getInputDecoration("Customer Category",
                prefixIcon: Icons.category),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration:
                _getInputDecoration("Phone No", prefixIcon: Icons.phone),
            onChanged: (val) => print('[INPUT] Phone: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration:
                _getInputDecoration("Email", prefixIcon: Icons.email_outlined),
            onChanged: (val) => print('[INPUT] Email: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _websiteController,
            decoration:
                _getInputDecoration("Website", prefixIcon: Icons.public),
            onChanged: (val) => print('[INPUT] Website: $val'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    print('[BUILD] Step 3');
    return Form(
      key: _formKeys[2],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[2]['title']!),
          TextFormField(
            controller: _addressController,
            decoration: _getInputDecoration("Address",
                prefixIcon: Icons.location_on_outlined),
            onChanged: (val) => print('[INPUT] Address: $val'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _selectedCountryId,
            items: _countries
                .map((c) =>
                    DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: (v) {
              print('[DROPDOWN] Selected country ID: $v');
              setState(() => _selectedCountryId = v);
            },
            validator: (v) => v == null ? "Required" : null,
            decoration:
                _getInputDecoration("Country", prefixIcon: Icons.flag_outlined),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _provinceController,
            decoration:
                _getInputDecoration("Province", prefixIcon: Icons.map_outlined),
            onChanged: (val) => print('[INPUT] Province: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cityController,
            decoration:
                _getInputDecoration("City", prefixIcon: Icons.location_city),
            onChanged: (val) => print('[INPUT] City: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _postalCodeController,
            decoration: _getInputDecoration("Postal Code",
                prefixIcon: Icons.markunread_mailbox),
            onChanged: (val) => print('[INPUT] Postal Code: $val'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    print('[BUILD] Step 4');
    return Form(
      key: _formKeys[3],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[3]['title']!),
          TextFormField(
            controller: _picNameController,
            decoration:
                _getInputDecoration("PIC Name", prefixIcon: Icons.person),
            onChanged: (val) => print('[INPUT] PIC Name: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _picPhoneController,
            decoration:
                _getInputDecoration("PIC Phone", prefixIcon: Icons.phone),
            onChanged: (val) => print('[INPUT] PIC Phone: $val'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _picEmailController,
            decoration:
                _getInputDecoration("PIC Email", prefixIcon: Icons.email),
            onChanged: (val) => print('[INPUT] PIC Email: $val'),
          ),
        ],
      ),
    );
  }

  // ====================== UI STRUCTURE ======================
  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: 18, color: primaryColor)),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text("Back"),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              child: _isSubmitting
                  ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                  : Text(_currentStep == _totalSteps - 1
                      ? "Save Customer"
                      : "Next"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('[BUILD] CustomerCreateWidget (step $_currentStep)');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Customer'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
                _buildStep4(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }
}

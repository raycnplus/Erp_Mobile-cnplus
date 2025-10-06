// customer_update_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/costumer_create_models.dart';

class CustomerUpdateWidget extends StatefulWidget {
  final int id; // ID customer yang akan diupdate

  const CustomerUpdateWidget({super.key, required this.id});

  @override
  State<CustomerUpdateWidget> createState() => _CustomerUpdateWidgetState();
}

class _CustomerUpdateWidgetState extends State<CustomerUpdateWidget> {
  final _formKey = GlobalKey<FormState>();

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
  bool isLoadingCountry = true;
  bool _isLoadingData = true;
  bool _isSubmitting = false;

  List<CustomerCategoryDropdownModel> _categories = [];
  CustomerCategoryDropdownModel? _selectedCategory;
  CustomerTypeDropdownModel? _selectedType;
  int? selectedCountry;
  List<CountryModel> countries = [];

  String? _dropdownError;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
    _fetchCustomerDetail();
  }

  @override
  void dispose() {
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
      final categories = await _fetchCategories();
      final countries = await _fetchCountries();
      if (mounted) {
        setState(() {
          _categories = categories;
          this.countries = countries;
          _isDropdownLoading = false;
          isLoadingCountry = false;
        });
      }
    } catch (e) {
      setState(() {
        _dropdownError = e.toString();
        _isDropdownLoading = false;
        isLoadingCountry = false;
      });
    }
  }

  Future<void> _fetchCustomerDetail() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/show/${widget.id}'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = decoded["data"] ?? decoded;

      setState(() {
        _nameController.text = data["customer_name"] ?? "";
        _codeController.text = data["customer_code"] ?? "";
        _phoneController.text = data["phone_no"] ?? "";
        _emailController.text = data["email"] ?? "";
        _addressController.text = data["address"] ?? "";
        _provinceController.text = data["province"] ?? "";
        _cityController.text = data["city"] ?? "";
        _postalCodeController.text = data["postal_code"] ?? "";
        _websiteController.text = data["website"] ?? "";
        _picNameController.text = data["pic_name"] ?? "";
        _picPhoneController.text = data["pic_phone"] ?? "";
        _picEmailController.text = data["pic_email"] ?? "";

        selectedCountry = data["id_country"];
        _selectedType = CustomerTypeDropdownModel.types.firstWhere(
          (t) => t.value == data["customer_type"],
          orElse: () => CustomerTypeDropdownModel.types.first,
        );

        // Coba temukan kategori yang sesuai
        final catId = data["customer_category"];
        _selectedCategory = _categories.firstWhere(
          (c) => c.idCategory == catId,
          orElse: () => _categories.isNotEmpty
              ? _categories.first
              : CustomerCategoryDropdownModel(
                  idCategory: 0,
                  categoryName: 'Unknown',
                ),
        );

        _isLoadingData = false;
      });
    } else {
      setState(() {
        _isLoadingData = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load customer: ${response.body}")),
      );
    }
  }

  Future<List<CustomerCategoryDropdownModel>> _fetchCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/customer-category/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> parsed = decoded is Map && decoded.containsKey("data")
          ? decoded["data"]
          : (decoded is List ? decoded : []);
      return parsed
          .map((e) => CustomerCategoryDropdownModel.fromJson(e))
          .toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<CountryModel>> _fetchCountries() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/countries/'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> parsed = decoded is Map && decoded.containsKey("data")
          ? decoded["data"]
          : (decoded is List ? decoded : []);
      return parsed.map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load countries');
  }

  Future<void> _updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final body = {
      "customer_name": _nameController.text,
      "customer_code": _codeController.text,
      "customer_type": _selectedType?.value,
      "customer_category": _selectedCategory?.idCategory,
      "phone_no": _phoneController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "province": _provinceController.text,
      "city": _cityController.text,
      "postal_code": _postalCodeController.text,
      "website": _websiteController.text,
      "pic_name": _picNameController.text,
      "pic_phone": _picPhoneController.text,
      "pic_email": _picEmailController.text,
      "id_country": selectedCountry,
    };

    final response = await http.put(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update: ${response.body}")),
      );
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final softGreen = const Color(0xFF679436);
    final lightGreen = const Color(0xFFC8E6C9);
    final borderRadius = BorderRadius.circular(16.0);

    final inputDecorationTheme = InputDecoration(
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: lightGreen.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: softGreen, width: 2.0),
      ),
    );

    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Update Customer",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: inputDecorationTheme.copyWith(labelText: "Name"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _codeController,
              decoration: inputDecorationTheme.copyWith(labelText: "Code"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<CustomerTypeDropdownModel>(
              value: _selectedType,
              items: CustomerTypeDropdownModel.types
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.displayName),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedType = val),
              decoration:
                  inputDecorationTheme.copyWith(labelText: "Customer Type"),
            ),
            const SizedBox(height: 16),

            if (_isDropdownLoading)
              const CircularProgressIndicator()
            else
              DropdownButtonFormField<CustomerCategoryDropdownModel>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.categoryName),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration:
                    inputDecorationTheme.copyWith(labelText: "Customer Category"),
              ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: inputDecorationTheme.copyWith(labelText: "Phone"),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: inputDecorationTheme.copyWith(labelText: "Email"),
            ),
            const SizedBox(height: 16),

            if (isLoadingCountry)
              const CircularProgressIndicator()
            else
              DropdownButtonFormField<int>(
                value: selectedCountry,
                items: countries
                    .map(
                      (c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                decoration:
                    inputDecorationTheme.copyWith(labelText: "Country"),
              ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isSubmitting ? null : _updateCustomer,
              style: ElevatedButton.styleFrom(
                backgroundColor: softGreen,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text("Update Customer",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

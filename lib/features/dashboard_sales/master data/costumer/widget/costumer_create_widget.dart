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
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  // Tambahan field
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _picNameController = TextEditingController();
  final _picPhoneController = TextEditingController();
  final _picEmailController = TextEditingController();

  bool _isDropdownLoading = true;
  bool isLoadingCountry = true;
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
    _fetchCountries(); // Add this line
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
      final countries = await _fetchCountries(); // Fetch countries here
      if (mounted) {
        setState(() {
          _categories = categories;
          this.countries = countries; // Set countries to state
          _isDropdownLoading = false;
          isLoadingCountry = false; // Stop loading indicator for countries
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _dropdownError = e.toString();
          _isDropdownLoading = false;
          isLoadingCountry = false; // Stop loading indicator on error
        });
      }
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
      final decoded = jsonDecode(response.body);

      final List<dynamic> parsed = decoded is Map && decoded.containsKey("data")
          ? decoded["data"]
          : (decoded is List ? decoded : []);

      return parsed.map((e) => CountryModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load country: ${response.statusCode}');
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
    throw Exception('Failed to load categories: ${response.statusCode}');
  }

  Future<void> _createCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
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
        "id_country": selectedCountry, // Add this line
      };

      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/sales/customer/store'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Information",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _nameController,
              decoration: inputDecorationTheme.copyWith(
                labelText: "Customer Name",
              ),
              validator: (val) => val!.isEmpty ? "required" : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _codeController,
              decoration: inputDecorationTheme.copyWith(
                labelText: "Customer Code",
              ),
              validator: (val) => val!.isEmpty ? "required" : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<CustomerTypeDropdownModel>(
              value: _selectedType,
              items: CustomerTypeDropdownModel.types
                  .map(
                    (t) =>
                        DropdownMenuItem(value: t, child: Text(t.displayName)),
                  ) // Menggunakan .displayName
                  .toList(),
              onChanged: (val) => setState(() => _selectedType = val),
              decoration: inputDecorationTheme.copyWith(
                labelText: "Customer Type",
              ),
              validator: (val) => val == null ? "required customer type" : null,
            ),

            const SizedBox(height: 24),
            Text(
              "Contact & Category",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (_isDropdownLoading)
              const Center(child: CircularProgressIndicator())
            else if (_dropdownError != null)
              Text("Error: $_dropdownError")
            else
              DropdownButtonFormField<CustomerCategoryDropdownModel>(
                value: _categories.contains(_selectedCategory)
                    ? _selectedCategory
                    : null,
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.categoryName),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: inputDecorationTheme.copyWith(
                  labelText: "Customer Category",
                ),
                validator: (val) =>
                    val == null ? "required customer category" : null,
              ),

            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: inputDecorationTheme.copyWith(labelText: "Phone No"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: inputDecorationTheme.copyWith(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 24),
            Text(
              "Address",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              decoration: inputDecorationTheme.copyWith(labelText: "Address"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _provinceController,
              decoration: inputDecorationTheme.copyWith(labelText: "Province"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: inputDecorationTheme.copyWith(labelText: "City"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: inputDecorationTheme.copyWith(
                labelText: "Postal Code",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: inputDecorationTheme.copyWith(labelText: "Website"),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Add country dropdown here
            if (isLoadingCountry)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<int>(
                value: selectedCountry,
                items: countries
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedCountry = val),
                decoration: inputDecorationTheme.copyWith(labelText: "Country"),
                validator: (val) => val == null ? "Country is required" : null,
              ),

            const SizedBox(height: 24),
            Text(
              "PIC Information",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _picNameController,
              decoration: inputDecorationTheme.copyWith(labelText: "PIC Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _picPhoneController,
              decoration: inputDecorationTheme.copyWith(labelText: "PIC Phone"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _picEmailController,
              decoration: inputDecorationTheme.copyWith(labelText: "PIC Email"),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _createCustomer,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: softGreen,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Text(
                        "Create Customer",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

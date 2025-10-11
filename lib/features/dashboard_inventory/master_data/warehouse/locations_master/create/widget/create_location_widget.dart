// create_location_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/create_location_models.dart';

class LocationCreateWidget extends StatefulWidget {
  const LocationCreateWidget({super.key});

  @override
  State<LocationCreateWidget> createState() => _LocationCreateWidgetState();
}

class _LocationCreateWidgetState extends State<LocationCreateWidget> {
  // --- State Management untuk Stepper Kustom ---
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // --- Controllers & State ---
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isDropdownLoading = true;
  bool _isSubmitting = false;
  List<WarehouseDropdownModel> _warehouses = [];
  List<LocationDropdownModel> _parents = [];
  WarehouseDropdownModel? _selectedWarehouse;
  LocationDropdownModel? _selectedParent;
  String? _dropdownError;

  // --- Warna dan Style ---
  final softGreen = const Color(0xFF679436);
  final lightGreen = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'Main Information', 'guide': 'Fill in the name and unique code for this location.'},
    {'title': 'Placement & Association', 'guide': 'Select a warehouse and parent location (if any).'},
    {'title': 'Dimensions & Notes', 'guide': 'Enter measurement details and description (optional).'},
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
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _volumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Logika Fetch Data ---
  Future<void> _fetchDropdownData() async {
    try {
      final results = await Future.wait([_fetchWarehouses(), _fetchParentLocations()]);
      if (mounted) {
        setState(() {
          _warehouses = results[0] as List<WarehouseDropdownModel>;
          _parents = results[1] as List<LocationDropdownModel>;
          _isDropdownLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _dropdownError = e.toString(); _isDropdownLoading = false; });
    }
  }

  Future<List<WarehouseDropdownModel>> _fetchWarehouses() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/warehouse'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsedList = jsonDecode(response.body)['data'];
      return parsedList.map((e) => WarehouseDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load warehouses');
  }

  Future<List<LocationDropdownModel>> _fetchParentLocations() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      return parsed.map((e) => LocationDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load parent locations');
  }

  // --- Logika Navigasi & Submit ---
  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _createLocation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future<void> _createLocation() async {
    setState(() => _isSubmitting = true);
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final model = LocationCreateModel(
        locationName: _nameController.text,
        locationCode: _codeController.text,
        warehouse: _selectedWarehouse!.idWarehouse,
        parentLocation: _selectedParent?.id,
        length: double.tryParse(_lengthController.text),
        width: double.tryParse(_widthController.text),
        height: double.tryParse(_heightController.text),
        volume: double.tryParse(_volumeController.text),
        description: _descriptionController.text,
      );
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/inventory/location/store'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(model.toJson()),
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
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // --- Helper Widgets untuk UI ---
  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: softGreen.withOpacity(0.8), size: 20) : null,
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: lightGreen.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen, width: 2.0)),
      errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: softGreen)),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required void Function(T?)? onChanged,
    required String Function(T) itemToString,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemToString(item), style: GoogleFonts.poppins()),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: _getInputDecoration(label, prefixIcon: icon),
      validator: validator,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: softGreen),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Location", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
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
          TextFormField(
            controller: _nameController,
            decoration: _getInputDecoration("Location Name", prefixIcon: Icons.label_outline),
            validator: (val) => val == null || val.isEmpty ? "Location Name is required" : null,
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: _getInputDecoration("Location Code", prefixIcon: Icons.qr_code_2_outlined),
            validator: (val) => val == null || val.isEmpty ? "Location Code is required" : null,
            style: GoogleFonts.poppins(),
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
          _buildDropdownField<WarehouseDropdownModel>(
            label: "Warehouse",
            icon: Icons.warehouse_outlined,
            value: _selectedWarehouse,
            items: _warehouses,
            onChanged: (val) => setState(() => _selectedWarehouse = val),
            itemToString: (w) => w.warehouseName,
            validator: (val) => val == null ? "Warehouse is required" : null,
          ),
          const SizedBox(height: 16),
          _buildDropdownField<LocationDropdownModel>(
            label: "Parent Location (Optional)",
            icon: Icons.account_tree_outlined,
            value: _selectedParent,
            items: _parents,
            onChanged: (val) => setState(() => _selectedParent = val),
            itemToString: (l) => l.name,
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Form(
      key: _formKeys[2],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[2]['title']!),
          TextFormField(controller: _lengthController, decoration: _getInputDecoration("Length (m)", prefixIcon: Icons.straighten), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _widthController, decoration: _getInputDecoration("Width (m)", prefixIcon: Icons.unfold_more), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _heightController, decoration: _getInputDecoration("Height (m)", prefixIcon: Icons.unfold_less), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _volumeController, decoration: _getInputDecoration("Volume (m³)", prefixIcon: Icons.view_in_ar_outlined), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _descriptionController, decoration: _getInputDecoration("Description", prefixIcon: Icons.notes_outlined), maxLines: 3),
        ],
      ),
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
          if (_currentStep > 0) Expanded(child: OutlinedButton(onPressed: _previousStep, style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52), side: BorderSide(color: Colors.grey.shade300), shape: RoundedRectangleBorder(borderRadius: borderRadius)), child: Text("Back", style: GoogleFonts.poppins(color: Colors.grey.shade700, fontWeight: FontWeight.w600)))),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isSubmitting ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: softGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text(_currentStep == _totalSteps - 1 ? "Save Location" : "Next", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
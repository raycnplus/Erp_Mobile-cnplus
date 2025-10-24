// update_location_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/update_location_models.dart';

class LocationUpdateWidget extends StatefulWidget {
  final LocationUpdateModel location;
  const LocationUpdateWidget({super.key, required this.location});

  @override
  State<LocationUpdateWidget> createState() => _LocationUpdateWidgetState();
}

class _LocationUpdateWidgetState extends State<LocationUpdateWidget> {
  // --- State Management untuk Stepper Kustom ---
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = [ GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>() ];

  // --- Controllers & State ---
  late TextEditingController _nameController, _codeController, _lengthController, _widthController, _heightController, _volumeController, _descriptionController;
  
  bool _isLoadingDropdowns = true;
  bool _isSubmitting = false;
  List<WarehouseDropdownModel> _warehouses = [];
  List<LocationDropdownModel> _parentLocations = [];
  WarehouseDropdownModel? _selectedWarehouse;
  LocationDropdownModel? _selectedParent;
  String? _dropdownError;

  // --- Style ---
  final softGreen = const Color(0xFF679436);
  final lightGreen = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'Main Information', 'guide': 'Edit the name and unique code for this location.'},
    {'title': 'Placement & Association', 'guide': 'Change the warehouse or parent location.'},
    {'title': 'Dimensions & Notes', 'guide': 'Update measurement details and description.'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.locationName);
    _codeController = TextEditingController(text: widget.location.locationCode);
    _lengthController = TextEditingController(text: widget.location.length.toString());
    _widthController = TextEditingController(text: widget.location.width.toString());
    _heightController = TextEditingController(text: widget.location.height.toString());
    _volumeController = TextEditingController(text: widget.location.volume.toString());
    _descriptionController = TextEditingController(text: widget.location.description);
    _loadInitialDropdowns();
  }

  @override
  void dispose() {
    _pageController.dispose(); _nameController.dispose(); _codeController.dispose(); _lengthController.dispose(); _widthController.dispose(); _heightController.dispose(); _volumeController.dispose(); _descriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _loadInitialDropdowns() async {
    await Future.wait([_fetchWarehouses(), _fetchParentLocations()]);
    if (mounted) setState(() => _isLoadingDropdowns = false);
  }

  Future<void> _fetchWarehouses() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) return;
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List<dynamic> list = decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);
        final fetchedWarehouses = list.map((json) => WarehouseDropdownModel.fromJson(json)).toList();
        
        WarehouseDropdownModel? initialWarehouse;
        try {
          initialWarehouse = fetchedWarehouses.firstWhere((w) => w.idWarehouse == widget.location.idWarehouse);
        } catch (e) {
          initialWarehouse = null; 
          debugPrint("Initial warehouse with ID ${widget.location.idWarehouse} not found.");
        }

        if(mounted) setState(() { _warehouses = fetchedWarehouses; _selectedWarehouse = initialWarehouse; });
      }
    } catch (e) {
      debugPrint("Failed to fetch warehouses: $e");
    }
  }

  Future<void> _fetchParentLocations() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) return;
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/location"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List<dynamic> list = decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);
        final fetchedLocations = list.map((json) => LocationDropdownModel.fromJson(json)).toList();
        
        LocationDropdownModel? initialParent;
        if (widget.location.idParentLocation != null) {
          try {
            initialParent = fetchedLocations.firstWhere((l) => l.idLocation == widget.location.idParentLocation);
          } catch (e) {
            initialParent = null;
            debugPrint("Initial parent location with ID ${widget.location.idParentLocation} not found.");
          }
        }
        if(mounted) setState(() { _parentLocations = fetchedLocations; _selectedParent = initialParent; });
      }
    } catch (e) {
      debugPrint("Failed to fetch parent locations: $e");
    }
  }

  Future<void> _updateLocation() async {
    setState(() => _isSubmitting = true);
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication error.")));
        setState(() => _isSubmitting = false);
        return;
    }
    try {
        final response = await http.put(
            Uri.parse("${ApiBase.baseUrl}/inventory/location/${widget.location.idLocation}"),
            headers: {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json"},
            body: jsonEncode({
                "location_name": _nameController.text, "location_code": _codeController.text, "warehouse": _selectedWarehouse?.idWarehouse, "parent_location": _selectedParent?.idLocation, "length": int.tryParse(_lengthController.text) ?? 0, "width": int.tryParse(_widthController.text) ?? 0, "height": int.tryParse(_heightController.text) ?? 0, "volume": _volumeController.text, "description": _descriptionController.text,
            }),
        );
        if (!mounted) return;
        if (response.statusCode == 200) {
            Navigator.pop(context, true);
        } else {
            final errorData = jsonDecode(response.body);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update: ${errorData['message'] ?? response.body}")));
        }
    } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    } finally {
        if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _updateLocation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: softGreen.withOpacity(0.8), size: 20) : null,
      labelText: label, labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600), filled: true, fillColor: lightGreen.withOpacity(0.3), border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0)), focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen, width: 2.0)), errorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 1.5)), focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  Widget _buildTitleSection(String title) {
    return Padding(padding: const EdgeInsets.only(top: 24, bottom: 12), child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: softGreen)));
  }

  Widget _buildDropdownField<T>({
    required String label, required IconData icon, required T? value, required List<T> items, required void Function(T?)? onChanged, required String Function(T) itemToString, String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value, items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(itemToString(item), style: GoogleFonts.poppins()))).toList(), onChanged: onChanged, decoration: _getInputDecoration(label, prefixIcon: icon), validator: validator, isExpanded: true, icon: Icon(Icons.arrow_drop_down, color: softGreen),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Update Location", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
              children: [ _buildStep1(), _buildStep2(), _buildStep3() ],
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
          TextFormField(controller: _nameController, decoration: _getInputDecoration("Location Name", prefixIcon: Icons.label_outline), validator: (val) => val == null || val.isEmpty ? "Location Name is required" : null, style: GoogleFonts.poppins()),
          const SizedBox(height: 16),
          TextFormField(controller: _codeController, decoration: _getInputDecoration("Location Code", prefixIcon: Icons.qr_code_2_outlined), validator: (val) => val == null || val.isEmpty ? "Location Code is required" : null, style: GoogleFonts.poppins()),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    if (_isLoadingDropdowns) return const Center(child: CircularProgressIndicator());
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
            items: _parentLocations,
            onChanged: (val) => setState(() => _selectedParent = val),
            itemToString: (l) => l.locationName,
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
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isSubmitting ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: softGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Text(_currentStep == _totalSteps - 1 ? "Update Location" : "Next", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
// create_location_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/create_location_models.dart';

class LocationCreateWidget extends StatefulWidget {
  // Callback untuk memberitahu parent (screen) tentang perubahan step
  final Function(int currentStep, int totalSteps) onStepChanged;

  const LocationCreateWidget({
    super.key,
    required this.onStepChanged,
  });

  @override
  State<LocationCreateWidget> createState() => _LocationCreateWidgetState();
}

class _LocationCreateWidgetState extends State<LocationCreateWidget> {
  // State Management untuk Stepper
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form Keys untuk validasi per langkah
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();

  // Controllers untuk semua input field
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _descriptionController = TextEditingController();

  // State untuk data dropdown dan loading
  bool _isDropdownLoading = true;
  bool _isSubmitting = false;
  List<WarehouseDropdownModel> _warehouses = [];
  List<LocationDropdownModel> _parents = [];
  WarehouseDropdownModel? _selectedWarehouse;
  LocationDropdownModel? _selectedParent;
  String? _dropdownError;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Dispose semua controller
    _nameController.dispose();
    _codeController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _volumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // --- LOGIKA PENGAMBILAN DATA ---
  Future<void> _fetchDropdownData() async {
    try {
      final results = await Future.wait([
        _fetchWarehouses(),
        _fetchParentLocations(),
      ]);
      if (mounted) {
        setState(() {
          _warehouses = results[0] as List<WarehouseDropdownModel>;
          _parents = results[1] as List<LocationDropdownModel>;
          _isDropdownLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _dropdownError = e.toString();
          _isDropdownLoading = false;
        });
      }
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
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"}, // Ditambahkan Accept header
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      return parsed.map((e) => LocationDropdownModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load parent locations');
  }

  // --- LOGIKA STEPPER ---
  void _nextStep() {
    // Validasi form pada step saat ini
    bool isStepValid = false;
    if (_currentStep == 0) {
      isStepValid = _formKeyStep1.currentState!.validate();
    } else if (_currentStep == 1) {
      isStepValid = _formKeyStep2.currentState!.validate();
    } else if (_currentStep == 2) {
      isStepValid = _formKeyStep3.currentState!.validate();
    }

    if (isStepValid && _currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      widget.onStepChanged(_currentStep, _totalSteps);
    } else if (isStepValid && _currentStep == _totalSteps - 1) {
      // Jika di step terakhir dan valid, jalankan fungsi create
      _createLocation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      widget.onStepChanged(_currentStep, _totalSteps);
    }
  }

  // --- LOGIKA SUBMIT DATA ---
  Future<void> _createLocation() async {
    setState(() => _isSubmitting = true);
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      final model = LocationCreateModel(
        locationName: _nameController.text,
        locationCode: _codeController.text,
        warehouseId: _selectedWarehouse!.idWarehouse,
        parentLocationId: _selectedParent?.id,
        length: double.tryParse(_lengthController.text),
        width: double.tryParse(_widthController.text),
        height: double.tryParse(_heightController.text),
        volume: double.tryParse(_volumeController.text),
        description: _descriptionController.text,
      );
      final response = await http.post(
        Uri.parse('${ApiBase.baseUrl}/inventory/location'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json", // ▼▼▼ TAMBAHKAN BARIS INI ▼▼▼
        },
        body: jsonEncode(model.toJson()),
      );

      if (!mounted) return;
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context, true); // Kirim sinyal sukses kembali ke index
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

  // --- UI WIDGETS ---
  @override
  Widget build(BuildContext context) {
    // Referensi warna dan style dari Product Type
    final softGreen = const Color(0xFF679436);
    final lightGreen = const Color(0xFFC8E6C9);
    final borderRadius = BorderRadius.circular(16.0);
    final inputDecorationTheme = InputDecoration(
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      filled: true,
      fillColor: lightGreen.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen.withOpacity(0.5), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: softGreen, width: 2.0)),
    );

    // Daftar judul dan guide text untuk setiap step
    final stepDetails = [
      {'title': 'Informasi Utama', 'guide': 'Isi nama dan kode unik untuk lokasi ini.'},
      {'title': 'Penempatan & Asosiasi', 'guide': 'Pilih gudang dan lokasi induk (jika ada).'},
      {'title': 'Dimensi & Catatan', 'guide': 'Masukkan detail ukuran dan deskripsi (opsional).'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Header Stepper Kustom (sesuai referensi gambar)
          _buildStepperHeader(stepDetails),

          // Body Stepper dengan PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Nonaktifkan swipe
              children: [
                _buildStep1(inputDecorationTheme),
                _buildStep2(inputDecorationTheme),
                _buildStep3(inputDecorationTheme),
              ],
            ),
          ),

          // Tombol Navigasi
          _buildNavigationButtons(softGreen, borderRadius),
        ],
      ),
    );
  }

  Widget _buildStepperHeader(List<Map<String, String>> stepDetails) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF679436),
            child: Text(
              '${_currentStep + 1}/${_totalSteps}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stepDetails[_currentStep]['title']!,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                stepDetails[_currentStep]['guide']!,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK SETIAP LANGKAH ---
  Widget _buildStep1(InputDecoration inputDecorationTheme) {
    return Form(
      key: _formKeyStep1,
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: inputDecorationTheme.copyWith(labelText: "Nama Lokasi"),
            validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: inputDecorationTheme.copyWith(labelText: "Kode Lokasi"),
            validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(InputDecoration inputDecorationTheme) {
    if (_isDropdownLoading) return const Center(child: CircularProgressIndicator());
    if (_dropdownError != null) return Center(child: Text("Error: $_dropdownError"));

    return Form(
      key: _formKeyStep2,
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: [
          // Menggunakan Dropdown standar, namun bisa diganti dengan searchable_dropdown
          DropdownButtonFormField<WarehouseDropdownModel>(
            value: _selectedWarehouse,
            items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w.warehouseName))).toList(),
            onChanged: (val) => setState(() => _selectedWarehouse = val),
            decoration: inputDecorationTheme.copyWith(labelText: "Pilih Gudang"),
            validator: (val) => val == null ? "Gudang wajib dipilih" : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<LocationDropdownModel>(
            value: _selectedParent,
            isExpanded: true,
            items: _parents.map((p) => DropdownMenuItem(value: p, child: Text(p.name, overflow: TextOverflow.ellipsis,))).toList(),
            onChanged: (val) => setState(() => _selectedParent = val),
            decoration: inputDecorationTheme.copyWith(labelText: "Pilih Lokasi Induk (Opsional)"),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(InputDecoration inputDecorationTheme) {
    return Form(
      key: _formKeyStep3,
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: [
          TextFormField(controller: _lengthController, decoration: inputDecorationTheme.copyWith(labelText: "Panjang (m)"), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _widthController, decoration: inputDecorationTheme.copyWith(labelText: "Lebar (m)"), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _heightController, decoration: inputDecorationTheme.copyWith(labelText: "Tinggi (m)"), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _volumeController, decoration: inputDecorationTheme.copyWith(labelText: "Volume (m³)"), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          TextFormField(controller: _descriptionController, decoration: inputDecorationTheme.copyWith(labelText: "Deskripsi"), maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(Color softGreen, BorderRadius borderRadius) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Tombol Kembali
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 52),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                child: Text("Kembali", style: GoogleFonts.poppins(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),

          // Tombol Lanjut / Simpan
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [BoxShadow(color: softGreen.withOpacity(0.4), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))],
              ),
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: softGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text(
                  _currentStep == _totalSteps - 1 ? "Simpan Lokasi" : "Lanjut",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
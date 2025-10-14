import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/api_base.dart';
import '../models/karyawan_dropdown_model.dart';
import '../models/sales_team_create_model.dart';

class SalesTeamForm extends StatefulWidget {
  const SalesTeamForm({super.key});

  @override
  State<SalesTeamForm> createState() => _SalesTeamFormState();
}

class _SalesTeamFormState extends State<SalesTeamForm> {
  // --- State untuk Stepper ---
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 2;
  // DEKLARASI: Menggunakan _formKeys (List), bukan _formKey (tunggal)
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), 
    GlobalKey<FormState>(),
  ];

  // --- Controller & State Data ---
  final _teamNameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;
  bool _loadingKaryawan = true;

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  // LINT: Menjadikan _selectedMembers sebagai final sesuai anjuran analyzer
  final List<KaryawanDropdownModel> _selectedMembers = [];
  String _memberSearchQuery = ''; 

  // --- Endpoint URLs ---
  final String _karyawanUrl = "${ApiBase.baseUrl}/master/karyawans";
  final String _storeSalesTeamUrl = "${ApiBase.baseUrl}/sales/sales-team/store";

  // --- Style & Tema ---
  final primaryColor = const Color(0xFF679436);
  final accentColor = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'Main Information', 'guide': 'Fill in team name, description, and select a leader.'},
    {'title': 'Select Team Members', 'guide': 'Add members to your sales team.'},
  ];

  @override
  void initState() {
    super.initState();
    _loadKaryawanList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _teamNameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- Logika Fetch Data ---
  Future<void> _loadKaryawanList() async {
    setState(() => _loadingKaryawan = true);
    try {
      final token = await const FlutterSecureStorage().read(key: 'token');
      final response = await http.get(
        Uri.parse(_karyawanUrl),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        final result = data.map((e) => KaryawanDropdownModel.fromJson(e)).toList();
        result.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
        if (mounted) setState(() => _karyawanList = result);
      } else { throw Exception("Gagal memuat daftar karyawan"); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loadingKaryawan = false);
    }
  }

  // --- Logika Navigasi Stepper ---
  void _nextStep() {
    // PERBAIKAN: Menggunakan _formKeys[_currentStep] untuk validasi
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  // --- [SOLUSI] Method untuk menampilkan picker karyawan dalam bottom sheet ---
  Future<void> _showEmployeePicker({required Function(KaryawanDropdownModel) onSelected}) async {
    String searchQuery = '';
    List<KaryawanDropdownModel> filteredList = _karyawanList;

    await showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8, maxChildSize: 0.9, expand: false,
              builder: (_, scrollController) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: (value) {
                          modalState(() {
                            searchQuery = value.toLowerCase();
                            filteredList = _karyawanList.where((k) => k.fullName.toLowerCase().contains(searchQuery)).toList();
                          });
                        },
                        decoration: _getInputDecoration("Search employee name...", prefixIcon: Icons.search),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final karyawan = filteredList[index];
                          return ListTile(
                            title: Text(karyawan.fullName, style: GoogleFonts.lato()),
                            onTap: () {
                              onSelected(karyawan);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  // --- Logika Submit Form ---
  Future<void> _submitForm() async {
    // PERBAIKAN: Validasi menggunakan _formKeys[0]
    if (!_formKeys[0].currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final token = await const FlutterSecureStorage().read(key: 'token');
      final memberIds = _selectedMembers.where((m) => m.id != _selectedLeader!.id).map((m) => m.id).toSet().toList();
      final salesTeam = SalesTeamCreateModel(
        teamName: _teamNameController.text.trim(),
        teamLeaderId: _selectedLeader!.id,
        description: _descController.text.trim(),
        memberIds: memberIds,
      );
      final response = await http.post(
        Uri.parse(_storeSalesTeamUrl),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode(salesTeam.toJson()),
      );
      if (!mounted) return;
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sales Team created successfully!"), backgroundColor: Colors.green,));
        Navigator.pop(context, true);
      } else {
        final error = jsonDecode(response.body)['message'] ?? "Gagal membuat team";
        throw Exception(error);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red,));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  // --- UI Helper Widgets ---
  InputDecoration _getInputDecoration(String label, {IconData? prefixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: primaryColor.withAlpha(204), size: 20) : null,
      hintText: label,
      hintStyle: GoogleFonts.lato(color: Colors.grey.shade600),
      filled: true,
      fillColor: accentColor.withAlpha(77),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      focusedBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide(color: primaryColor, width: 2.0)),
    );
  }
  
  Widget _buildTitleSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: primaryColor)),
    );
  }

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    return _loadingKaryawan
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(16,16,16,0), child: _buildStepperHeader()),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_buildStep1(), _buildStep2()],
                ),
              ),
              _buildNavigationButtons(),
            ],
          );
  }

  // --- [LANGKAH 1] Informasi Utama Tim ---
  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTitleSection(stepDetails[0]['title']!),
          TextFormField(
            controller: _teamNameController,
            decoration: _getInputDecoration("Team Name", prefixIcon: Icons.groups_3_outlined),
            style: GoogleFonts.lato(),
            validator: (v) => v!.isEmpty ? "Team name is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: _selectedLeader?.fullName ?? ''),
            decoration: _getInputDecoration("Team Leader", prefixIcon: Icons.star_border_outlined)
                .copyWith(suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor)),
            onTap: () => _showEmployeePicker(onSelected: (karyawan) {
              setState(() {
                _selectedLeader = karyawan;
                _selectedMembers.removeWhere((m) => m.id == karyawan.id);
              });
            }),
            validator: (_) => _selectedLeader == null ? "Team leader is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descController,
            decoration: _getInputDecoration("Description", prefixIcon: Icons.notes_outlined),
            style: GoogleFonts.lato(),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // --- [LANGKAH 2] Pemilihan Anggota Tim ---
  Widget _buildStep2() {
    final filteredMembers = _karyawanList.where((k) {
      final isLeader = _selectedLeader?.id == k.id;
      final matchesSearch = k.fullName.toLowerCase().contains(_memberSearchQuery.toLowerCase());
      return !isLeader && matchesSearch;
    }).toList();

    return Form(
      key: _formKeys[1],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _buildTitleSection(stepDetails[1]['title']!),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) => setState(() => _memberSearchQuery = value),
              decoration: _getInputDecoration("Search member name...", prefixIcon: Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final karyawan = filteredMembers[index];
                final isSelected = _selectedMembers.any((m) => m.id == karyawan.id);
                return CheckboxListTile(
                  title: Text(karyawan.fullName, style: GoogleFonts.lato()),
                  value: isSelected,
                  activeColor:  Color(0xFF2D6A4F),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedMembers.add(karyawan);
                      } else {
                        _selectedMembers.removeWhere((m) => m.id == karyawan.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Stepper Header & Navigation Buttons ---
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
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: primaryColor.withAlpha(102), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isLoading ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : Text(_currentStep == _totalSteps - 1 ? "Save Team" : "Next", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
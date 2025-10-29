//  isi file sales_team_update_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/api_base.dart';
import '../models/sales_team_update_models.dart';
import '../models/karyawan_dropdowns_models.dart';

class SalesTeamUpdateForm extends StatefulWidget {
  final int id;
  const SalesTeamUpdateForm({super.key, required this.id});

  @override
  State<SalesTeamUpdateForm> createState() => _SalesTeamUpdateFormState();
}

class _SalesTeamUpdateFormState extends State<SalesTeamUpdateForm> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 2;
  final List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];

  final _storage = const FlutterSecureStorage();
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSubmitting = false;

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  final List<KaryawanDropdownModel> _selectedMembers = [];
  String _memberSearchQuery = '';

  final primaryColor = const Color(0xFF679436);
  final accentColor = const Color(0xFFC8E6C9);
  final borderRadius = BorderRadius.circular(16.0);
  final stepDetails = [
    {'title': 'Main Information', 'guide': 'Update team name, description, and leader.'},
    {'title': 'Update Team Members', 'guide': 'Add or remove members from the sales team.'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _teamNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await _fetchKaryawan();
    await _fetchTeamData();
  }

  Future<void> _fetchKaryawan() async {
    final token = await _storage.read(key: 'token');
    try {
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/master/karyawans'),
        headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['status'] == true && body['data'] is List) {
          final List data = body['data'];
          final result = data.map((e) => KaryawanDropdownModel.fromJson(e)).toList();
          result.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
          if(mounted) setState(() => _karyawanList = result);
        } else {
           throw Exception("Format data karyawan tidak valid");
        }
      } else { throw Exception("Gagal memuat daftar karyawan"); }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Karyawan: ${e.toString()}")));
    }
  }

  Future<void> _fetchTeamData() async {
    if (_karyawanList.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final karyawanMap = {for (var k in _karyawanList) k.id: k};
    final token = await _storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('${ApiBase.baseUrl}/sales/sales-team/${widget.id}'),
        headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final teamJson = json.decode(response.body);
        final teamData = SalesTeamUpdateModel.fromJson(teamJson);

        if (mounted) {
          setState(() {
            _teamNameController.text = teamData.teamName;
            _descriptionController.text = teamData.description ?? '';
            
            if (teamData.teamLeaderName.isNotEmpty) {
              try {
                _selectedLeader = _karyawanList.firstWhere(
                  (k) => k.fullName.toLowerCase() == teamData.teamLeaderName.toLowerCase()
                );
              } catch (e) {
                debugPrint("Peringatan: Leader dengan NAMA '${teamData.teamLeaderName}' tidak ditemukan.");
              }
            }

            _selectedMembers.clear();
            for (var memberId in teamData.memberIds) {
              final member = karyawanMap[memberId];
              if (member != null) {
                _selectedMembers.add(member);
              } else {
                debugPrint("Peringatan: Member dengan ID $memberId tidak ditemukan.");
              }
            }
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Gagal memuat data tim. Status: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error saat mengambil data tim: ${e.toString()}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
  
  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _updateTeam();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future<void> _updateTeam() async {
    if (!_formKeys[0].currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final token = await _storage.read(key: 'token');
    final memberIds = _selectedMembers.where((m) => m.id != _selectedLeader?.id).map((m) => m.id).toSet().toList();

    final body = {
      "team_name": _teamNameController.text,
      "team_leader": _selectedLeader?.id,
      "description": _descriptionController.text,
      "members": memberIds.map((id) => {'id_karyawan': id}).toList(), 
    };

    try {
      final response = await http.put(
        Uri.parse('${ApiBase.baseUrl}/sales/sales-team/${widget.id}'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json', "Accept": "application/json"},
        body: json.encode(body),
      );

      if (!mounted) return;
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'] ?? 'Sales Team updated successfully'), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to update team');
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isSubmitting = false);
    }
  }
  
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
  
  Future<void> _showEmployeePicker({required Function(KaryawanDropdownModel) onSelected}) async {
     String searchQuery = '';
    List<KaryawanDropdownModel> filteredList = _karyawanList;

    await showModalBottomSheet(
      context: context, isScrollControlled: true,
      // ✅ KODE YANG SUDAH DIPERBAIKI
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
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
          ),
    );
  }
  
  Widget _buildStep1() {
    return Form(
      key: _formKeys[0],
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(padding: const EdgeInsets.only(top: 24, bottom: 16), child: Text(stepDetails[0]['title']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: primaryColor))),
          TextFormField(controller: _teamNameController, decoration: _getInputDecoration("Team Name", prefixIcon: Icons.groups_3_outlined), style: GoogleFonts.lato(), validator: (v) => v!.isEmpty ? "Team name is required" : null),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: _selectedLeader?.fullName ?? ''),
            decoration: _getInputDecoration("Team Leader", prefixIcon: Icons.star_border_outlined).copyWith(suffixIcon: Icon(Icons.arrow_drop_down, color: primaryColor)),
            onTap: () => _showEmployeePicker(onSelected: (karyawan) {
              setState(() { _selectedLeader = karyawan; _selectedMembers.removeWhere((m) => m.id == karyawan.id); });
            }),
            validator: (_) => _selectedLeader == null ? "Team leader is required" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _descriptionController, decoration: _getInputDecoration("Description", prefixIcon: Icons.notes_outlined), style: GoogleFonts.lato(), maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final filteredMembers = _karyawanList.where((k) {
      final isLeader = _selectedLeader?.id == k.id;
      final matchesSearch = k.fullName.toLowerCase().contains(_memberSearchQuery.toLowerCase());
      return !isLeader && matchesSearch;
    }).toList();

    return Form(
      key: _formKeys[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), child: Text(stepDetails[1]['title']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: primaryColor))),
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
                  activeColor:  const Color(0xFF2D6A4F),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) { _selectedMembers.add(karyawan); } else { _selectedMembers.removeWhere((m) => m.id == karyawan.id); }
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
          Expanded(child: Container(decoration: BoxDecoration(borderRadius: borderRadius, boxShadow: [BoxShadow(color: primaryColor.withAlpha(102), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 6))]), child: ElevatedButton(onPressed: _isSubmitting ? null : _nextStep, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52), backgroundColor: primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: borderRadius), elevation: 0), child: _isSubmitting ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : Text(_currentStep == _totalSteps - 1 ? "Update Team" : "Next", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))))),
        ],
      ),
    );
  }
}
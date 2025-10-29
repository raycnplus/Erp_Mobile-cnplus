
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/api_base.dart';

import '../models/purchase_team_update_model.dart';
import '../models/karyawan_dropdown_model.dart';

class PurchaseTeamUpdateForm extends StatefulWidget {
  final int id;

  const PurchaseTeamUpdateForm({super.key, required this.id});

  @override
  State<PurchaseTeamUpdateForm> createState() => _PurchaseTeamUpdateFormState();
}

class _PurchaseTeamUpdateFormState extends State<PurchaseTeamUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // [BARU] Controller untuk field Team Leader
  final TextEditingController _leaderDisplayController = TextEditingController();

  KaryawanDropdownModel? _selectedLeader;
  final List<KaryawanDropdownModel> _selectedMembers = [];

  bool _isLoading = true;
  bool _isSubmitting = false;

  List<KaryawanDropdownModel> _karyawanList = [];
  Map<int, KaryawanDropdownModel> _karyawanMap = {};

  // --- Definisi Warna & Style Modern ---
  static const Color accentColor = Color(0xFF2D6A4F); // Hijau tua konsisten
  static final Color accentBgColor = accentColor.withOpacity(0.08); // Latar belakang
  static final Color softGrey = Colors.grey.shade100; // Latar belakang input

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  // --- Helper untuk Judul Bagian ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 16.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  // --- Helper untuk Dekorasi Input Modern ---
  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      fillColor: softGrey, // Warna latar belakang field
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none, // Hilangkan border default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2), // Border saat fokus
      ),
    );
  }

  // --- Logika Fetch Data ---
  Future<void> _fetchInitialData() async {
    try {
      await _fetchKaryawan();
      if (mounted) {
        await _fetchTeamData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error memuat data awal: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchKaryawan() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/karyawans'),
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      if (body['status'] == true && body['data'] is List) {
        final List data = body['data'];
        
        final result = data
            .map((e) => KaryawanDropdownModel.fromJson(e))
            .where((k) => k.id != 0 && k.fullName.isNotEmpty)
            .toList();
        
        if (mounted) {
          setState(() {
            _karyawanList = result;
            _karyawanMap = {for (var k in _karyawanList) k.id: k};
          });
        }
      } else {
        throw Exception('Format data karyawan tidak valid');
      }
    } else {
      throw Exception('Gagal memuat daftar karyawan');
    }
  }

  Future<void> _fetchTeamData() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/purchase/purchase-team/${widget.id}'),
      headers: {'Authorization': 'Bearer $token', "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> teamJson = json.decode(response.body);
      final teamData = PurchaseTeamUpdateModel.fromJson(teamJson);

      setState(() {
        _teamNameController.text = teamData.teamName;
        _descriptionController.text = teamData.description ?? '';
        
        _selectedLeader = _karyawanMap[teamData.teamLeaderId];
        // [BARU] Set teks untuk display controller
        _leaderDisplayController.text = _selectedLeader?.fullName ?? '';
        
        _selectedMembers.clear();
        for (var memberId in teamData.memberIds) {
          if (_karyawanMap.containsKey(memberId)) {
            _selectedMembers.add(_karyawanMap[memberId]!);
          }
        }
        _isLoading = false;
      });
    } else {
      throw Exception('Gagal memuat data tim');
    }
  }

  // --- Logika Update Data ---
  Future<void> _updateTeam() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final token = await _storage.read(key: 'token');
    
    final body = {
      "team_name": _teamNameController.text,
      "team_leader_id": _selectedLeader?.id,
      "description": _descriptionController.text,
      "members": _selectedMembers.map((m) => {'id_karyawan': m.id}).toList(),
    };

    try {
      final response = await http.put(
        Uri.parse('${ApiBase.baseUrl}/purchase/purchase-team/${widget.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: json.encode(body),
      );

      final responseBody = json.decode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'] ?? 'Purchase Team updated successfully'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(responseBody['message'] ?? 'Failed to update team');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  // --- [BARU] FUNGSI UNTUK MODAL PENCARIAN ---
  Future<void> _showLeaderSearchModal() async {
    // Menampilkan modal bottom sheet
    final KaryawanDropdownModel? result = await showModalBottomSheet<KaryawanDropdownModel>(
      context: context,
      isScrollControlled: true, // Penting agar modal bisa full-height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        // StatefulBuilder agar UI di dalam modal bisa di-update (untuk search)
        return StatefulBuilder(
          builder: (stfContext, setModalState) {
            String searchQuery = "";
            List<KaryawanDropdownModel> filteredList = _karyawanList;

            // Logika filter
            if (searchQuery.isNotEmpty) {
              filteredList = _karyawanList
                  .where((k) => k.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();
            }

            return Container(
              // Atur tinggi modal, misal 80% layar
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Judul Modal
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Select Team Leader",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Search Bar di dalam Modal
                  TextField(
                    onChanged: (value) {
                      setModalState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: _buildInputDecoration("Search Karyawan...").copyWith(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    ),
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(height: 16),

                  // 3. Daftar Karyawan
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final karyawan = filteredList[index];
                        final bool isSelected = _selectedLeader?.id == karyawan.id;
                        
                        return ListTile(
                          title: Text(karyawan.fullName, style: GoogleFonts.poppins()),
                          selected: isSelected,
                          selectedTileColor: accentBgColor,
                          trailing: isSelected 
                              ? const Icon(Icons.check, color: accentColor) 
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onTap: () {
                            // Kirim data Karyawan yang dipilih kembali ke form
                            Navigator.pop(modalContext, karyawan);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Setelah modal ditutup, cek hasilnya
    if (result != null) {
      setState(() {
        _selectedLeader = result;
        _leaderDisplayController.text = result.fullName;
      });
    }
  }
  
  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    _leaderDisplayController.dispose(); // [BARU] Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: accentColor));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: accentColor,
          selectionColor: accentBgColor,
          selectionHandleColor: accentColor,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian 1: Detail Tim ---
              _buildSectionTitle("Team Details"),
              TextFormField(
                controller: _teamNameController,
                decoration: _buildInputDecoration("Team Name"),
                validator: (val) => val!.isEmpty ? "Team name cannot be empty" : null,
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),

              // --- [DIUBAH] Field Team Leader ---
              TextFormField(
                controller: _leaderDisplayController,
                readOnly: true, // Penting! Agar keyboard tidak muncul
                decoration: _buildInputDecoration("Team Leader").copyWith(
                  // Tambah ikon untuk menandakan ini adalah pemilih
                  suffixIcon: const Icon(Icons.person_search_outlined, color: accentColor),
                ),
                onTap: _showLeaderSearchModal, // Panggil modal saat diketuk
                validator: (val) => val!.isEmpty ? "Please select a team leader" : null,
                style: GoogleFonts.poppins(color: Colors.black87),
              ),
              // --- AKHIR PERUBAHAN ---

              // --- Bagian 2: Anggota Tim ---
              _buildSectionTitle("Members"),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: softGrey, // Latar belakang abu-abu
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  // Logika ini otomatis me-refresh saat _selectedLeader berubah
                  children: _karyawanList
                      .where((k) => k.id != _selectedLeader?.id) 
                      .map((k) {
                        final bool isSelected = _selectedMembers.any((m) => m.id == k.id);
                        return FilterChip(
                          label: Text(
                            k.fullName,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMembers.add(k);
                              } else {
                                _selectedMembers.removeWhere((m) => m.id == k.id);
                              }
                            });
                          },
                          selectedColor: accentColor,
                          backgroundColor: Colors.white,
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSelected ? accentColor : Colors.grey.shade300,
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),

              // --- Bagian 3: Deskripsi ---
              _buildSectionTitle("Description"),
              TextFormField(
                controller: _descriptionController,
                decoration: _buildInputDecoration("Enter team description..."),
                maxLines: 4,
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 32),

              // --- Tombol Submit ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateTeam,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 54),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSubmitting 
                      ? const SizedBox(
                          key: ValueKey('loader'),
                          height: 24, 
                          width: 24, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                        )
                      : Text(
                          key: const ValueKey('text'),
                          "Update Purchase Team",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
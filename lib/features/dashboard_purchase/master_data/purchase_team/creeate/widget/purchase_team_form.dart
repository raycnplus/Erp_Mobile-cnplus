
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/api_base.dart';
import '../models/karyawan_dropdown_model.dart';
import '../models/purchase_team_create_model.dart';

class PurchaseTeamForm extends StatefulWidget {
  const PurchaseTeamForm({super.key});

  @override
  State<PurchaseTeamForm> createState() => _PurchaseTeamFormState();
}

class _PurchaseTeamFormState extends State<PurchaseTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descController = TextEditingController();

  // [BARU] Controller untuk field Team Leader
  final TextEditingController _leaderDisplayController = TextEditingController();

  // URL
  final String _createDataUrl = "${ApiBase.baseUrl}/master/karyawans";
  final String _storePurchaseTeamUrl = "${ApiBase.baseUrl}/purchase/purchase-team/store";

  // [DIUBAH] Mengganti nama state agar konsisten
  bool _isLoading = true; // Sebelumnya _loadingKaryawan
  bool _isSubmitting = false; // Sebelumnya _isLoading

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  final List<KaryawanDropdownModel> _selectedMembers = [];

  // --- [BARU] Definisi Warna & Style Modern ---
  static const Color accentColor = Color(0xFF2D6A4F); // Hijau tua konsisten
  static final Color accentBgColor = accentColor.withOpacity(0.08); // Latar belakang
  static final Color softGrey = Colors.grey.shade100; // Latar belakang input

  @override
  void initState() {
    super.initState();
    _loadKaryawanList();
  }

  // --- [BARU] Helper untuk Judul Bagian ---
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

  // --- [BARU] Helper untuk Dekorasi Input Modern ---
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

  Future<String?> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  // LOGIKA BARU: Menangani respons API yang bisa berupa Map atau List.
  Future<void> _loadKaryawanList() async {
    // [DIUBAH] Menggunakan state _isLoading
    setState(() => _isLoading = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token tidak ditemukan, silakan login ulang.")),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      final url = Uri.parse(_createDataUrl);
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> karyawanData = [];

        if (decoded is Map<String, dynamic>) {
          final dynamic rawData = decoded['data'] ?? decoded['karyawan'] ?? decoded;
          if (rawData is List) {
            karyawanData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            karyawanData = rawData['karyawan'] ?? [];
          }
        } else if (decoded is List) {
          karyawanData = decoded;
        } else {
          throw Exception("Format respons API tidak valid.");
        }

        final result = karyawanData
            .map((e) => KaryawanDropdownModel.fromJson(e))
            .where((k) => k.id != 0 && k.fullName.isNotEmpty)
            .toList();

        result.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

        setState(() {
          _karyawanList = result;
        });
      } else {
        throw Exception("Gagal memuat daftar karyawan (${response.statusCode})");
      }
    } catch (e) {
      if (!mounted) return;
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error memuat karyawan: ${e.toString()}")));
      }
    } finally {
      // [DIUBAH] Menggunakan state _isLoading
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- [BARU] FUNGSI UNTUK MODAL PENCARIAN (Dicopy dari update_widget) ---
  Future<void> _showLeaderSearchModal() async {
    final KaryawanDropdownModel? result = await showModalBottomSheet<KaryawanDropdownModel>(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (stfContext, setModalState) {
            String searchQuery = "";
            
            // Logika filter (Client-side)
            List<KaryawanDropdownModel> filteredList = _karyawanList
                  .where((k) => k.fullName.toLowerCase().contains(searchQuery.toLowerCase()))
                  .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

    if (result != null) {
      setState(() {
        _selectedLeader = result;
        _leaderDisplayController.text = result.fullName;
        // [LOGIKA CREATE] Hapus leader dari member jika sudah terpilih
        _selectedMembers.removeWhere((m) => m.id == result.id);
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedLeader == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi Team Leader dan Team Name."),
        ),
      );
      return;
    }

    // [DIUBAH] Menggunakan state _isSubmitting
    setState(() => _isSubmitting = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token tidak ditemukan, silakan login ulang.")),
        );
      }
      setState(() => _isSubmitting = false);
      return;
    }

    final memberIds = _selectedMembers
        .where((m) => m.id != _selectedLeader!.id)
        .map((m) => m.id)
        .toSet()
        .toList();

    final purchaseTeam = PurchaseTeamCreateModel(
      teamName: _teamNameController.text.trim(),
      teamLeaderId: _selectedLeader!.id,
      description: _descController.text.trim(),
      memberIds: memberIds,
    );

    final body = purchaseTeam.toJson();

    try {
      final url = Uri.parse(_storePurchaseTeamUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchase Team berhasil dibuat!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } else {
        String errorMsg = "Gagal membuat team (${response.statusCode})";
        try {
          final errorBody = jsonDecode(response.body);
          errorMsg = errorBody['message'] ?? errorBody['error'] ?? response.body;
        } catch (_) {
          errorMsg = "Server error: ${response.statusCode}";
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (!mounted) return;
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red));
      }
    } finally {
      // [DIUBAH] Menggunakan state _isSubmitting
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _descController.dispose();
    _leaderDisplayController.dispose(); // [BARU] Dispose controller
    super.dispose();
  }

  // [DIUBAH] Mengupdate style Error State
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
          const SizedBox(height: 10),
          Text(
            "Gagal memuat data karyawan.",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadKaryawanList,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              "Coba Lagi",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // [DIUBAH] Logic loading state
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: accentColor));
    }

    if (_karyawanList.isEmpty) {
      return _buildErrorState();
    }

    // [DIUBAH TOTAL] Menggunakan struktur build dari update_widget
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

              // --- Field Team Leader (Modal Search) ---
              TextFormField(
                controller: _leaderDisplayController,
                readOnly: true, 
                decoration: _buildInputDecoration("Team Leader").copyWith(
                  suffixIcon: const Icon(Icons.person_search_outlined, color: accentColor),
                ),
                onTap: _showLeaderSearchModal, 
                validator: (val) => val!.isEmpty ? "Please select a team leader" : null,
                style: GoogleFonts.poppins(color: Colors.black87),
              ),

              // --- Bagian 2: Anggota Tim (FilterChip) ---
              _buildSectionTitle("Members"),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: softGrey, 
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
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
                controller: _descController, // Menggunakan _descController
                decoration: _buildInputDecoration("Enter team description..."),
                maxLines: 4,
                style: GoogleFonts.poppins(),
                validator: (v) => v == null || v.trim().isEmpty ? "Description wajib diisi" : null,
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
                  onPressed: _isSubmitting ? null : _submitForm, // Memanggil _submitForm
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
                          "Create Purchase Team", // Text diubah
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
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
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descController = TextEditingController();

  // URL BARU untuk mendapatkan data yang diperlukan (termasuk Karyawan) untuk form CREATE
  final String _createDataUrl = "${ApiBase.baseUrl}/master/karyawans";
  // URL untuk membuat team
  final String _storeSalesTeamUrl = "${ApiBase.baseUrl}/sales/sales-team/";


  bool _isLoading = false;
  bool _loadingKaryawan = true;

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  List<KaryawanDropdownModel> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _loadKaryawanList();
  }

  Future<String?> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  // LOGIKA BARU: Menangani respons API yang bisa berupa Map atau List.
  Future<void> _loadKaryawanList() async {
    setState(() => _loadingKaryawan = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token tidak ditemukan, silakan login ulang.")),
        );
      }
      setState(() => _loadingKaryawan = false);
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
          // KASUS 1: Respons adalah Map ({status: true, data: [...]})
          // Kita coba ambil dari key 'data', 'karyawan', atau root Map itu sendiri jika berupa List.
          final dynamic rawData = decoded['data'] ?? decoded['karyawan'] ?? decoded;
          if (rawData is List) {
            karyawanData = rawData;
          } else if (rawData is Map<String, dynamic>) {
            // Jika 'data' adalah Map, kita asumsikan karyawan ada di situ
            karyawanData = rawData['karyawan'] ?? [];
          }

        } else if (decoded is List) {
          // KASUS 2: Respons adalah List (Inilah yang menyebabkan error sebelumnya)
          karyawanData = decoded;
        } else {
          throw Exception("Format respons API tidak valid.");
        }

        // Parsing ke KaryawanDropdownModel
        final result = karyawanData.map((e) => KaryawanDropdownModel.fromJson(e)).toList();

        result.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

        setState(() {
          _karyawanList = result;
        });
      } else {
        throw Exception("Gagal memuat daftar karyawan (${response.statusCode})");
      }
    } catch (e) {
      if (!mounted) return;
      // Memastikan widget masih mounted sebelum menampilkan SnackBar
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error memuat karyawan: ${e.toString()}")));
      }
    } finally {
      if (mounted) setState(() => _loadingKaryawan = false);
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

    setState(() => _isLoading = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token tidak ditemukan, silakan login ulang.")),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    // Members: hanya id karyawan yang tidak duplikat dan BUKAN leader
    final memberIds = _selectedMembers
        .where((m) => m.id != _selectedLeader!.id)
        .map((m) => m.id)
        .toSet()
        .toList();

    // Menggunakan PurchaseTeamCreateModel untuk membuat JSON body
    final SalesTeam = SalesTeamCreateModel(
      teamName: _teamNameController.text.trim(),
      teamLeaderId: _selectedLeader!.id,
      description: _descController.text.trim(),
      memberIds: memberIds,
    );

    final body = SalesTeam.toJson();

    try {
      final url = Uri.parse(_storeSalesTeamUrl);
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
          const SnackBar(content: Text("Sales Team berhasil dibuat!")),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _descController.dispose();
    super.dispose();
  }

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
              backgroundColor: const Color(0xFF2D6A4F), // Warna aksen
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
    if (_loadingKaryawan) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_karyawanList.isEmpty) {
      return _buildErrorState();
    }

    // Tampilan Form
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: "Team Name",
                prefixIcon: Icon(Icons.groups_3_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? "Team Name wajib diisi" : null,
            ),
            const SizedBox(height: 20),

            // Leader Dropdown
            DropdownButtonFormField<KaryawanDropdownModel>(
              decoration: const InputDecoration(
                labelText: "Team Leader",
                prefixIcon: Icon(Icons.star_outline),
              ),
              value: _selectedLeader,
              items: _karyawanList.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Text(k.fullName, style: GoogleFonts.poppins()),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLeader = val;
                  // Hapus leader dari member jika sudah terpilih
                  if (val != null) {
                    _selectedMembers.removeWhere((m) => m.id == val.id);
                  }
                });
              },
              validator: (v) => v == null ? "Pilih team leader" : null,
            ),
            const SizedBox(height: 20),

            // Members Multi-select
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300)
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                leading: const Icon(Icons.people_outline, color: Color(0xFF2D6A4F)),
                title: Text(
                  _selectedMembers.isEmpty
                      ? "Pilih Anggota Tim (Opsional)"
                      : "${_selectedMembers.length} anggota terpilih",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87
                  ),
                ),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                children: _karyawanList.map((k) {
                  final isSelected = _selectedMembers.any((m) => m.id == k.id);
                  final isLeader = _selectedLeader?.id == k.id;

                  return CheckboxListTile(
                    dense: true,
                    title: Text(
                      isLeader ? "${k.fullName} (Leader)" : k.fullName,
                      style: GoogleFonts.poppins(
                        color: isLeader ? Colors.grey.shade600 : Colors.black87,
                        fontStyle: isLeader ? FontStyle.italic : FontStyle.normal,
                        fontWeight: isLeader ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                    value: isSelected,
                    onChanged: isLeader
                        ? null
                        : (val) {
                      setState(() {
                        if (val == true) {
                          // Pastikan member tidak duplikat
                          if (!_selectedMembers.any((m) => m.id == k.id)) {
                            _selectedMembers.add(k);
                          }
                        } else {
                          _selectedMembers.removeWhere((m) => m.id == k.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Description",
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (v) => v == null || v.trim().isEmpty ? "Description wajib diisi" : null,
            ),
            const SizedBox(height: 30),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D6A4F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "Create Sales Team",
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
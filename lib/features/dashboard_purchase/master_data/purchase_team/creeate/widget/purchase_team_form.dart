import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../services/api_base.dart';
import '../models/purchase_team_create_model.dart';
import '../models/karyawan_dropdown_model.dart';

class PurchaseTeamForm extends StatefulWidget {
  const PurchaseTeamForm({super.key});

  @override
  State<PurchaseTeamForm> createState() => _PurchaseTeamFormState();
}

class _PurchaseTeamFormState extends State<PurchaseTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descController = TextEditingController();

  final String _purchaseTeamUrl = "${ApiBase.baseUrl}/purchase/purchase-team";

  bool _isLoading = false;
  bool _loadingKaryawan = true;

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  List<KaryawanDropdownModel> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    print('[DEBUG] PurchaseTeamForm initState, mulai load karyawan');
    _loadKaryawanList();
  }

  Future<String?> _getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  Future<void> _loadKaryawanList() async {
    setState(() => _loadingKaryawan = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Token tidak ditemukan, silakan login ulang."),
        ),
      );
      setState(() => _loadingKaryawan = false);
      return;
    }

    try {
      final url = Uri.parse(_purchaseTeamUrl);
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('Response Body from _loadKaryawanList: ${response.body}');


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Kumpulkan semua karyawan unik dari team_leader dan members
        final seen = <int>{};
        final result = <KaryawanDropdownModel>[];

        for (final team in data) {
          // team_leader
          final leader = team['team_leader'];
          if (leader != null) {
            final int? id = leader['id_karyawan'] as int?;
            final String name = (leader['nama_lengkap'] ?? '') as String;
            if (id != null && !seen.contains(id)) {
              seen.add(id);
              result.add(KaryawanDropdownModel(id: id, fullName: name));
            }
          }
          // members
          final List<dynamic> members = (team['members'] as List<dynamic>?) ?? [];
          for (final m in members) {
            final k = m['karyawan'];
            if (k != null) {
              final int? id = k['id_karyawan'] as int?;
              final String name = (k['nama_lengkap'] ?? '') as String;
              if (id != null && !seen.contains(id)) {
                seen.add(id);
                result.add(KaryawanDropdownModel(id: id, fullName: name));
              }
            }
          }
        }

        result.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

        setState(() {
          _karyawanList = result;
        });
      } else {
        throw Exception("Gagal memuat daftar karyawan (${response.statusCode})");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      if (mounted) setState(() => _loadingKaryawan = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedLeader == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap lengkapi semua data yang wajib diisi."),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final token = await _getToken();
    if (token == null || !mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Token tidak ditemukan, silakan login ulang."),
        ),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Members: hanya id karyawan, tidak boleh duplikat, tidak boleh sama dengan leader
    final cleanedMembers = _selectedMembers.where((m) => m.id != _selectedLeader!.id).toList();
    final memberIds = <int>{};
    final membersBody = <Map<String, dynamic>>[];
    for (final m in cleanedMembers) {
      if (!memberIds.contains(m.id)) {
        memberIds.add(m.id);
        membersBody.add({"id_karyawan": m.id});
      }
    }

    final body = {
      "purchase_team_name": _teamNameController.text.trim(),
      "team_leader": _selectedLeader!.id,
      "description": _descController.text.trim(),
      "members": membersBody,
    };

    try {
      final url = Uri.parse(_purchaseTeamUrl);
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
          const SnackBar(content: Text("Purchase Team berhasil dibuat")),
        );
        Navigator.pop(context, true);
      } else {
        String errorMsg = "Gagal membuat team (${response.statusCode})";
        try {
          final errorBody = jsonDecode(response.body);
          errorMsg = errorBody['message'] ?? response.body;
        } catch (_) {
          errorMsg = response.body;
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
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

  @override
  Widget build(BuildContext context) {
    final isLoadingUi = _loadingKaryawan;

    return Scaffold(
      body: isLoadingUi
          ? const Center(child: CircularProgressIndicator())
          : (_karyawanList.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Gagal memuat data karyawan."),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadKaryawanList,
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _teamNameController,
                          decoration: const InputDecoration(labelText: "Team Name"),
                          validator: (v) => v == null || v.trim().isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 12),

                        // Leader Dropdown
                        DropdownButtonFormField<KaryawanDropdownModel>(
                          decoration: const InputDecoration(
                            labelText: "Team Leader",
                          ),
                          value: _selectedLeader,
                          items: _karyawanList.map((k) {
                            return DropdownMenuItem(
                              value: k,
                              child: Text(k.fullName),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedLeader = val;
                              if (val != null) {
                                _selectedMembers.removeWhere((m) => m.id == val.id);
                              }
                            });
                          },
                          validator: (v) => v == null ? "Pilih team leader" : null,
                        ),
                        const SizedBox(height: 12),

                        // Members Multi-select
                        ExpansionTile(
                          title: Text(
                            _selectedMembers.isEmpty
                                ? "Pilih Anggota Tim"
                                : "${_selectedMembers.length} anggota terpilih",
                          ),
                          children: _karyawanList.map((k) {
                            final isSelected = _selectedMembers.any((m) => m.id == k.id);
                            final isLeader = _selectedLeader?.id == k.id;
                            return CheckboxListTile(
                              title: Text(
                                isLeader ? "${k.fullName} (Leader)" : k.fullName,
                                style: isLeader
                                    ? const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      )
                                    : null,
                              ),
                              value: isSelected,
                              onChanged: isLeader
                                  ? null
                                  : (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedMembers.add(k);
                                        } else {
                                          _selectedMembers.removeWhere((m) => m.id == k.id);
                                        }
                                      });
                                    },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _descController,
                          decoration: const InputDecoration(
                            labelText: "Description",
                          ),
                          maxLines: 3,
                          validator: (v) => v == null || v.trim().isEmpty ? "Wajib diisi" : null,
                        ),
                        const SizedBox(height: 20),

                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text("Create Team"),
                              ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
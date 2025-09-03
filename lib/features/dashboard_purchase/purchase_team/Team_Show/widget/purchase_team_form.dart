import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../services/api_base.dart';
import '../../models/purchase_team_models.dart';

class PurchaseTeamForm extends StatefulWidget {
  const PurchaseTeamForm({super.key});

  @override
  State<PurchaseTeamForm> createState() => _PurchaseTeamFormState();
}

class _PurchaseTeamFormState extends State<PurchaseTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descController = TextEditingController();

  final String baseUrl = "${ApiBase.baseUrl}/purchase/purchase-team/";

  bool _isLoading = false;
  bool _loadingKaryawan = true;

  List<KaryawanDropdownModel> _karyawanList = [];
  KaryawanDropdownModel? _selectedLeader;
  List<KaryawanDropdownModel> _selectedMembers = [];

  final String token = "YOUR_BEARER_TOKEN";

  @override
  void initState() {
    super.initState();
    _loadKaryawanFromTeams();
  }

  Future<void> _loadKaryawanFromTeams() async {
    setState(() => _loadingKaryawan = true);
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic raw = jsonDecode(response.body);

        final List<dynamic> data = (raw is List) ? raw : <dynamic>[];

        final seen = <int>{};
        final result = <KaryawanDropdownModel>[];

        for (final team in data) {
          // leader
          final leader = team['team_leader'];
          if (leader != null) {
            final int? id = leader['id_karyawan'] as int?;
            final String name = (leader['nama_lengkap'] ?? '') as String;
            if (id != null && !seen.contains(id)) {
              seen.add(id);
              result.add(KaryawanDropdownModel(id: id, fullName: name));
            }
          }

          final List<dynamic> members =
              (team['member'] as List<dynamic>?) ?? [];
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

        result.sort(
          (a, b) =>
              a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
        );

        setState(() {
          _karyawanList = result;
        });
      } else {
        throw Exception("Failed (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat karyawan: $e")));
    } finally {
      if (mounted) setState(() => _loadingKaryawan = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Lengkapi form dulu")));
      return;
    }
    if (_selectedLeader == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih team leader")));
      return;
    }

    setState(() => _isLoading = true);

    final cleanedMembers = _selectedMembers
        .where((m) => m.id != _selectedLeader!.id)
        .toList();

    final model = PurchaseTeamCreateModel(
      teamName: _teamNameController.text.trim(),
      teamLeaderId: _selectedLeader!.id,
      description: _descController.text.trim(),
      memberIds: cleanedMembers.map((e) => e.id).toList(),
    );

    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchase Team berhasil dibuat")),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Failed (${response.statusCode}): ${response.body}");
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
      appBar: AppBar(title: const Text("Create Purchase Team")),
      body: isLoadingUi
          ? const Center(child: CircularProgressIndicator())
          : (_karyawanList.isEmpty)
          ? const Center(child: Text("Data karyawan kosong"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _teamNameController,
                      decoration: const InputDecoration(labelText: "Team Name"),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? "Wajib diisi" : null,
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
                          // hindari leader ikut members
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
                      title: const Text("Select Members"),
                      children: _karyawanList.map((k) {
                        final isSelected = _selectedMembers.any(
                          (m) => m.id == k.id,
                        );
                        final isLeader = _selectedLeader?.id == k.id;
                        return CheckboxListTile(
                          title: Text(
                            isLeader ? "${k.fullName} (Leader)" : k.fullName,
                            style: isLeader
                                ? const TextStyle(fontStyle: FontStyle.italic)
                                : null,
                          ),
                          value: isSelected,
                          onChanged: isLeader
                              ? null // tidak bisa pilih leader sebagai member
                              : (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedMembers.add(k);
                                    } else {
                                      _selectedMembers.removeWhere(
                                        (m) => m.id == k.id,
                                      );
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

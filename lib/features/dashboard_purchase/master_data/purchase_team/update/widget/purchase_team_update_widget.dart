// Ganti seluruh isi file purchase_team_update_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../services/api_base.dart';

// [PERBAIKAN] Pastikan hanya impor model dari direktori yang benar
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

  KaryawanDropdownModel? _selectedLeader;
  final List<KaryawanDropdownModel> _selectedMembers = [];

  bool _isLoading = true;
  bool _isSubmitting = false;

  List<KaryawanDropdownModel> _karyawanList = [];
  Map<int, KaryawanDropdownModel> _karyawanMap = {};

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Team Name", style: GoogleFonts.poppins(fontSize: 16)),
            TextFormField(
              controller: _teamNameController,
              decoration: const InputDecoration(hintText: "Enter team name", border: OutlineInputBorder()),
              validator: (val) => val!.isEmpty ? "Team name cannot be empty" : null,
            ),
            const SizedBox(height: 16),

            Text("Team Leader", style: GoogleFonts.poppins(fontSize: 16)),
            DropdownButtonFormField<KaryawanDropdownModel>(
              value: _selectedLeader,
              items: _karyawanList
                  .map((k) => DropdownMenuItem<KaryawanDropdownModel>(
                        value: k,
                        child: Text(k.fullName),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLeader = val),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              validator: (val) => val == null ? "Please select a team leader" : null,
            ),
            const SizedBox(height: 24),

            Text("Members", style: GoogleFonts.poppins(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _karyawanList
                    .where((k) => k.id != _selectedLeader?.id)
                    .map((k) => FilterChip(
                          label: Text(k.fullName),
                          selected: _selectedMembers.any((m) => m.id == k.id),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedMembers.add(k);
                              } else {
                                _selectedMembers.removeWhere((m) => m.id == k.id);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),

            Text("Description", style: GoogleFonts.poppins(fontSize: 16)),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: "Enter team description", border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _updateTeam,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting 
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
                  : Text(
                      "Update Purchase Team",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
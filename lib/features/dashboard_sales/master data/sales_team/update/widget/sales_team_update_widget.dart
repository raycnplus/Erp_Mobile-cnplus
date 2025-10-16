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
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  int? _selectedLeaderId;
  List<int> _selectedMemberIds = [];

  bool _isLoading = true;
  bool _isSubmitting = false;

  List<KaryawanDropdownModel> _karyawanList = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchKaryawan();
    await _fetchTeamData();
  }

  Future<void> _fetchKaryawan() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/master/karyawans'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _karyawanList =
            data.map((e) => KaryawanDropdownModel.fromJson(e)).toList();
      });
    }
  }

  Future<void> _fetchTeamData() async {
    final token = await _storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/sales-team/${widget.id}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final teamData = SalesTeamUpdateModel.fromJson(responseData.first);

      setState(() {
        _teamNameController.text = teamData.teamName;
        _descriptionController.text = teamData.description ?? '';
        _selectedLeaderId = teamData.teamLeaderId;
        _selectedMemberIds = teamData.memberIds;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateTeam() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final token = await _storage.read(key: 'token');
    final body = {
      "team_name": _teamNameController.text,
      "team_leader_id": _selectedLeaderId,
      "description": _descriptionController.text,
      "members": _selectedMemberIds,
    };

    final response = await http.put(
      Uri.parse('${ApiBase.baseUrl}/sales/sales-team/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    setState(() => _isSubmitting = false);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sales Team updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: ${response.body}')),
      );
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
              decoration: const InputDecoration(hintText: "Enter team name"),
              validator: (val) =>
                  val!.isEmpty ? "Team name cannot be empty" : null,
            ),
            const SizedBox(height: 16),

            Text("Team Leader", style: GoogleFonts.poppins(fontSize: 16)),
            DropdownButtonFormField<int>(
              value: _selectedLeaderId,
              items: _karyawanList
                  .map((k) => DropdownMenuItem<int>(
                        value: k.id,
                        child: Text(k.fullName),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLeaderId = val),
              validator: (val) =>
                  val == null ? "Please select a team leader" : null,
            ),
            const SizedBox(height: 16),

            Text("Members", style: GoogleFonts.poppins(fontSize: 16)),
            Wrap(
              spacing: 6,
              children: _karyawanList
                  .map((k) => FilterChip(
                        label: Text(k.fullName),
                        selected: _selectedMemberIds.contains(k.id),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedMemberIds.add(k.id);
                            } else {
                              _selectedMemberIds.remove(k.id);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            Text("Description", style: GoogleFonts.poppins(fontSize: 16)),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(hintText: "Enter team description"),
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
                ),
                child: Text(
                  _isSubmitting ? "Updating..." : "Update Sales Team",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

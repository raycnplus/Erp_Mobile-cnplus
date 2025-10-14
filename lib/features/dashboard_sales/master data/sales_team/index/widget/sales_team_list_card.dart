
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sales_team_index_models.dart';
import '../../../../../../services/api_base.dart';

class SalesTeamCardList extends StatefulWidget {
  final String searchQuery;
  final void Function(int teamId)? onTap;

  const SalesTeamCardList({super.key, required this.searchQuery, this.onTap});

  @override
  State<SalesTeamCardList> createState() => SalesTeamCardListState();
}

class SalesTeamCardListState extends State<SalesTeamCardList> {
  late Future<List<SalesTeamModels>> _fetchTeamsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTeamsFuture = fetchTeams();
  }

  Future<List<SalesTeamModels>> fetchTeams() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/sales/sales-team/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final dynamic decodedBody = jsonDecode(response.body);
      final List<dynamic> data = decodedBody is Map && decodedBody.containsKey('data')
          ? decodedBody['data']
          : decodedBody;
      return data.map((json) => SalesTeamModels.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data tim');
    }
  }
  
  void refreshData() {
    setState(() {
      _fetchTeamsFuture = fetchTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SalesTeamModels>>(
      future: _fetchTeamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada data tim penjualan."));
        }

        final teams = snapshot.data!.where((team) {
          return team.teamName
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase());
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamCard(context, team);
          },
        );
      },
    );
  }

  Widget _buildTeamCard(BuildContext context, SalesTeamModels team) {
    const primaryGreen = Color(0xFF679436);

    return GestureDetector(
      onTap: () => widget.onTap?.call(team.idSalesTeam),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.group_work_outlined, color: primaryGreen, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.teamName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.person_pin_outlined,
                    team.teamLeader,
                    const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 6),
                  _buildInfoRow(
                    Icons.groups_outlined,
                    "${team.totalMembers} Anggota",
                    const Color(0xFFF59E0B),
                  ),
                  if (team.description.isNotEmpty) ...[
                    const Divider(height: 20),
                    Text(
                      team.description,
                      style: GoogleFonts.lato(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
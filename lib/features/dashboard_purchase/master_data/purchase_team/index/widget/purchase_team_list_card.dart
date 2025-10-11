// purchase_team_list_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/purchase_team_models.dart';
import '../../../../../../services/api_base.dart';

class PurchaseTeamCardList extends StatefulWidget {
  final String searchQuery;
  final void Function(int teamId)? onTap;

  const PurchaseTeamCardList({
    super.key,
    required this.searchQuery,
    this.onTap,
  });

  @override
  State<PurchaseTeamCardList> createState() => _PurchaseTeamCardListState();
}

class _PurchaseTeamCardListState extends State<PurchaseTeamCardList> {
  late Future<List<PurchaseTeamIndexModel>> _fetchTeamsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTeamsFuture = fetchTeams();
  }

  Future<List<PurchaseTeamIndexModel>> fetchTeams() async {
    // ... (fungsi fetchTeams() Anda tidak perlu diubah)
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('Token tidak ditemukan. Silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/purchase/purchase-team/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final dynamic decodedBody = jsonDecode(response.body);
      if (decodedBody is List) {
        return decodedBody
            .map((e) => PurchaseTeamIndexModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Format data dari API tidak sesuai (diharapkan List).');
      }
    } else {
      String errorMessage = 'Gagal mengambil data tim pembelian.';
      try {
        final errorBody = jsonDecode(response.body);
        errorMessage = errorBody['message'] ?? response.body;
      } catch (_) {
        errorMessage = response.body;
      }
      throw Exception('Error ${response.statusCode}: $errorMessage');
    }
  }

  void _retry() {
    setState(() {
      _fetchTeamsFuture = fetchTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan warna tema di sini agar mudah diubah
    final Color primaryColor = Theme.of(context).primaryColor;

    return FutureBuilder<List<PurchaseTeamIndexModel>>(
      future: _fetchTeamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // ... (Error state tidak diubah)
          return Center(
            child: Column( /* ... */ ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // ... (Empty state tidak diubah)
          return const Center(child: Text('Tidak ada data tim pembelian'));
        }

        final teams = snapshot.data!
            .where(
              (team) => /* ... (logika filter tidak diubah) ... */
                  team.teamName.toLowerCase().contains(
                        widget.searchQuery.toLowerCase(),
                      ) ||
                  team.teamLeader.toLowerCase().contains(
                        widget.searchQuery.toLowerCase(),
                      ) ||
                  team.description.toLowerCase().contains(
                        widget.searchQuery.toLowerCase(),
                      ),
            )
            .toList();

        if (teams.isEmpty) {
          return const Center(child: Text('Tim tidak ditemukan'));
        }

        return GridView.builder(
          itemCount: teams.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85, // Sesuaikan aspek rasio untuk desain baru
          ),
          itemBuilder: (context, index) {
            final team = teams[index];

            return Card(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!(team.idPurchaseTeam);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === Header Kartu dengan Ikon dan Warna ===
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: primaryColor.withOpacity(0.1),
                      child: Row(
                        children: [
                          Icon(Icons.groups_outlined, color: primaryColor, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              team.teamName,
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // === Konten Kartu ===
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Chip untuk Team Leader ===
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person, color: Colors.grey.shade700, size: 14),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    team.teamLeader,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade800,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // === Deskripsi ===
                          Text(
                            team.description.isEmpty ? 'No description' : team.description,
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 12,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
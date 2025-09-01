import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/purchase_team_models.dart';
import '../../../../services/api_base.dart';

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
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'user_token');

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
    return FutureBuilder<List<PurchaseTeamIndexModel>>(
      future: _fetchTeamsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _retry,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data tim pembelian'));
        }

        final teams = snapshot.data!
            .where(
              (team) =>
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
            childAspectRatio: 1.54,
          ),
          itemBuilder: (context, index) {
            final team = teams[index];

            return InkWell(
              onTap: () {
                if (widget.onTap != null) {
                  widget.onTap!(team.idPurchaseTeam);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName,
                        style: GoogleFonts.inter(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.black54, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              team.teamLeader,
                              style: GoogleFonts.notoSans(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          team.description,
                          style: GoogleFonts.notoSans(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
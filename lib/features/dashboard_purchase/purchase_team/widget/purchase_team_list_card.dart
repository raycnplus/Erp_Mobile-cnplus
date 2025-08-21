import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/purchase_team_index_models.dart';
import '../../../../services/api_base.dart';

class PurchaseTeamCardList extends StatefulWidget {
  final String searchQuery;
  const PurchaseTeamCardList({super.key, required this.searchQuery});

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
    // ... (Bagian FutureBuilder tetap sama)
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
            const cardColor = Color.fromRGBO(151, 176, 103, 1);
            const textColor = Color.fromRGBO(254, 250, 224, 1);

            // ...existing code...
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: cardColor,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1), // shadow tipis
                    blurRadius: 4.5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    left: 14,
                    right: 14,
                    child: Text(
                      team.teamName,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Positioned(
                    top: 38,
                    left: 17,
                    child: Icon(Icons.person, color: textColor, size: 16),
                  ),
                  Positioned(
                    top: 36,
                    left: 40,
                    right: 14,
                    child: Text(
                      team.teamLeader,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.notoSans(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Positioned(
                    top: 56,
                    left: 17,
                    right: 17,
                    bottom: 10,
                    child: Text(
                      team.description,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.notoSans(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
            // ...existing code...
          },
        );
      },
    );
  }
}

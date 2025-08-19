import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/purchase_team_index_models.dart';
import '../../../../services/api_base.dart';

class PurchaseTeamCardList extends StatelessWidget {
  const PurchaseTeamCardList({super.key});

  Future<List<PurchaseTeamIndexModel>> fetchTeams() async {
   final response = await http.get(
 Uri.parse('${ApiBase.baseUrl}/purchase/purchase-team/')
);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PurchaseTeamIndexModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data tim pembelian');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PurchaseTeamIndexModel>>(
      future: fetchTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data tim pembelian'));
        }

        final teams = snapshot.data!;
        return ListView.builder(
          itemCount: teams.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final team = teams[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(team.teamName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Leader: ${team.teamLeader}',
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(team.description),
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
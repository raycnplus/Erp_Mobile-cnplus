import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sales_team_show_model.dart';
import '../../../../../../services/api_base.dart';

class SalesTeamShowWidget extends StatelessWidget {
  // Changed from PurchaseTeamShowWidget
  final int teamId;

  const SalesTeamShowWidget({super.key, required this.teamId});

  Future<SalesTeamShowModel> fetchSalesTeam(int id) async {
    // Changed method name
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/sales/sales-team/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SalesTeamShowModel.fromJson(data);
    } else {
      throw Exception("Gagal ambil data sales team"); // Updated error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesTeamShowModel>(
      future: fetchSalesTeam(teamId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Data tidak ditemukan"));
        }

        final team = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile("Team Name", team.teamName),
              _buildInfoTile("Team Leader", team.teamLeaderName),
              _buildInfoTile("Description", team.description),
              _buildInfoTile("Created Date", team.createdDate),
              _buildInfoTile("Created By", team.createdBy.toString()),
              const SizedBox(height: 16),
              const Text(
                "Members",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: team.memberNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(team.memberNames[index]),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

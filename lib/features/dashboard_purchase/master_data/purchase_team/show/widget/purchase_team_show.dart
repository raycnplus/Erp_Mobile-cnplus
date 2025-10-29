//  isi file: lib/.../purchase_team/widget/purchase_team_show.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/purchase_team_show_model.dart';
import '../../../../../../services/api_base.dart';

class PurchaseTeamShowWidget extends StatefulWidget {
  final int teamId;
  const PurchaseTeamShowWidget({super.key, required this.teamId});

  @override
  State<PurchaseTeamShowWidget> createState() => _PurchaseTeamShowWidgetState();
}

class _PurchaseTeamShowWidgetState extends State<PurchaseTeamShowWidget> {
  late Future<PurchaseTeamShowModel> _fetchPurchaseTeamFuture;

  @override
  void initState() {
    super.initState();
    _fetchPurchaseTeamFuture = fetchPurchaseTeam(widget.teamId);
  }

  Future<PurchaseTeamShowModel> fetchPurchaseTeam(int id) async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse("${ApiBase.baseUrl}/purchase/purchase-team/$id"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PurchaseTeamShowModel.fromJson(data);
    } else {
      throw Exception("Failed to load purchase team details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PurchaseTeamShowModel>(
      future: _fetchPurchaseTeamFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}", textAlign: TextAlign.center));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No data found"));
        }

        final team = snapshot.data!;
        const primaryColor = Colors.blueAccent; // Warna utama untuk Purchase Team

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Kartu Info Utama ---
              _buildBaseCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha(38),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shopping_cart_checkout_outlined, color: primaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            team.teamName,
                            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),
                    _buildDetailRow(Icons.person_pin_outlined, "Team Leader", team.teamLeaderName, const Color(0xFF3B82F6)),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.description_outlined, "Description", team.description.isEmpty ? '-' : team.description, Colors.grey.shade600),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Kartu Anggota ---
              _buildBaseCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                       children: [
                         const Icon(Icons.groups_outlined, color: Color(0xFFF59E0B), size: 20),
                         const SizedBox(width: 8),
                         Text(
                           "Team Members (${team.memberNames.length})",
                           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                         ),
                       ],
                     ),
                    const Divider(height: 20, thickness: 1),
                    if (team.memberNames.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No members yet.", style: TextStyle(color: Colors.grey)),
                      ))
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: team.memberNames.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final memberName = team.memberNames[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              child: Text(
                                memberName.isNotEmpty ? memberName[0] : '?',
                                style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)
                              ),
                            ),
                            title: Text(memberName, style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w500)),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // --- Metadata ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Created on: ${team.createdDate} by ${team.createdBy}",
                    style: GoogleFonts.lato(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
               const SizedBox(height: 80), // Spacer untuk FAB
            ],
          ),
        );
      },
    );
  }

  Widget _buildBaseCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.lato(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
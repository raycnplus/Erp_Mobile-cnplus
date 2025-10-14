// lib/features/dashboard_sales/master data/sales_team/index/screen/sales_team_index_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/sales_team_list_card.dart';
import '../../create/screen/sales_team_screen_create.dart';
import '../../show/screen/sales_team_show_screen.dart';

class SalesTeamScreen extends StatefulWidget {
  const SalesTeamScreen({super.key});

  @override
  State<SalesTeamScreen> createState() => _SalesTeamScreenState();
}

class _SalesTeamScreenState extends State<SalesTeamScreen> {
  String searchQuery = '';
  // --- Tipe GlobalKey ini sekarang sudah benar ---
  final GlobalKey<SalesTeamCardListState> _listKey = GlobalKey<SalesTeamCardListState>();

  void _refreshSalesTeamList() {
    _listKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF679436);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sales Team", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Sales team management', style: GoogleFonts.lato(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SalesTeamCardList(
          key: _listKey,
          searchQuery: searchQuery,
          onTap: (teamId) async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SalesTeamShowScreen(teamId: teamId),
              ),
            );
            if (result == true && mounted) {
              _refreshSalesTeamList();
            }
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: primaryGreen.withAlpha(100),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SalesTeamScreenCreate(),
              ),
            );
            if (result == true && mounted) {
              _refreshSalesTeamList();
            }
          },
          backgroundColor: primaryGreen,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
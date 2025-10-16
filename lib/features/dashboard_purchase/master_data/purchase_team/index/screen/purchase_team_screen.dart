// Ganti seluruh isi file: lib/.../purchase_team/screen/purchase_team_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/purchase_team_list_card.dart';
import '../../creeate/screen/purchase_team_screen_create.dart';
import '../../show/screen/purchase_team_show_screen.dart';

class PurchaseTeamScreen extends StatefulWidget {
  const PurchaseTeamScreen({super.key});

  @override
  State<PurchaseTeamScreen> createState() => _PurchaseTeamScreenState();
}

class _PurchaseTeamScreenState extends State<PurchaseTeamScreen> {
  // ✅ Variabel searchQuery sudah dihapus
  final GlobalKey<PurchaseTeamCardListState> _listKey = GlobalKey<PurchaseTeamCardListState>();

  void _refreshPurchaseTeamList() {
    _listKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.blueAccent;

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
            Text("Purchase Team", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Purchase team management', style: GoogleFonts.lato(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      // ✅ Body diubah, Column dan TextField dihapus
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: PurchaseTeamCardList(
          key: _listKey,
          onTap: (teamId) async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PurchaseTeamShowScreen(teamId: teamId),
              ),
            );
            if (result == true && mounted) {
              _refreshPurchaseTeamList();
            }
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: primaryColor.withAlpha(100),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PurchaseTeamScreenCreate()),
            );
            if (result == true && mounted) {
              _refreshPurchaseTeamList();
            }
          },
          backgroundColor: primaryColor,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
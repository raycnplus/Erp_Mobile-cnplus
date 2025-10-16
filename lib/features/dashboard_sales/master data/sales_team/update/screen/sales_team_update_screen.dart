import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/sales_team_update_widget.dart';

class SalesTeamScreenUpdate extends StatelessWidget {
  final int id;

  const SalesTeamScreenUpdate({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Update Sales Team",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 20),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SalesTeamUpdateForm(id: id),
    );
  }
}

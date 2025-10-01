import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/purchase_team_form.dart';

class PurchaseTeamScreenCreate extends StatelessWidget {
  const PurchaseTeamScreenCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Create Purchase Team",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 20
          ),
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: const PurchaseTeamForm(),
    );
  }
}
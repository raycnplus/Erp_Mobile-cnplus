import 'package:erp_mobile_cnplus/features/dashboard_sales/master%20data/sales_team/create/widget/sales_team_create_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SalesTeamScreenCreate extends StatelessWidget {
  const SalesTeamScreenCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Create Sales Team",
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
      body: const SalesTeamForm(),
    );
  }
}
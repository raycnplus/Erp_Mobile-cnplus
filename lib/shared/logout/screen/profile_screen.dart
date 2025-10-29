import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/profile_body_widget.dart'; // Sesuaikan path jika perlu

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang bersih
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, // Sedikit lebih tipis dari w700
            fontSize: 20,
            color: Colors.blueGrey.shade900, // Warna grafit pekat
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.8, // Shadow sangat tipis
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blueGrey.shade900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const ProfileBodyWidget(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart'; // Sesuaikan path
import '../services/auth_service.dart'; // Sesuaikan path
import 'dart:ui' as ui; // Untuk BackdropFilter

class ProfileBodyWidget extends StatefulWidget {
  const ProfileBodyWidget({super.key});

  @override
  State<ProfileBodyWidget> createState() => _ProfileBodyWidgetState();
}

class _ProfileBodyWidgetState extends State<ProfileBodyWidget> {
  final AuthService _authService = AuthService();
  late Future<Profile> _profileFuture;

  // [BARU] Definisikan warna palet kita
  static const Color _primaryColor = Color(0xFF00796B); // Teal Tua (Colors.teal.shade700)
  static const Color _dangerColor = Color(0xFFD32F2F); // Merah Tua (Colors.red.shade700)
  static const Color _textTitleColor = Color(0xFF37474F); // Grafit (Colors.blueGrey.shade800)
  static const Color _textSubtitleColor = Color(0xFF607D8B); // Grafit Cerah (Colors.blueGrey.shade500)
  static const Color _avatarBgColor = Color(0xFFE0F2F1); // Teal Sangat Cerah (Colors.teal.shade50)
  static const Color _avatarIconColor = Color(0xFF00695C); // Teal Pekat (Colors.teal.shade800)
  static const Color _dangerBgColor = Color(0xFFFEEBEE); // Merah Sangat Cerah (Colors.red.shade50)


  @override
  void initState() {
    super.initState();
    _profileFuture = _authService.getProfile();
  }

  // Fungsi untuk menampilkan konfirmasi logout
  Future<void> _confirmLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, color: _dangerColor, size: 60.0), // [WARNA BARU]
                  const SizedBox(height: 28),
                  Text(
                    "Sesi Anda Akan Berakhir",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: _textTitleColor), // [WARNA BARU]
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Apakah Anda yakin ingin keluar dari akun ini?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 15, color: _textSubtitleColor), // [WARNA BARU]
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textSubtitleColor, // [WARNA BARU]
                            side: BorderSide(color: Colors.grey.shade300), // [WARNA BARU]
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text("Batal", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _dangerColor, // [WARNA BARU]
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 2, // Shadow halus
                            shadowColor: _dangerColor.withOpacity(0.5),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Keluar", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)), // [TEKS DIUBAH]
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      if (!mounted) return;
      await _authService.logout(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _primaryColor)); // [WARNA BARU]
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}", style: GoogleFonts.poppins(color: _dangerColor))); // [WARNA BARU]
        }
        if (!snapshot.hasData) {
          return Center(child: Text("Data profil tidak ditemukan.", style: GoogleFonts.poppins(color: Colors.grey)));
        }

        final profile = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Padding dikurangi sedikit
          child: Column(
            children: [
              // Bagian Header Profil
              _buildProfileHeader(profile),
              const SizedBox(height: 16),

              // Bagian Detail Profil
              _buildProfileDetails(profile),
              const SizedBox(height: 24), // Spasi sebelum tombol logout

              // Tombol Logout
              _buildLogoutButton(),
              const SizedBox(height: 16), // Padding di bawah
            ],
          ),
        );
      },
    );
  }

  // Widget terpisah untuk header profil
  Widget _buildProfileHeader(Profile profile) {
    return Card(
      elevation: 4, // [DIUBAH] Shadow sedikit dikurangi
      shadowColor: Colors.black.withOpacity(0.06), // [DIUBAH] Shadow lebih lembut
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // [DIUBAH] Radius dikurangi
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50, // [DIUBAH] Ukuran dikurangi
              backgroundColor: _avatarBgColor, // [WARNA BARU]
              backgroundImage: (profile.imageUrl != null && profile.imageUrl!.isNotEmpty)
                  ? NetworkImage(profile.imageUrl!)
                  : null,
              child: (profile.imageUrl == null || profile.imageUrl!.isEmpty)
                  ? Icon(
                      Icons.person_outline, // [ICON DIUBAH]
                      size: 50, // [DIUBAH] Ukuran ikon disesuaikan
                      color: _avatarIconColor, // [WARNA BARU]
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22, // [DIUBAH] Ukuran disesuaikan
                fontWeight: FontWeight.w600, // [DIUBAH] Sedikit lebih tipis
                color: _textTitleColor, // [WARNA BARU]
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.username,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15, // [DIUBAH] Ukuran disesuaikan
                color: _textSubtitleColor, // [WARNA BARU]
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget terpisah untuk detail profil
  Widget _buildProfileDetails(Profile profile) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            _buildDetailTile(
              icon: Icons.alternate_email, // [ICON DIUBAH]
              title: "Email",
              subtitle: profile.email,
            ),
            _buildDetailTile(
              icon: Icons.badge_outlined,
              title: "Posisi",
              subtitle: profile.position ?? 'Belum ditentukan',
            ),
            _buildDetailTile(
              icon: Icons.corporate_fare_outlined, // [ICON DIUBAH]
              title: "Departemen",
              subtitle: profile.department ?? 'Belum ditentukan',
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk ListTile detail
  Widget _buildDetailTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor, size: 26), // [WARNA & UKURAN BARU]
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _textSubtitleColor, // [WARNA BARU]
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 15, // [DIUBAH] Ukuran disesuaikan
          fontWeight: FontWeight.w600,
          color: _textTitleColor, // [WARNA BARU]
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // [PADDING DIUBAH]
    );
  }

  // Widget terpisah untuk tombol logout
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout_rounded, size: 20), // [DIUBAH] Ukuran ikon
        label: Text("Keluar", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)), // [DIUBAH] Ukuran font
        onPressed: _confirmLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: _dangerBgColor, // [WARNA BARU]
          foregroundColor: _dangerColor, // [WARNA BARU]
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15), // [DIUBAH] Padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // [DIUBAH] Radius
            side: BorderSide(color: Colors.red.shade100, width: 1), // [WARNA BARU]
          ),
        ),
      ),
    );
  }
}
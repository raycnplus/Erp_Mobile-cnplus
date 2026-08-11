import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../controllers/profile_controller.dart';

class ProfileBodyWidget extends StatelessWidget {
  const ProfileBodyWidget({super.key});

  static const Color _primaryColor = Color(0xFF00796B);
  static const Color _dangerColor = Color(0xFFD32F2F);
  static const Color _textTitleColor = Color(0xFF37474F);
  static const Color _textSubtitleColor = Color(0xFF607D8B);
  static const Color _avatarBgColor = Color(0xFFE0F2F1);
  static const Color _avatarIconColor = Color(0xFF00695C);
  static const Color _dangerBgColor = Color(0xFFFEEBEE);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _primaryColor),
          );
        }

        if (controller.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: _dangerColor),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat profil',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textTitleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: _textSubtitleColor),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.loadProfile(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.profile == null) {
          return Center(
            child: Text(
              'Data profil tidak ditemukan.',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          );
        }

        final profile = controller.profile!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(profile),
              const SizedBox(height: 16),
              _buildProfileDetails(profile),
              const SizedBox(height: 24),
              _buildLogoutButton(context, controller),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(dynamic profile) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: _avatarBgColor,
              backgroundImage: (profile.imageUrl != null && profile.imageUrl!.isNotEmpty)
                  ? NetworkImage(profile.imageUrl!)
                  : null,
              child: (profile.imageUrl == null || profile.imageUrl!.isEmpty)
                  ? const Icon(
                      Icons.person_outline,
                      size: 50,
                      color: _avatarIconColor,
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              profile.fullName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: _textTitleColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.username,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: _textSubtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails(dynamic profile) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            _buildDetailTile(
              icon: Icons.alternate_email,
              title: "Email",
              subtitle: profile.email,
            ),
            _buildDetailTile(
              icon: Icons.badge_outlined,
              title: "Posisi",
              subtitle: profile.position ?? 'Belum ditentukan',
            ),
            _buildDetailTile(
              icon: Icons.corporate_fare_outlined,
              title: "Departemen",
              subtitle: profile.department ?? 'Belum ditentukan',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor, size: 26),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _textSubtitleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _textTitleColor,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ProfileController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: Text(
          "Keluar",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _confirmLogout(context, controller),
        style: ElevatedButton.styleFrom(
          backgroundColor: _dangerBgColor,
          foregroundColor: _dangerColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red.shade100, width: 1),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, ProfileController controller) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
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
                  const Icon(Icons.error_outline_rounded, color: _dangerColor, size: 60.0),
                  const SizedBox(height: 28),
                  Text(
                    "Sesi Anda Akan Berakhir",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textTitleColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Apakah Anda yakin ingin keluar dari akun ini?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 15, color: _textSubtitleColor),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _textSubtitleColor,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                          child: Text("Batal", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _dangerColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 2,
                            shadowColor: _dangerColor.withOpacity(0.5),
                          ),
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                          child: Text("Keluar", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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

    if (confirmed == true && context.mounted) {
      final success = await controller.performLogout();
      
      if (success && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
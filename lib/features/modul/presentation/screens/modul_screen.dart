import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'package:erp_mobile_cnplus/features/modul/data/modul_config.dart';
import 'package:erp_mobile_cnplus/features/modul/presentation/widgets/modul_card.dart';
import 'package:erp_mobile_cnplus/features/modul/presentation/controllers/modul_controller.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';
import 'package:erp_mobile_cnplus/shared/widgets/fade_in_up.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/screens/login_screen.dart';

class ModulScreen extends StatefulWidget {
  const ModulScreen({super.key});

  @override
  State<ModulScreen> createState() => _ModulScreenState();
}

class _ModulScreenState extends State<ModulScreen> {
  late ModulController _modulController;

  @override
  void initState() {
    super.initState();
    _modulController = getIt<ModulController>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _modulController.initialize();
    });
  }

  Future<void> _handleRefresh() async {
    await _modulController.refresh();
  }

  Future<void> _handleGoToProfile() async {
    Navigator.pushNamed(context, AppRoutes.profile);
     Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      final success = await _modulController.logout();
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ModulController>.value(
      value: _modulController,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Consumer<ModulController>(
            builder: (context, controller, _) {
              if (controller.isLoading) return const Text('Loading...');
              return Text(
                'Hi, ${controller.userName}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              );
            },
          ),
          actions: [
            Consumer<ModulController>(
              builder: (context, controller, _) {
                final name = controller.userName ?? '';
                final initials = name.trim().split(' ')
                    .where((w) => w.isNotEmpty)
                    .take(2)
                    .map((w) => w[0].toUpperCase())
                    .join();

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: PopupMenuButton<String>(
                    offset: const Offset(0, 52),
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    onSelected: (value) {
                      if (value == 'profile') _handleGoToProfile();
                      if (value == 'logout') _handleLogout();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        enabled: false,
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.amber.shade100,
                              child: Text(
                                initials.isEmpty ? '?' : initials,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber.shade800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const PopupMenuDivider(height: 1),

                      PopupMenuItem(
                        value: 'profile',
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline_rounded,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 12),
                            Text('Profile',
                                style: GoogleFonts.poppins(fontSize: 14)),
                          ],
                        ),
                      ),

                      const PopupMenuDivider(height: 1),

                      PopupMenuItem(
                        value: 'logout',
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(Icons.logout_rounded,
                                size: 18, color: Colors.red.shade400),
                            const SizedBox(width: 12),
                            Text(
                              'Log out',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.amber.shade100,
                      child: Text(
                        initials.isEmpty ? '?' : initials,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<ModulController>(
          builder: (context, controller, _) {
            if (controller.status == ModulStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage ?? 'An error occurred',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.errorMessage?.contains('Session expired') == true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        } else {
                          controller.initialize();
                        }
                      },
                      child: Text(
                        controller.errorMessage?.contains('Session expired') == true
                            ? 'Login Again'
                            : 'Retry',
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.status == ModulStatus.loading && controller.currentUser == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RefreshIndicator(
              onRefresh: _handleRefresh,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: Text(
                            "Welcome Back,",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: Text(
                            "Select a module to open its dashboard.",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        ...controller.modules.asMap().entries.map((entry) {
                          final index  = entry.key;
                          final modul  = entry.value;
                          final config = modulConfigMap[modul.key];

                          if (config == null) return const SizedBox.shrink();

                          return FadeInUp(
                            delay: Duration(milliseconds: 400 + (index * 100)),
                            child: ModulCard(
                              label:                modul.name,
                              description:          modul.subtitle,
                              imagePath:            config.imagePath,
                              iconBackgroundColor:  config.iconBackgroundColor,
                              iconColor:            config.iconColor,
                              onTap: config.route != null
                                  ? () => Navigator.pushNamed(context, config.route!)
                                  : null,
                            ),
                          );
                        }),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
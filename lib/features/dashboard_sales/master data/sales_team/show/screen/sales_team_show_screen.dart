// lib/features/dashboard_sales/master data/sales_team/show/screen/sales_team_show_screen.dart

import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../services/api_base.dart';
import '../widget/sales_team_show_widget.dart';
import '../../update/screen/sales_team_update_screen.dart';

class SalesTeamShowScreen extends StatefulWidget {
  final int teamId;

  const SalesTeamShowScreen({super.key, required this.teamId});

  @override
  State<SalesTeamShowScreen> createState() => _SalesTeamShowScreenState();
}

class _SalesTeamShowScreenState extends State<SalesTeamShowScreen> {
  Key _childKey = UniqueKey();
  bool _hasBeenModified = false;

  // ✅ Navigasi ke halaman update
  Future<void> _navigateToUpdate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalesTeamScreenUpdate(id: widget.teamId),
      ),
    );

    if (result == true) {
      setState(() {
        _hasBeenModified = true;
        _childKey = UniqueKey(); // refresh widget detail setelah update
      });
    }
  }

  Future<void> _confirmAndDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.delete_outline_rounded, color: Color(0xFFF35D5D), size: 50.0),
                  const SizedBox(height: 28),
                  Text(
                    "Anda yakin ingin menghapus tim ini?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Semua data terkait akan hilang permanen.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      "Ya, Hapus",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      "Batalkan",
                      style: GoogleFonts.poppins(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                    ),
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
      _deleteTeam();
    }
  }

  Future<void> _deleteTeam() async {
    final storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http.delete(
        Uri.parse("${ApiBase.baseUrl}/sales/sales-team/${widget.teamId}"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      Navigator.pop(context); // tutup loading

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) {
          setState(() => _hasBeenModified = true);
          Navigator.pop(context, _hasBeenModified);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tim berhasil dihapus"), backgroundColor: Colors.green),
          );
        }
      } else {
        final body = json.decode(response.body);
        throw Exception(body['message'] ?? 'Gagal menghapus tim');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.pop(context, _hasBeenModified);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
            onPressed: () => Navigator.pop(context, _hasBeenModified),
          ),
          title: Text(
            "Detail Tim Penjualan",
            style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Hapus Tim',
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: _confirmAndDelete,
            ),
          ],
        ),
        body: SalesTeamShowWidget(key: _childKey, teamId: widget.teamId),
        floatingActionButton: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: FloatingActionButton.extended(
            onPressed: _navigateToUpdate,
            label: Text(
              'Edit Team',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            backgroundColor: const Color(0xFF679436),
          ),
        ),
      ),
    );
  }
}

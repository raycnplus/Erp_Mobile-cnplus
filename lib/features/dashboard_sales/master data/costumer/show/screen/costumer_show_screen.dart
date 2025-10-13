// lib/features/dashboard_sales/master data/costumer/show/screen/costumer_show_screen.dart

import 'dart:ui' as ui;
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../../services/api_base.dart';
import '../widget/costumer_show_widget.dart';
import '../../update/screen/costumer_update_screen.dart';
import '../../../../../../shared/widgets/success_bottom_sheet.dart';

class CustomerShowScreen extends StatefulWidget {
  final int id;
  final String? customerName;

  const CustomerShowScreen({
    super.key,
    required this.id,
    this.customerName,
  });

  @override
  State<CustomerShowScreen> createState() => _CustomerShowScreenState();
}

class _CustomerShowScreenState extends State<CustomerShowScreen> {
  Key _childKey = UniqueKey();
  bool _hasBeenUpdated = false;

  Future<void> _navigateToUpdate() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) {
          return CustomerUpdateScreen(
              id: widget.id, scrollController: controller);
        },
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _hasBeenUpdated = true;
        _childKey = UniqueKey();
      });

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const SuccessBottomSheet(
          title: "Successfully Updated!",
          message: "The customer data has been updated.",
          themeColor: Color(0xFF4A90E2),
        ),
      );
    }
  }

  Future<bool> _deleteCustomer() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/sales/customer/${widget.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      try {
        final body = json.decode(response.body); // <-- INI YANG MENYEBABKAN ERROR
        throw Exception(body['message'] ?? 'Gagal menghapus data');
      } catch (_) {
        throw Exception('Gagal menghapus data. Status: ${response.statusCode}');
      }
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.delete_outline_rounded,
                      color: Color(0xFFF35D5D), size: 50.0),
                  const SizedBox(height: 28),
                  Text(
                    "Anda yakin ingin menghapus\n'${widget.customerName ?? 'customer ini'}'?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tindakan ini tidak dapat dibatalkan.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Ya, Hapus",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("Batalkan",
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600)),
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await _deleteCustomer();
        if (!mounted) return;
        Navigator.pop(context); // Tutup loading

        setState(() => _hasBeenUpdated = true);
        
        Navigator.pop(context, _hasBeenUpdated);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Tutup loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceFirst("Exception: ", "")),
              backgroundColor: Colors.red),
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
        Navigator.pop(context, _hasBeenUpdated);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54),
            onPressed: () => Navigator.pop(context, _hasBeenUpdated),
          ),
          title: Text(
            widget.customerName ?? "Customer Detail",
            style: GoogleFonts.poppins(
                color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Hapus Customer',
              icon:
                  const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: _confirmAndDelete,
            ),
          ],
        ),
        body: CustomerShowWidget(
          key: _childKey,
          id: widget.id,
        ),
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
            label: Text('Edit Customer',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.white)),
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            backgroundColor: Color(0xFF679436),
          ),
        ),
      ),
    );
  }
}
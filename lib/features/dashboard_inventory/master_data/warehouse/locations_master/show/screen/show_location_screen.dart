// show_location_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widget/show_location_widget.dart';
import '../../update/models/update_location_models.dart';
import '../../update/screen/update_location_screen.dart';
import '../../../../../../../services/api_base.dart';

class LocationShowScreen extends StatefulWidget {
  final int idLocation;

  const LocationShowScreen({super.key, required this.idLocation});

  @override
  State<LocationShowScreen> createState() => _LocationShowScreenState();
}

class _LocationShowScreenState extends State<LocationShowScreen> {
  final storage = const FlutterSecureStorage();
  Key _childKey = UniqueKey();
  bool _hasBeenUpdated = false;

  Future<LocationUpdateModel> _fetchUpdateModel() async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Authentication token not found.');
    }
    
    final resp = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/${widget.idLocation}'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (resp.statusCode == 200) {
      final decoded = jsonDecode(resp.body);
      return LocationUpdateModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch details: Status ${resp.statusCode}');
    }
  }

  // --- LOGIKA UNTUK EDIT ---
  Future<void> _onEdit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final model = await _fetchUpdateModel();
      if (!mounted) return;
      Navigator.pop(context); // Tutup dialog loading

      final updated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => LocationUpdateScreen(location: model),
        ),
      );

      if (updated == true && mounted) {
        setState(() {
          _hasBeenUpdated = true;
          _childKey = UniqueKey(); // Paksa child widget untuk refresh datanya
        });
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup dialog loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Gagal membuka editor: $e'),
            backgroundColor: Colors.redAccent),
      );
    }
  }

  // --- LOGIKA BARU UNTUK DELETE ---
  Future<bool> _deleteLocation() async {
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/${widget.idLocation}'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    return response.statusCode == 200;
  }

  Future<void> _confirmAndDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete this location? This action cannot be undone.', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
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
        final success = await _deleteLocation();
        if (mounted) Navigator.pop(context); // Tutup loading

        if (success) {
          // Kirim 'true' kembali ke halaman index untuk refresh
          if (mounted) Navigator.pop(context, true); 
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to delete location."), backgroundColor: Colors.red),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Tutup loading
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasBeenUpdated);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context, _hasBeenUpdated),
          ),
          title: Text("Location Detail", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          actions: [
            // --- TOMBOL DELETE SEKARANG ADA DI DALAM MENU ---
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _confirmAndDelete();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: LocationShowWidget(
          key: _childKey,
          idLocation: widget.idLocation,
        ),
        // --- TOMBOL EDIT MENJADI FLOATING ACTION BUTTON ---
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _onEdit,
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          label: Text('Edit Location', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
          backgroundColor: const Color(0xFF679436),
        ),
      ),
    );
  }
}
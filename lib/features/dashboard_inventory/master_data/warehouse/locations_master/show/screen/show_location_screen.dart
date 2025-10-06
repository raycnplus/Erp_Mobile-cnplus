import 'dart:convert';
import 'package:flutter/material.dart';
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

  // ▼▼▼ FUNGSI INI TELAH DIPERBAIKI ▼▼▼
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
      // PERBAIKAN: Langsung parse dari body, karena respons API tidak di-nest dalam key 'data'
      final decoded = jsonDecode(resp.body);
      return LocationUpdateModel.fromJson(decoded as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch details: Status ${resp.statusCode}');
    }
  }

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
          title: const Text("Location Detail"),
          actions: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _onEdit,
            )
          ],
        ),
        body: LocationShowWidget(
          key: _childKey,
          idLocation: widget.idLocation,
        ),
      ),
    );
  }
}
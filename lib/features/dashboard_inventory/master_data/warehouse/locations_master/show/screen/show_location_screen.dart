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
  Key _childKey = UniqueKey(); // ganti key utk force rebuild

  Future<LocationUpdateModel> _fetchUpdateModel() async {
    final token = await storage.read(key: 'token');
    final resp = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/${widget.idLocation}'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to fetch detail for edit: ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return LocationUpdateModel(
      idLocation: data['id_location'] as int,
      idWarehouse: data['id_warehouse'] is int
          ? data['id_warehouse']
          : int.tryParse('${data['id_warehouse']}') ?? 0,
      locationName: (data['location_name'] ?? '') as String,
      locationCode: (data['location_code'] ?? '') as String,
      warehouseName: (data['warehouse_name'] ?? '') as String,
      parentLocationName: (data['parent_location_name'] ?? '') as String,
      parentLocationId: data['parent_location_id'] as int?, // boleh null
      height: (data['height'] ?? 0) is int
          ? data['height']
          : int.tryParse('${data['height']}') ?? 0,
      length: (data['length'] ?? 0) is int
          ? data['length']
          : int.tryParse('${data['length']}') ?? 0,
      width: (data['width'] ?? 0) is int
          ? data['width']
          : int.tryParse('${data['width']}') ?? 0,
      volume: (data['volume'] ?? '0').toString(),
      description: (data['description'] ?? '') as String,
    );
  }

  Future<void> _onEdit() async {
    try {
      final model = await _fetchUpdateModel();
      if (!mounted) return;
      final updated = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LocationUpdateScreen(location: model),
        ),
      );
      if (updated == true && mounted) {
        setState(() {
          _childKey = UniqueKey(); // paksa LocationShowWidget re-init & refetch
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka editor: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Detail"),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: _onEdit,
          )
        ],
      ),
      body: LocationShowWidget(
        key: _childKey,                
        idLocation: widget.idLocation,
      ),
    );
  }
}

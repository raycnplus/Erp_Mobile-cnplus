import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../services/api_base.dart';
import '../models/update_location_models.dart';

class LocationUpdateWidget extends StatefulWidget {
  final LocationUpdateModel location;

  const LocationUpdateWidget({super.key, required this.location});

  @override
  State<LocationUpdateWidget> createState() => _LocationUpdateWidgetState();
}

class _LocationUpdateWidgetState extends State<LocationUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _volumeController;
  late TextEditingController _descriptionController;

  List<WarehouseDropdownModel> warehouses = [];
  List<LocationDropdownModel> parentLocations = [];
  WarehouseDropdownModel? selectedWarehouse;
  LocationDropdownModel? selectedParent;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.locationName);
    _codeController = TextEditingController(text: widget.location.locationCode);
    _lengthController = TextEditingController(
      text: widget.location.length.toString(),
    );
    _widthController = TextEditingController(
      text: widget.location.width.toString(),
    );
    _heightController = TextEditingController(
      text: widget.location.height.toString(),
    );
    _volumeController = TextEditingController(
      text: widget.location.volume.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.location.description,
    );

    _fetchWarehouses();
    _fetchParentLocations();
  }

  Future<void> _fetchWarehouses() async {
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token not found, please login.")),
      );
      return;
    }

    final res = await http.get(
      Uri.parse("${ApiBase.baseUrl}/inventory/warehouse"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    // debug
    print("fetchWarehouses status: ${res.statusCode}");
    print("fetchWarehouses body snippet: ${res.body.substring(0, res.body.length > 200 ? 200 : res.body.length)}");

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List<dynamic> list =
          decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);
      setState(() {
        warehouses = list.map((json) => WarehouseDropdownModel.fromJson(json)).toList();
        selectedWarehouse = warehouses.firstWhere(
          (w) => w.idWarehouse == widget.location.idWarehouse,
          orElse: () => warehouses.isNotEmpty
              ? warehouses.first
              : WarehouseDropdownModel(idWarehouse: 0, warehouseName: "No Warehouse"),
        );
      });
    } else {
      // handle non-200
      print("fetchWarehouses failed: ${res.statusCode} / ${res.body}");
    }
  }

  Future<void> _fetchParentLocations() async {
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) return;

    final res = await http.get(
      Uri.parse("${ApiBase.baseUrl}/inventory/location"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("fetchParentLocations status: ${res.statusCode}");

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List<dynamic> list =
          decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);
      setState(() {
        parentLocations = list.map((json) => LocationDropdownModel.fromJson(json)).toList();
        if (widget.location.parentLocationId != null) {
          selectedParent = parentLocations.firstWhere(
            (l) => l.idLocation == widget.location.parentLocationId,
            orElse: () => parentLocations.isNotEmpty
                ? parentLocations.first
                : LocationDropdownModel(idLocation: 0, locationName: "No Parent"),
          );
        }
      });
    } else {
      print("fetchParentLocations failed: ${res.statusCode} / ${res.body}");
    }
  }

  Future<void> _updateLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: 'token');
    final response = await http.put(
      Uri.parse(
        "${ApiBase.baseUrl}/inventory/location/${widget.location.idLocation}",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "location_name": _nameController.text,
        "location_code": _codeController.text,
        "warehouse_id": selectedWarehouse?.idWarehouse,
        "parent_location_id": selectedParent?.idLocation,
        "length": int.tryParse(_lengthController.text) ?? 0,
        "width": int.tryParse(_widthController.text) ?? 0,
        "height": int.tryParse(_heightController.text) ?? 0,
        "volume": int.tryParse(_volumeController.text) ?? 0,
        "description": _descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location updated successfully")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Location Name"),
            validator: (value) => value!.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Location Code"),
            validator: (value) => value!.isEmpty ? "Required" : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<WarehouseDropdownModel>(
            value: selectedWarehouse,
            items: warehouses
                .map(
                  (w) =>
                      DropdownMenuItem(value: w, child: Text(w.warehouseName)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedWarehouse = value);
            },
            decoration: const InputDecoration(labelText: "Warehouse"),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LocationDropdownModel>(
            value: selectedParent,
            items: parentLocations
                .map(
                  (l) =>
                      DropdownMenuItem(value: l, child: Text(l.locationName)),
                )
                .toList(),
            onChanged: (value) {
              setState(() => selectedParent = value);
            },
            decoration: const InputDecoration(labelText: "Parent Location"),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _lengthController,
            decoration: const InputDecoration(labelText: "Length"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _widthController,
            decoration: const InputDecoration(labelText: "Width"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(labelText: "Height"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _volumeController,
            decoration: const InputDecoration(labelText: "Volume"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateLocation,
            child: const Text("Update Location"),
          ),
        ],
      ),
    );
  }
}

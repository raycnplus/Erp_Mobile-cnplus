// update_location_widget.dart

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

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _volumeController;
  late TextEditingController _descriptionController;

  // State for dropdowns
  List<WarehouseDropdownModel> _warehouses = [];
  List<LocationDropdownModel> _parentLocations = [];
  WarehouseDropdownModel? _selectedWarehouse;
  LocationDropdownModel? _selectedParent;
  bool _isLoadingDropdowns = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from the widget's location model
    _nameController = TextEditingController(text: widget.location.locationName);
    _codeController = TextEditingController(text: widget.location.locationCode);
    _lengthController = TextEditingController(text: widget.location.length.toString());
    _widthController = TextEditingController(text: widget.location.width.toString());
    _heightController = TextEditingController(text: widget.location.height.toString());
    _volumeController = TextEditingController(text: widget.location.volume.toString());
    _descriptionController = TextEditingController(text: widget.location.description);

    // Fetch initial data for dropdowns
    _loadInitialDropdowns();
  }

  Future<void> _loadInitialDropdowns() async {
    // Fetch both dropdown data concurrently
    await Future.wait([
      _fetchWarehouses(),
      _fetchParentLocations(),
    ]);
    if (mounted) {
      setState(() {
        _isLoadingDropdowns = false;
      });
    }
  }

  Future<void> _fetchWarehouses() async {
    final token = await storage.read(key: 'token');
    if (token == null) return;

    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/warehouse"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List<dynamic> list = decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);
        
        final fetchedWarehouses = list.map((json) => WarehouseDropdownModel.fromJson(json)).toList();
        
        WarehouseDropdownModel? initialWarehouse;
        try {
          // Menggunakan properti 'warehouse' yang sudah diperbaiki
          initialWarehouse = fetchedWarehouses.firstWhere((w) => w.idWarehouse == widget.location.warehouse);
        } catch (e) {
          initialWarehouse = null; 
          debugPrint("Initial warehouse with ID ${widget.location.warehouse} not found in the list.");
        }

        if(mounted) {
          setState(() {
            _warehouses = fetchedWarehouses;
            _selectedWarehouse = initialWarehouse;
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch warehouses: $e");
    }
  }

  Future<void> _fetchParentLocations() async {
    final token = await storage.read(key: 'token');
    if (token == null) return;
    
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/location"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List<dynamic> list = decoded is Map && decoded['data'] is List ? decoded['data'] : (decoded is List ? decoded : []);

        final fetchedLocations = list.map((json) => LocationDropdownModel.fromJson(json)).toList();
        
        LocationDropdownModel? initialParent;
        // Menggunakan properti 'parentLocation' yang sudah diperbaiki
        if (widget.location.parentLocation != null) {
          try {
            initialParent = fetchedLocations.firstWhere((l) => l.idLocation == widget.location.parentLocation);
          } catch (e) {
            initialParent = null;
            debugPrint("Initial parent location with ID ${widget.location.parentLocation} not found in the list.");
          }
        }

        if(mounted) {
          setState(() {
            _parentLocations = fetchedLocations;
            _selectedParent = initialParent;
          });
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch parent locations: $e");
    }
  }

  Future<void> _updateLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: 'token');
    if (token == null) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication error. Please log in again.")));
      return;
    }

    try {
      final response = await http.put(
        Uri.parse("${ApiBase.baseUrl}/inventory/location/${widget.location.idLocation}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "location_name": _nameController.text,
          "location_code": _codeController.text,
          "warehouse": _selectedWarehouse?.idWarehouse,
          "parent_location": _selectedParent?.idLocation,
          "length": int.tryParse(_lengthController.text) ?? 0,
          "width": int.tryParse(_widthController.text) ?? 0,
          "height": int.tryParse(_heightController.text) ?? 0,
          "volume": _volumeController.text,
          "description": _descriptionController.text,
        }),
      );

      if (!mounted) return;
      
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('text/html')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication Failed. Please log in again."), backgroundColor: Colors.redAccent,),
        );
        return;
      }

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update: ${errorData['message'] ?? response.body}")),
        );
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _volumeController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Location Code"),
             validator: (value) => value == null || value.isEmpty ? "This field is required" : null,
          ),
          const SizedBox(height: 16),

          if (_isLoadingDropdowns)
            const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24.0), child: CircularProgressIndicator()))
          else
            Column(
              children: [
                DropdownButtonFormField<WarehouseDropdownModel>(
                  value: _selectedWarehouse,
                  items: _warehouses.map((w) => DropdownMenuItem(value: w, child: Text(w.warehouseName))).toList(),
                  onChanged: (value) {
                    setState(() => _selectedWarehouse = value);
                  },
                  decoration: const InputDecoration(labelText: "Warehouse", border: OutlineInputBorder()),
                  isExpanded: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<LocationDropdownModel>(
                  value: _selectedParent,
                  items: _parentLocations.map((l) => DropdownMenuItem(value: l, child: Text(l.locationName))).toList(),
                  onChanged: (value) {
                    setState(() => _selectedParent = value);
                  },
                  decoration: const InputDecoration(labelText: "Parent Location", border: OutlineInputBorder()),
                  isExpanded: true,
                ),
              ],
            ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _lengthController,
            decoration: const InputDecoration(labelText: "Length (cm)", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _widthController,
            decoration: const InputDecoration(labelText: "Width (cm)", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(labelText: "Height (cm)", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _volumeController,
            decoration: const InputDecoration(labelText: "Volume (cm³)", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateLocation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            child: const Text("Update Location"),
          ),
        ],
      ),
    );
  }
}
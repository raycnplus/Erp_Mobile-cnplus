import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/create_location_models.dart';

class LocationCreateWidget extends StatefulWidget {
  const LocationCreateWidget({super.key});

  @override
  State<LocationCreateWidget> createState() => _LocationCreateWidgetState();
}

class _LocationCreateWidgetState extends State<LocationCreateWidget> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<WarehouseDropdownModel> warehouses = [];
  List<LocationDropdownModel> parents = [];
  WarehouseDropdownModel? selectedWarehouse;
  LocationDropdownModel? selectedParent;

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
    fetchParentLocations();
  }

  String _snippet(String s, [int max = 300]) {
    if (s.isEmpty) return s;
    return s.length <= max ? s : s.substring(0, max);
  }

  Future<void> fetchWarehouses() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/warehouse'),
      headers: {
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );
    debugPrint("Warehouse response status: ${response.statusCode}");
    debugPrint("Warehouse response body: ${_snippet(response.body, 800)}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> parsedList = decoded is Map
          ? (decoded['data'] is List
                ? decoded['data']
                : (decoded['data'] == null && decoded['result'] is List
                      ? decoded['result']
                      : []))
          : (decoded is List ? decoded : []);
      setState(() {
        warehouses = parsedList
            .map(
              (e) => WarehouseDropdownModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        if (warehouses.isNotEmpty && selectedWarehouse == null) {
          selectedWarehouse = warehouses.first;
        }
      });
    } else {
      debugPrint('fetchWarehouses failed: ${response.statusCode}');
      // optional: show snack / dialog for non-200
    }
  }

  Future<void> fetchParentLocations() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location'),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      setState(() {
        parents = parsed.map((e) => LocationDropdownModel.fromJson(e)).toList();
      });
    }
  }

  Future<void> createLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: 'token');

    final model = LocationCreateModel(
      locationName: _nameController.text,
      locationCode: _codeController.text,
      warehouseId: selectedWarehouse!.idWarehouse,
      parentLocationId: selectedParent?.id,
      length: double.tryParse(_lengthController.text),
      width: double.tryParse(_widthController.text),
      height: double.tryParse(_heightController.text),
      volume: double.tryParse(_volumeController.text),
      description: _descriptionController.text,
    );

    final response = await http.post(
      Uri.parse('${ApiBase.baseUrl}/inventory/location'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location created successfully")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Location Name"),
              validator: (val) => val!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: "Location Code"),
              validator: (val) => val!.isEmpty ? "Required" : null,
            ),
            DropdownButtonFormField<WarehouseDropdownModel>(
              value: selectedWarehouse,
              items: warehouses.map((w) {
                return DropdownMenuItem(value: w, child: Text(w.warehouseName));
              }).toList(),
              onChanged: (val) => setState(() => selectedWarehouse = val),
              decoration: const InputDecoration(labelText: "Warehouse"),
            ),
            DropdownButtonFormField<LocationDropdownModel>(
              value: selectedParent,
              items: parents.map((p) {
                return DropdownMenuItem(value: p, child: Text(p.name));
              }).toList(),
              onChanged: (val) => setState(() => selectedParent = val),
              decoration: const InputDecoration(labelText: "Parent Location"),
            ),
            TextFormField(
              controller: _lengthController,
              decoration: const InputDecoration(labelText: "Length"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _widthController,
              decoration: const InputDecoration(labelText: "Width"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: "Height"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _volumeController,
              decoration: const InputDecoration(labelText: "Volume"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createLocation,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/show_location_models.dart';

class LocationShowWidget extends StatefulWidget {
  final int idLocation;

  const LocationShowWidget({super.key, required this.idLocation});

  @override
  State<LocationShowWidget> createState() => _LocationShowWidgetState();
}

class _LocationShowWidgetState extends State<LocationShowWidget> {
  final storage = const FlutterSecureStorage();
  late Future<LocationShowModel> futureLocation;

  Future<LocationShowModel> fetchLocation() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/${widget.idLocation}'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return LocationShowModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load location detail');
    }
  }

  @override
  void initState() {
    super.initState();
    futureLocation = fetchLocation();
  }

  Widget buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value ?? "-")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationShowModel>(
      future: futureLocation,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("No data available"));
        }

        final location = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildDetail("Location Name", location.locationName),
              buildDetail("Location Code", location.locationCode),
              buildDetail("Warehouse", location.warehouseName),
              buildDetail("Parent Location", location.parentLocationName),
              buildDetail("Length", location.length),
              buildDetail("Width", location.width),
              buildDetail("Height", location.height),
              buildDetail("Volume", location.volume),
              buildDetail("Description", location.description),
              buildDetail("Created On", location.createdOn),
              buildDetail("Created By", location.createdBy),
            ],
          ),
        );
      },
    );
  }
}

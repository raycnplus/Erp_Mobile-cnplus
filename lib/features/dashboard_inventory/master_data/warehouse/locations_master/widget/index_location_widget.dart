import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/index_location_models.dart';

class LocationListWidget extends StatefulWidget {
  const LocationListWidget({super.key});

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  final storage = const FlutterSecureStorage();
  late Future<List<LocationIndexModel>> futureLocations;

  Future<List<LocationIndexModel>> fetchLocations() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsed = jsonDecode(response.body);
      return parsed.map((json) => LocationIndexModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  void initState() {
    super.initState();
    futureLocations = fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LocationIndexModel>>(
      future: futureLocations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        final locations = snapshot.data!;
        return ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            final location = locations[index];
            return Card(
              child: ListTile(
                title: Text(location.locationName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Code: ${location.locationCode}"),
                    Text("Warehouse: ${location.warehouseName}"),
                    Text("Parent: ${location.parentLocationName}"),
                  ],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: ${location.locationName}")),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

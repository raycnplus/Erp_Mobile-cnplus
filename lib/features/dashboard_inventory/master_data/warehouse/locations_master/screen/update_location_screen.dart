import 'package:flutter/material.dart';
import '../models/update_location_models.dart';
import '../widget/update_location_widget.dart';

class LocationUpdateScreen extends StatelessWidget {
  final LocationUpdateModel location;

  const LocationUpdateScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Location"),
      ),
      body: LocationUpdateWidget(location: location),
    );
  }
}

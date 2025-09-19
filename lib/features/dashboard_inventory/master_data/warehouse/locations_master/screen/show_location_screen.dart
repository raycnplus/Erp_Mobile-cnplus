import 'package:flutter/material.dart';
import '../widget/show_location_widget.dart';

class LocationShowScreen extends StatelessWidget {
  final int idLocation;

  const LocationShowScreen({super.key, required this.idLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Detail")),
      body: LocationShowWidget(idLocation: idLocation), // panggil widget
    );
  }
}

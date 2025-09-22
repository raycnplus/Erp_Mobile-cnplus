import 'package:flutter/material.dart';
import '../widget/create_location_widget.dart';

class LocationCreateScreen extends StatelessWidget {
  const LocationCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Location")),
      body: LocationCreateWidget(),
    );
  }
}

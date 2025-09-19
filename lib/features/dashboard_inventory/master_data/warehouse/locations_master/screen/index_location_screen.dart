import 'package:flutter/material.dart';
import '../widget/index_location_widget.dart';

class LocationIndexScreen extends StatelessWidget {
  const LocationIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LocationListWidget(),
    );
  }
}

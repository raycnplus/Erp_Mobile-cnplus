import 'package:flutter/material.dart';
import '../widget/index_location_widget.dart';
import '../screen/show_location_screen.dart';
import '../screen/create_location_screen.dart';
import '../models/index_location_models.dart';

class LocationIndexScreen extends StatelessWidget {
  const LocationIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LocationListWidget(
        onTap: (LocationIndexModel location) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LocationShowScreen(
                idLocation: location.idLocation,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LocationCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

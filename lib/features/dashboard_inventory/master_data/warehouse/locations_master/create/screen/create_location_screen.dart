// create_location_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/create_location_widget.dart';

class LocationCreateScreen extends StatefulWidget {
  const LocationCreateScreen({super.key});

  @override
  State<LocationCreateScreen> createState() => _LocationCreateScreenState();
}

class _LocationCreateScreenState extends State<LocationCreateScreen> {
  int _currentStep = 0;
  int _totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Location (${_currentStep + 1}/$_totalSteps)",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1.0)),
      ),
      body: LocationCreateWidget(
        onStepChanged: (current, total) {
          setState(() {
            _currentStep = current;
            _totalSteps = total;
          });
        },
      ),
    );
  }
}